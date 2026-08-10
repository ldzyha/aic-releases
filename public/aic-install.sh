#!/usr/bin/env bash
# Public binary-only bootstrap. Download the complete bounded file before executing it. All
# executable work still starts in the final `main` call so a truncated copy cannot partially install.
set -Eeuo pipefail
umask 077

readonly AIC_PUBLIC_BASE="https://raw.githubusercontent.com/ldzyha/aic-releases/main/public"
readonly MAX_INDEX_BYTES=65536
readonly MAX_BUNDLE_BYTES=94371840
readonly MAX_ARCHIVE_ENTRIES=2048
readonly MAX_ARCHIVE_FILE_BYTES=268435456
readonly MAX_EXTRACTED_BYTES=536870912
install_tmp=""
archive_total_bytes=""
replace_legacy=0
repair_current=0
already_current=0

fail() {
	printf 'aic-release-install: %s\n' "$*" >&2
	exit 1
}
cleanup() {
	local status=$?
	trap - EXIT
	[ -z "$install_tmp" ] || rm -rf -- "$install_tmp"
	exit "$status"
}
interrupt() { exit "$1"; }

require_command() {
	command -v "$1" >/dev/null 2>&1 || fail "$1 is required by the binary installer"
}

download() {
	local url="$1" output="$2" maximum="$3"
	curl --disable --proto '=https' --proto-redir '=https' --tlsv1.2 --fail --location --silent --show-error \
		--retry 3 --retry-all-errors --connect-timeout 10 --max-time 600 --max-filesize "$maximum" \
		--output "$output" "$url"
	local size
	size=$(wc -c <"$output")
	[ "$size" -gt 0 ] && [ "$size" -le "$maximum" ] ||
		fail "downloaded file is empty or exceeds its byte limit"
}

try_capture_bounded_output() {
	local label="$1" output="$2"
	shift 2
	timeout --kill-after=1 5 "$@" 2>/dev/null | head -c 4097 >"$output" &&
		[ -s "$output" ] && [ "$(wc -c <"$output")" -le 4096 ]
}

capture_bounded_output() {
	local label="$1" output="$2"
	shift 2
	try_capture_bounded_output "$label" "$output" "$@" ||
		fail "$label failed, is empty, or exceeded its execution/output bound"
}

valid_value() {
	local kind="$1" value="$2"
	case "$kind" in
	version) [[ "$value" =~ ^(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})$ ]] ;;
	release_id | sha256) [[ "$value" =~ ^[0-9a-f]{64}$ ]] ;;
	file) [[ "$value" =~ ^aic-(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})\.(0|[1-9][0-9]{0,8})-linux-(x86_64|aarch64)\.tar\.gz$ ]] ;;
	bytes) [[ "$value" =~ ^[1-9][0-9]{0,8}$ ]] && [ "$((10#$value))" -le "$MAX_BUNDLE_BYTES" ] ;;
	*) return 1 ;;
	esac
}

valid_web_selector() {
	local value="$1"
	[ -n "$value" ] && [ "${#value}" -le 4096 ] && [ "$value" != / ] &&
		[[ "$value" =~ ^/[A-Za-z0-9_./@+:-]+$ ]] &&
		[[ "$value" != *//* ]] && [ "${value%/}" = "$value" ] &&
		[[ ! "$value" =~ (^|/)\.\.?(/|$) ]]
}

owner_real_directory() {
	local path="$1" mode mode_number
	[ -d "$path" ] && [ ! -L "$path" ] &&
		[ "$(realpath -e -- "$path" 2>/dev/null || true)" = "$path" ] &&
		[ "$(stat -c %u -- "$path" 2>/dev/null || true)" = "$(id -u)" ] || return 1
	mode=$(stat -c %a -- "$path" 2>/dev/null) || return 1
	[[ "$mode" =~ ^[0-7]{3,4}$ ]] || return 1
	mode_number=$((8#$mode))
	[ "$((mode_number & 8#022))" -eq 0 ]
}

validate_v1_uv_tool_link() {
	local installed="$1" target expected_target link_text first_line path
	[ "$replace_legacy" -eq 1 ] && [ "$installed" = "$HOME/.local/bin/aic" ] &&
		[ -L "$installed" ] && [ "$(stat -c %u -- "$installed" 2>/dev/null || true)" = "$(id -u)" ] ||
		return 1
	link_text=$(readlink -- "$installed") || return 1
	[ -n "$link_text" ] && [ "${#link_text}" -le 4096 ] &&
		[[ "$link_text" != *$'\n'* && "$link_text" != *$'\r'* && "$link_text" != *$'\t'* ]] || return 1
	expected_target="$HOME/.local/share/uv/tools/aic/bin/aic"
	target=$(realpath -e -- "$installed" 2>/dev/null) || return 1
	[ "$target" = "$expected_target" ] && [ -f "$target" ] && [ ! -L "$target" ] && [ -x "$target" ] &&
		[ "$(stat -c %u -- "$target" 2>/dev/null || true)" = "$(id -u)" ] &&
		[ "$(stat -c %s -- "$target" 2>/dev/null || true)" -le 1048576 ] || return 1
	for path in "$HOME" "$HOME/.local" "$HOME/.local/bin" "$HOME/.local/share" \
		"$HOME/.local/share/uv" "$HOME/.local/share/uv/tools" \
		"$HOME/.local/share/uv/tools/aic" "$HOME/.local/share/uv/tools/aic/bin"; do
		owner_real_directory "$path" || return 1
	done
	IFS= read -r first_line <"$target" || return 1
	[ "$first_line" = "#!$HOME/.local/share/uv/tools/aic/bin/python" ]
}

version_is_newer() {
	local left="$1" right="$2" left_major left_minor left_patch right_major right_minor right_patch
	IFS=. read -r left_major left_minor left_patch <<<"$left"
	IFS=. read -r right_major right_minor right_patch <<<"$right"
	left_major=$((10#$left_major)) left_minor=$((10#$left_minor)) left_patch=$((10#$left_patch))
	right_major=$((10#$right_major)) right_minor=$((10#$right_minor)) right_patch=$((10#$right_patch))
	[ "$left_major" -gt "$right_major" ] ||
		{ [ "$left_major" -eq "$right_major" ] && [ "$left_minor" -gt "$right_minor" ]; } ||
		{ [ "$left_major" -eq "$right_major" ] && [ "$left_minor" -eq "$right_minor" ] && [ "$left_patch" -gt "$right_patch" ]; }
}

validate_installed_release() {
	local installed="$HOME/.local/bin/aic" raw body field key value
	local installed_channel="" installed_version="" installed_release_id="" installed_digest=""
	local seen_channel=0 seen_version=0 seen_release_id=0 seen_digest=0
	local version_first='^\{"version":"([^"]+)","webManifestSha256":"([0-9a-f]{64})"\}$'
	local digest_first='^\{"webManifestSha256":"([0-9a-f]{64})","version":"([^"]+)"\}$'
	local -a fields=()
	{ [ -e "$installed" ] || [ -L "$installed" ]; } || return 0
	if [ -L "$installed" ]; then
		[ "$replace_legacy" -eq 1 ] ||
			fail "the existing AIC is a legacy uv tool symlink; rerun explicitly with --replace-legacy only for a trusted v1.0.81 install"
		validate_v1_uv_tool_link "$installed" ||
			fail "the existing AIC symlink is not the exact owner-controlled v1.0.81 uv tool entrypoint"
		printf 'aic-release-install: verified the v1.0.81 uv tool symlink for explicit transactional replacement\n' >&2
		return 0
	fi
	[ -f "$installed" ] && [ ! -L "$installed" ] && [ -x "$installed" ] ||
		fail "the existing AIC binary is not one safe executable file"
	if try_capture_bounded_output "the existing AIC binary update identity" \
		"$install_tmp/installed-update-identity.json" "$installed" binary-update-identity; then
		raw=$(<"$install_tmp/installed-update-identity.json")
		[[ "$raw" == \{*\} ]] ||
			fail "the existing AIC binary update identity is malformed; preserve it for manual review"
		body=${raw#\{}
		body=${body%\}}
		IFS=, read -r -a fields <<<"$body"
		[ "${#fields[@]}" -eq 4 ] ||
			fail "the existing AIC binary update identity must contain exactly four fields"
		for field in "${fields[@]}"; do
			if [[ "$field" =~ ^\"([A-Za-z][A-Za-z0-9]*)\":\"([^\"]*)\"$ ]]; then
				key=${BASH_REMATCH[1]}
				value=${BASH_REMATCH[2]}
			else
				fail "the existing AIC binary update identity has an unsupported JSON shape"
			fi
			case "$key" in
			channel)
				[ "$seen_channel" -eq 0 ] || fail "the existing AIC binary update identity repeats channel"
				seen_channel=1
				installed_channel=$value
				;;
			version)
				[ "$seen_version" -eq 0 ] || fail "the existing AIC binary update identity repeats version"
				seen_version=1
				installed_version=$value
				;;
			releaseIdentity)
				[ "$seen_release_id" -eq 0 ] || fail "the existing AIC binary update identity repeats releaseIdentity"
				seen_release_id=1
				installed_release_id=$value
				;;
			webManifestSha256)
				[ "$seen_digest" -eq 0 ] || fail "the existing AIC binary update identity repeats webManifestSha256"
				seen_digest=1
				installed_digest=$value
				;;
			*) fail "the existing AIC binary update identity contains unsupported field $key" ;;
			esac
		done
		[ "$seen_channel" -eq 1 ] && [ "$seen_version" -eq 1 ] &&
			[ "$seen_release_id" -eq 1 ] && [ "$seen_digest" -eq 1 ] ||
			fail "the existing AIC binary update identity is incomplete"
	else
		if ! try_capture_bounded_output "the existing AIC release identity" \
			"$install_tmp/installed-release-info.json" "$installed" release-info; then
			[ "$replace_legacy" -eq 1 ] ||
				fail "the existing AIC exposes neither binary update identity nor strict release-info; rerun explicitly with --replace-legacy only for a trusted legacy install"
			printf 'aic-release-install: explicitly replacing a legacy AIC binary; the paired installer retains rollback backup\n' >&2
			return 0
		fi
		raw=$(<"$install_tmp/installed-release-info.json")
		if [[ "$raw" =~ $version_first ]]; then
			installed_version=${BASH_REMATCH[1]}
			installed_digest=${BASH_REMATCH[2]}
		elif [[ "$raw" =~ $digest_first ]]; then
			installed_digest=${BASH_REMATCH[1]}
			installed_version=${BASH_REMATCH[2]}
		else
			fail "the existing AIC release-info is malformed; preserve it for manual review"
		fi
		installed_channel=pre-public
	fi
	valid_value version "$installed_version" || fail "the installed AIC version is invalid"
	valid_value sha256 "$installed_digest" || fail "the installed AIC web identity is invalid"
	case "$installed_channel" in
	public-binary)
		valid_value release_id "$installed_release_id" || fail "the installed public AIC release identity is invalid"
		;;
	source)
		[[ "$installed_release_id" = unbound || "$installed_release_id" =~ ^[0-9a-f]{40}$ ]] ||
			fail "the installed source AIC release identity is invalid"
		;;
	pre-public) ;;
	*) fail "the existing AIC has unsupported update channel $installed_channel" ;;
	esac
	if version_is_newer "$installed_version" "$version"; then
		fail "refusing to downgrade installed AIC $installed_version to public release $version"
	fi
	case "$installed_channel" in
	source)
		printf 'aic-release-install: migrating AIC %s from the source channel to the public binary channel\n' \
			"$installed_version" >&2
		;;
	pre-public)
		printf 'aic-release-install: migrating AIC %s from its strict pre-public release identity\n' \
			"$installed_version" >&2
		;;
	esac
	if [ "$installed_channel" = public-binary ] && [ "$installed_version" = "$version" ] &&
		{ [ "$installed_release_id" != "$release_id" ] || [ "$installed_digest" != "$web_manifest_sha256" ]; }; then
		fail "the public feed conflicts with the installed public identity for AIC $version"
	fi
	if [ "$installed_channel" = public-binary ] && [ "$installed_version" = "$version" ] &&
		[ "$installed_release_id" = "$release_id" ] && [ "$installed_digest" = "$web_manifest_sha256" ]; then
		if [ "$repair_current" -eq 0 ]; then
			already_current=1
		else
			printf 'aic-release-install: explicitly repairing the current AIC %s release\n' "$version" >&2
		fi
	fi
}

sync_installed_rules() {
	local installed="$HOME/.local/bin/aic"
	capture_bounded_output "installed AIC global rule synchronization" \
		"$install_tmp/rules-sync.json" env -i \
		"HOME=$HOME" "PATH=/usr/local/bin:/usr/bin:/bin" \
		"$installed" rules sync --replace-global-instructions --json
}

parse_index() {
	local path="$1" line key value seen='|' count=0 expected_release_id
	schema_version="" version="" release_id="" web_manifest_sha256=""
	linux_x86_64_file="" linux_x86_64_sha256="" linux_x86_64_bytes=""
	linux_aarch64_file="" linux_aarch64_sha256="" linux_aarch64_bytes=""
	while IFS= read -r line || [ -n "$line" ]; do
		count=$((count + 1))
		[ "$count" -le 16 ] || fail "release index has too many fields"
		[[ "$line" != *$'\r'* && "$line" == *=* ]] || fail "release index is malformed"
		key=${line%%=*}
		value=${line#*=}
		[[ "$key" =~ ^[A-Za-z][A-Za-z0-9_]*$ && -n "$value" ]] || fail "release index field is malformed"
		[[ "$seen" != *"|$key|"* ]] || fail "release index repeats $key"
		seen+="$key|"
		case "$key" in
		schemaVersion)
			[ "$value" = 1 ] || fail "unsupported release index schema"
			schema_version="$value"
			;;
		version)
			valid_value version "$value" || fail "release version is invalid"
			version="$value"
			;;
		releaseId)
			valid_value release_id "$value" || fail "release id is invalid"
			release_id="$value"
			;;
		webManifestSha256)
			valid_value sha256 "$value" || fail "web manifest digest is invalid"
			web_manifest_sha256="$value"
			;;
		linux_x86_64_file)
			valid_value file "$value" || fail "x86_64 filename is invalid"
			linux_x86_64_file="$value"
			;;
		linux_x86_64_sha256)
			valid_value sha256 "$value" || fail "x86_64 digest is invalid"
			linux_x86_64_sha256="$value"
			;;
		linux_x86_64_bytes)
			valid_value bytes "$value" || fail "x86_64 size is invalid"
			linux_x86_64_bytes="$value"
			;;
		linux_aarch64_file)
			valid_value file "$value" || fail "aarch64 filename is invalid"
			linux_aarch64_file="$value"
			;;
		linux_aarch64_sha256)
			valid_value sha256 "$value" || fail "aarch64 digest is invalid"
			linux_aarch64_sha256="$value"
			;;
		linux_aarch64_bytes)
			valid_value bytes "$value" || fail "aarch64 size is invalid"
			linux_aarch64_bytes="$value"
			;;
		*) fail "release index contains unsupported field $key" ;;
		esac
	done <"$path"
	[ -n "$schema_version" ] && [ -n "$version" ] && [ -n "$release_id" ] &&
		[ -n "$web_manifest_sha256" ] &&
		[ -n "$linux_x86_64_file" ] && [ -n "$linux_x86_64_sha256" ] && [ -n "$linux_x86_64_bytes" ] &&
		[ -n "$linux_aarch64_file" ] && [ -n "$linux_aarch64_sha256" ] && [ -n "$linux_aarch64_bytes" ] ||
		fail "release index is incomplete"
	[ "$linux_x86_64_file" = "aic-$version-linux-x86_64.tar.gz" ] &&
		[ "$linux_aarch64_file" = "aic-$version-linux-aarch64.tar.gz" ] ||
		fail "release filenames do not match the indexed version"
	expected_release_id=$(printf 'aic-public:%s:%s' "$version" "$web_manifest_sha256" |
		sha256sum | awk '{print $1}')
	[ "$release_id" = "$expected_release_id" ] || fail "release id is not bound to the indexed browser identity"
}

validate_expected_release() {
	local bundle_sha="$1" bundle_bytes="$2" target="linux-$architecture" name present=0
	local names=(
		AIC_EXPECTED_RELEASE_VERSION
		AIC_EXPECTED_RELEASE_ID
		AIC_EXPECTED_WEB_MANIFEST_SHA256
		AIC_EXPECTED_RELEASE_TARGET
		AIC_EXPECTED_BUNDLE_SHA256
		AIC_EXPECTED_BUNDLE_BYTES
	)
	for name in "${names[@]}"; do
		[[ -v "$name" ]] && present=$((present + 1))
	done
	[ "$present" -ne 0 ] || return 0
	[ "$present" -eq "${#names[@]}" ] || fail "expected release constraints must be supplied together"
	valid_value version "$AIC_EXPECTED_RELEASE_VERSION" || fail "expected release version is invalid"
	valid_value release_id "$AIC_EXPECTED_RELEASE_ID" || fail "expected release id is invalid"
	valid_value sha256 "$AIC_EXPECTED_WEB_MANIFEST_SHA256" || fail "expected web digest is invalid"
	[[ "$AIC_EXPECTED_RELEASE_TARGET" =~ ^linux-(x86_64|aarch64)$ ]] || fail "expected release target is invalid"
	valid_value sha256 "$AIC_EXPECTED_BUNDLE_SHA256" || fail "expected bundle digest is invalid"
	valid_value bytes "$AIC_EXPECTED_BUNDLE_BYTES" || fail "expected bundle size is invalid"
	[ "$version" = "$AIC_EXPECTED_RELEASE_VERSION" ] &&
		[ "$release_id" = "$AIC_EXPECTED_RELEASE_ID" ] &&
		[ "$web_manifest_sha256" = "$AIC_EXPECTED_WEB_MANIFEST_SHA256" ] &&
		[ "$target" = "$AIC_EXPECTED_RELEASE_TARGET" ] &&
		[ "$bundle_sha" = "$AIC_EXPECTED_BUNDLE_SHA256" ] &&
		[ "$bundle_bytes" = "$AIC_EXPECTED_BUNDLE_BYTES" ] ||
		fail "the public release feed no longer matches the approved update"
}

validate_archive() {
	local archive="$1" expected_root="aic-release-$version" path entries type
	LC_ALL=C timeout --kill-after=2 30 tar --numeric-owner --quoting-style=escape -tzf "$archive" \
		>"$install_tmp/archive.paths" ||
		fail "release archive inventory is unreadable"
	[ "$(wc -c <"$install_tmp/archive.paths")" -le 2097152 ] ||
		fail "release archive inventory is too large"
	entries=$(wc -l <"$install_tmp/archive.paths")
	[ "$entries" -gt 0 ] && [ "$entries" -le "$MAX_ARCHIVE_ENTRIES" ] ||
		fail "release archive has an invalid entry count"
	while IFS= read -r path; do
		[[ "$path" == "$expected_root" || "$path" == "$expected_root/"* ]] ||
			fail "release archive escapes its versioned root"
		[[ "$path" != /* && "$path" != *//* && "$path" != *'\'* && "$path" != *$'\n'* && "$path" != *$'\r'* && "$path" != *$'\t'* ]] ||
			fail "release archive contains an unsafe path"
		case "/$path/" in */../* | */./*) fail "release archive contains a relative path component" ;; esac
	done <"$install_tmp/archive.paths"
	LC_ALL=C timeout --kill-after=2 30 tar --numeric-owner --quoting-style=escape -tvzf "$archive" \
		>"$install_tmp/archive.types" ||
		fail "release archive types are unreadable"
	[ "$(wc -l <"$install_tmp/archive.types")" -eq "$entries" ] ||
		fail "release archive inventories disagree"
	while IFS= read -r type; do
		case "${type:0:1}" in - | d) ;; *) fail "release archive contains a link or special file" ;; esac
	done <"$install_tmp/archive.types"
	archive_total_bytes=$(awk \
		-v max_file="$MAX_ARCHIVE_FILE_BYTES" -v max_total="$MAX_EXTRACTED_BYTES" '
    {
      kind = substr($1, 1, 1)
      if (kind == "-") {
        if ($3 !~ /^[0-9]+$/ || $3 > max_file) exit 2
        total += $3
        if (total > max_total) exit 3
      } else if (kind != "d") exit 4
    }
    END { if (NR == 0) exit 5; print total + 0 }
  ' "$install_tmp/archive.types") ||
		fail "release archive exceeds its uncompressed file or total byte limit"
	[[ "$archive_total_bytes" =~ ^[0-9]+$ ]] && [ "$archive_total_bytes" -le "$MAX_EXTRACTED_BYTES" ] ||
		fail "release archive uncompressed size is invalid"
}

verify_payload() {
	local payload="$1" sum hash marker path actual_count listed_count extracted_bytes update_identity
	declare -A checksum_paths=()
	[ -x "$payload/install.sh" ] && [ -x "$payload/runtime/node/bin/node" ] &&
		[ -x "$payload/aic-kernel/target/release/aic" ] &&
		[ -x "$payload/aic-kernel/auto-install.sh" ] &&
		[ -f "$payload/aic-kernel/scripts/inspect-web-tree.mjs" ] &&
		[ -f "$payload/aic-kernel/scripts/release-smoke.mjs" ] &&
		[ -f "$payload/aic-kernel/web-v2/build/build-manifest.json" ] &&
		[ -f "$payload/release.json" ] && [ -f "$payload/SHA256SUMS" ] &&
		[ -f "$payload/PRODUCT_TERMS.txt" ] && [ ! -L "$payload/PRODUCT_TERMS.txt" ] &&
		[ -f "$payload/THIRD_PARTY_NOTICES.txt" ] && [ ! -L "$payload/THIRD_PARTY_NOTICES.txt" ] &&
		[ -f "$payload/SBOM.json" ] && [ ! -L "$payload/SBOM.json" ] &&
		[ -f "$payload/RELEASE_NOTES.md" ] && [ ! -L "$payload/RELEASE_NOTES.md" ] &&
		[ -f "$payload/runtime/node/LICENSE" ] && [ ! -L "$payload/runtime/node/LICENSE" ] &&
		[ -f "$payload/THIRD_PARTY_SOURCE/uluru-3.1.0.crate" ] &&
		[ ! -L "$payload/THIRD_PARTY_SOURCE/uluru-3.1.0.crate" ] ||
		fail "release payload is incomplete"
	while IFS= read -r sum; do
		[[ "$sum" =~ ^([0-9a-f]{64})[[:space:]][[:space:]]([^[:cntrl:]]+)$ ]] ||
			fail "release checksum inventory is malformed"
		hash=${BASH_REMATCH[1]}
		path=${BASH_REMATCH[2]}
		[[ "$path" != /* && "$path" != *//* ]] || fail "release checksum path is unsafe"
		case "/$path/" in */../* | */./*) fail "release checksum path escapes the payload" ;; esac
		[ "$path" != SHA256SUMS ] || fail "release checksum inventory cannot list itself"
		[[ -z "${checksum_paths[$path]+present}" ]] || fail "release checksum inventory repeats a path"
		checksum_paths["$path"]=1
		[ -f "$payload/$path" ] && [ ! -L "$payload/$path" ] ||
			fail "release checksum names a missing or unsafe file"
		[ -n "$hash" ] || fail "release checksum is empty"
	done <"$payload/SHA256SUMS"
	(cd "$payload" && sha256sum --check --strict --quiet SHA256SUMS) ||
		fail "release payload checksum verification failed"
	actual_count=$(find "$payload" -type f | wc -l)
	listed_count=$(wc -l <"$payload/SHA256SUMS")
	[ "$actual_count" -eq "$((listed_count + 1))" ] ||
		fail "release payload contains unlisted files"
	if find "$payload" -type f -size +"${MAX_ARCHIVE_FILE_BYTES}"c -print -quit | grep -q .; then
		fail "release payload contains an oversized extracted file"
	fi
	extracted_bytes=$(find "$payload" -type f -printf '%s\n' | awk '{ total += $1 } END { print total + 0 }')
	[[ "$extracted_bytes" =~ ^[0-9]+$ ]] && [ "$extracted_bytes" -eq "$archive_total_bytes" ] &&
		[ "$extracted_bytes" -le "$MAX_EXTRACTED_BYTES" ] ||
		fail "release payload extracted size does not match its bounded archive inventory"
	capture_bounded_output "release binary public update identity" \
		"$install_tmp/payload-update-identity.json" \
		"$payload/aic-kernel/target/release/aic" binary-update-identity
	update_identity=$(<"$install_tmp/payload-update-identity.json")
	marker=$("$payload/runtime/node/bin/node" -e '
    const fs = require("node:fs");
    const crypto = require("node:crypto");
    const path = process.argv[1];
    const expectedVersion = process.argv[2];
    const expectedId = process.argv[3];
    const expectedTarget = process.argv[4];
    const expectedWebDigest = process.argv[5];
    const updateIdentity = JSON.parse(process.argv[6]);
    const sbom = JSON.parse(fs.readFileSync(process.argv[7], "utf8"));
    const coveredSource = process.argv[8];
    const value = JSON.parse(fs.readFileSync(path, "utf8"));
    if (JSON.stringify(Object.keys(value).sort()) !== JSON.stringify(["releaseId", "schemaVersion", "target", "version", "webManifestSha256"].sort())
      || value.schemaVersion !== 1 || value.version !== expectedVersion || value.releaseId !== expectedId
      || value.target !== expectedTarget || value.webManifestSha256 !== expectedWebDigest
      || !/^[0-9a-f]{64}$/.test(value.webManifestSha256)) process.exit(2);
    const manifest = fs.readFileSync(require("node:path").join(require("node:path").dirname(path), "aic-kernel/web-v2/build/build-manifest.json"));
    if (crypto.createHash("sha256").update(manifest).digest("hex") !== value.webManifestSha256) process.exit(3);
    if (JSON.stringify(Object.keys(updateIdentity).sort())
        !== JSON.stringify(["channel", "releaseIdentity", "version", "webManifestSha256"].sort())
      || updateIdentity.channel !== "public-binary" || updateIdentity.version !== expectedVersion
      || updateIdentity.releaseIdentity !== expectedId
      || updateIdentity.webManifestSha256 !== expectedWebDigest) process.exit(4);
    if (sbom.schemaVersion !== 1 || sbom.product !== "AIC" || !Array.isArray(sbom.components)) process.exit(5);
    const uluru = sbom.components.filter(component => component.ecosystem === "cargo"
      && component.name === "uluru" && component.version === "3.1.0");
    if (uluru.length !== 1 || uluru[0].license !== "MPL-2.0"
      || uluru[0].sourceArchive !== "THIRD_PARTY_SOURCE/uluru-3.1.0.crate"
      || !/^[0-9a-f]{64}$/.test(uluru[0].sourceSha256)
      || crypto.createHash("sha256").update(fs.readFileSync(coveredSource)).digest("hex") !== uluru[0].sourceSha256) process.exit(6);
    if (!sbom.components.some(component => component.ecosystem === "font"
        && component.name === "JetBrains Mono" && component.license === "OFL-1.1")
      || !sbom.components.some(component => component.ecosystem === "runtime"
        && component.name === "Node.js")
      || !sbom.components.some(component => component.ecosystem === "runtime"
        && component.name === "Rust standard library"
        && /^\d+\.\d+\.\d+$/.test(component.version)
        && component.license.includes("Apache-2.0 OR MIT"))) process.exit(7);
    process.stdout.write(`${value.version}:${value.releaseId}`);
  ' "$payload/release.json" "$version" "$release_id" "linux-$architecture" "$web_manifest_sha256" \
		"$update_identity" "$payload/SBOM.json" "$payload/THIRD_PARTY_SOURCE/uluru-3.1.0.crate") ||
		fail "release metadata does not match the public index"
	[ "$marker" = "$version:$release_id" ] || fail "release metadata identity mismatch"
}

main() {
	local os architecture libc index bundle_file bundle_sha bundle_bytes actual_sha payload
	local selected_service selected_port selected_port_number selected_web optional value user_path_has_local_bin
	local -a install_args=()
	local -a clean_environment=()
	while [ "$#" -gt 0 ]; do
		case "$1" in
		--replace-legacy)
			replace_legacy=1
			shift
			;;
		--repair)
			repair_current=1
			shift
			;;
		*)
			install_args+=("$1")
			shift
			;;
		esac
	done
	[ "$replace_legacy" -eq 0 ] || [ "$repair_current" -eq 0 ] ||
		fail "--replace-legacy and --repair are separate recovery boundaries"
	unset BASH_ENV ENV NODE_OPTIONS TAR_OPTIONS GZIP AIC_INTERNAL_REPLACE_V1_0_81_UNIT \
		AIC_INTERNAL_USER_PATH_HAS_LOCAL_BIN
	for external in awk chmod curl find getconf grep head mkdir mktemp rm sha256sum tar timeout uname wc; do
		unset -f "$external" 2>/dev/null || true
	done
	hash -r
	for command in awk bash chmod curl env find getconf grep head id mkdir mktemp readlink realpath rm sha256sum stat tar timeout uname wc; do require_command "$command"; done
	[[ "${HOME:-}" = /* && "$HOME" != *$'\n'* && "$HOME" != *$'\r'* && "$HOME" != *$'\t'* ]] ||
		fail "HOME must be one safe absolute path"
	user_path_has_local_bin=0
	case ":${PATH:-}:" in
	*":$HOME/.local/bin:"*) user_path_has_local_bin=1 ;;
	esac
	os=$(uname -s)
	[ "$os" = Linux ] || fail "this release channel currently supports GNU/Linux only"
	libc=$(getconf GNU_LIBC_VERSION 2>/dev/null || true)
	if [[ "$libc" =~ ^glibc\ ([0-9]+)\.([0-9]+)$ ]]; then
		libc_major=$((10#${BASH_REMATCH[1]}))
		libc_minor=$((10#${BASH_REMATCH[2]}))
	else
		fail "native Android/Bionic and musl need a separately tested AIC target; use GNU/Linux/glibc"
	fi
	[ "$libc_major" -gt 2 ] || { [ "$libc_major" -eq 2 ] && [ "$libc_minor" -ge 35 ]; } ||
		fail "this AIC release needs glibc 2.35 or newer"
	architecture=$(uname -m)
	case "$architecture" in x86_64 | amd64) architecture=x86_64 ;; aarch64 | arm64) architecture=aarch64 ;; *) fail "unsupported Linux architecture: $architecture" ;; esac
	selected_port=""
	if [[ -v AIC_PORT ]]; then
		selected_port=$AIC_PORT
		[[ "$selected_port" =~ ^[0-9]{1,5}$ ]] || fail "AIC_PORT must be an integer from 1 to 65535"
		selected_port_number=$((10#$selected_port))
		[ "$selected_port_number" -ge 1 ] && [ "$selected_port_number" -le 65535 ] ||
			fail "AIC_PORT must be from 1 to 65535"
	fi
	selected_web=""
	if [[ -v AIC_WEB_DIR ]]; then
		selected_web=$AIC_WEB_DIR
		valid_web_selector "$selected_web" ||
			fail "AIC_WEB_DIR must be one normalized absolute AIC browser selector"
	fi

	install_tmp=$(mktemp -d "${TMPDIR:-/tmp}/aic-release.XXXXXX")
	chmod 0700 "$install_tmp"
	trap cleanup EXIT
	trap 'interrupt 130' INT
	trap 'interrupt 143' TERM
	trap 'interrupt 129' HUP
	index="$install_tmp/release-index.txt"
	download "$AIC_PUBLIC_BASE/release-index.txt" "$index" "$MAX_INDEX_BYTES"
	parse_index "$index"
	if [ "$architecture" = x86_64 ]; then
		bundle_file=$linux_x86_64_file
		bundle_sha=$linux_x86_64_sha256
		bundle_bytes=$linux_x86_64_bytes
	else
		bundle_file=$linux_aarch64_file
		bundle_sha=$linux_aarch64_sha256
		bundle_bytes=$linux_aarch64_bytes
	fi
	validate_expected_release "$bundle_sha" "$bundle_bytes"
	validate_installed_release
	if [ "$already_current" -eq 1 ]; then
		sync_installed_rules
		printf 'aic-release-install: AIC %s already matches the public binary release identity; use --repair only for an explicit reinstall\n' \
			"$version"
		return 0
	fi
	[ "$bundle_bytes" -le "$MAX_BUNDLE_BYTES" ] || fail "release bundle exceeds the installer limit"
	download "$AIC_PUBLIC_BASE/releases/$version/$bundle_file" "$install_tmp/$bundle_file" "$bundle_bytes"
	[ "$(wc -c <"$install_tmp/$bundle_file")" = "$bundle_bytes" ] ||
		fail "release bundle byte length does not match the public index"
	actual_sha=$(sha256sum "$install_tmp/$bundle_file" | awk '{print $1}')
	[ "$actual_sha" = "$bundle_sha" ] || fail "release bundle SHA-256 mismatch"
	validate_archive "$install_tmp/$bundle_file"
	payload="$install_tmp/payload"
	mkdir "$payload"
	timeout --kill-after=2 60 tar -xzf "$install_tmp/$bundle_file" -C "$payload" \
		--strip-components=1 --no-same-owner --no-same-permissions ||
		fail "release archive extraction failed"
	find "$payload" -type l -o -type p -o -type b -o -type c -o -type s | grep -q . &&
		fail "release payload contains a link or special file"
	verify_payload "$payload"
	selected_service=${AIC_SERVICE:-aic.service}
	[[ "$selected_service" =~ ^[A-Za-z0-9][A-Za-z0-9_.@:-]*\.service$ ]] &&
		[ "$selected_service" != aic-ui-update.service ] || fail "AIC_SERVICE is invalid or reserved"
	clean_environment=(
		"HOME=$HOME"
		"PATH=$payload/runtime/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
		"AIC_PREBUILT_RELEASE=1"
		"AIC_SERVICE=$selected_service"
		"AIC_INTERNAL_USER_PATH_HAS_LOCAL_BIN=$user_path_has_local_bin"
	)
	[ -z "$selected_port" ] || clean_environment+=("AIC_PORT=$selected_port")
	[ -z "$selected_web" ] || clean_environment+=("AIC_WEB_DIR=$selected_web")
	[ "$replace_legacy" -eq 0 ] || clean_environment+=("AIC_INTERNAL_REPLACE_V1_0_81_UNIT=1")
	for optional in XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR; do
		[[ -v "$optional" ]] || continue
		value=${!optional}
		[[ "$value" = /* && ${#value} -le 4096 && "$value" != *$'\n'* && "$value" != *$'\r'* && "$value" != *$'\t'* ]] ||
			fail "$optional is not one safe absolute path"
		clean_environment+=("$optional=$value")
	done
	if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
		value=$DBUS_SESSION_BUS_ADDRESS
		[ -n "$value" ] && [ "${#value}" -le 4096 ] && [[ "$value" != *$'\n'* && "$value" != *$'\r'* && "$value" != *$'\t'* ]] ||
			fail "DBUS_SESSION_BUS_ADDRESS is unsafe"
		clean_environment+=("DBUS_SESSION_BUS_ADDRESS=$value")
	fi
	env -i "${clean_environment[@]}" bash "$payload/install.sh" "${install_args[@]}"
}

main "$@"

# AIC binary releases

This public repository distributes official AIC runtime builds. The AIC source repository remains
private; this repository is not an open-source code mirror. A bundle may include an exact
third-party covered-source archive when that dependency's own license requires it; this does not
grant an open-source license to AIC.

Install or update the latest supported GNU/Linux build:

```bash
( installer="$(mktemp)" && trap 'rm -f -- "$installer"' EXIT && curl --disable --proto '=https' --proto-redir '=https' --tlsv1.2 --fail --location --silent --show-error --retry 3 --connect-timeout 10 --max-time 120 --max-filesize 65536 --output "$installer" 'https://raw.githubusercontent.com/ldzyha/aic-releases/main/public/aic-install.sh' && bash "$installer" )
```

This is one physical shell line. Running the same line again verifies the current installation or
installs a newer public release. Every successful install/update, including an already-current
verification, invokes `aic rules sync --replace-global-instructions --json`. That transaction
atomically replaces the complete AIC-managed instruction payload in each managed global
instruction file, then verifies its installed identity; it never appends to an existing file.

Advanced recovery flags are deliberately separate from the normal one-line command:

- For an explicit reinstall of the same verified public release, repeat the complete line but
  change its final invocation to `bash "$installer" --repair`.
- For a trusted AIC binary old enough not to implement `release-info`, repeat the complete line but
  change its final invocation to `bash "$installer" --replace-legacy`.

The normal path refuses an unreadable installed identity, and the temporary file still exists when
the flagged command runs. The explicit `--replace-legacy` path can also migrate the exact unmodified
v1.0.81 generated `uv` service, retaining an owner-private unit backup and restoring its
content/enabled/running state if installation fails. Customized legacy
units are rejected for manual migration. Its normal uv executable symlink is accepted only inside
the exact owner-controlled `~/.local/share/uv/tools/aic` environment, recorded separately, and
restored before the old service is restarted on failure. When the optional historical autostart unit
was never created, that exact link can still migrate into a new current service; rollback removes the
new unit and restores the link. Rerunning the ordinary direct command also
discovers and retains a verified existing service's custom port/browser selector when neither is
explicitly supplied.

For an inspect-before-run flow, download `public/aic-install.sh`, review it, and invoke it with
`bash`. The installer fetches only the architecture-specific prebuilt bundle, verifies its SHA-256,
and uses AIC's rollback-capable user-service transaction. It does not clone the private repository
and does not require Cargo, npm, Git, or source code.

Each bundle includes its own Node 24.19.0 under AIC's XDG data runtime. The release that replaces
2.11.3 also retires only the byte-exact executable `~/.local/bin/b2c` wrapper shipped by that
release. Symlinks, directories, foreign or modified files, and mode-changed copies remain owner
state and are never removed.

After the first install, AIC can check and install newer public bundles from its desktop or mobile
update action. The local backend—not the browser—selects the target and exact release tuple. This
direct command remains an idempotent bootstrap and recovery path.
An exact public channel/version/release-ID/browser identity is verified without a reinstall/restart;
a same-version source build still migrates to the public channel. Earlier Rust builds with strict `release-info` but no
four-field channel identity migrate without a legacy flag and remain protected from downgrade. A
first install best-effort enables user lingering for keep-alive,
prints a manual `sudo loginctl enable-linger <uid>` command when policy blocks it, and notes when
`~/.local/bin` needs to be added to the terminal PATH.

Supported release targets are recorded in `public/release-index.txt` and require glibc 2.35 or
newer. Native Termux/Bionic is not a GNU/Linux target; use a supported glibc Linux environment until a separately tested Android service
adapter is published.

The product terms are in `public/PRODUCT_TERMS.txt`. Third-party licenses and a dependency manifest
are included inside each release bundle.

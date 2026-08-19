# AIC 7.0.9

This cumulative Release 7 hotfix preserves the published `7.0.0` architecture and adds nine
verified bug fixes. The release axis stays at `7`; the cumulative ledger now contains zero feature
outcomes and nine bug outcomes.

## Feature outcomes

No separately counted feature outcomes.

## Bug outcomes

- **B01 — Application-frame editor height.** The Preact application frame now grows through the
  complete flex column with a zero minimum height, so desktop and mobile editors use the available
  viewport instead of collapsing against the top edge.
- **B02 — Smart Panel mobile drag.** A larger grip, stable document-level pointer lifecycle, capture
  cleanup, cancellation, and persisted drop placement make the Smart Panel draggable by touch even
  after the pointer leaves its original bounds.
- **B03 — Browser-workspace folder navigation.** Granted browser folders now expose enabled nested
  directories, breadcrumbs, Root and Up navigation, and path-bound stale-result suppression, so
  source files below folders such as `src/` can be opened without native-server authority.
- **B04 — Dictation service resilience.** English dictation uses an already-available local browser
  recognizer when supported and otherwise retains the remote browser speech path, while permission,
  capture, language, start, and service-network failures remain distinct and actionable.
- **B05 — Smart Panel action labels.** Every visible Smart Panel action now has a compact visual
  label beneath its unchanged 20 px icon inside the unchanged 44 px button, while its complete
  accessible name and title remain available.
- **B06 — Terminal full sidebar surface.** Terminal-owned overlays, information control, project
  tabs, and session tabs are removed so xterm fills the complete active side-panel content area
  without being remounted.
- **B07 — Smart Panel single-source actions.** Smart Panel now owns contextual terminal navigation,
  creation and deletion, active-route closing, editor save and close, dynamic action grouping, and
  Commander de-duplication through one canonical action-ownership set.
- **B08 — Guide RPC semantic validation.** Guide comparison now treats JSON object key order as
  irrelevant while retaining exact key sets, values, schemas, array order, and security text, so the
  real Rust RPC payload no longer produces a false browser/binary divergence error.
- **B09 — Editor stable side-lane reservation.** Desktop and tablet retain empty left and right
  helper lanes while panels are closed, keeping the code track, CodeMirror geometry, selection, and
  scroll position stable when Notes or a right-side tool is toggled.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- This is a cumulative Release 7 hotfix. It preserves the `7.0.0` Preact/Kinu ownership boundary,
  browser/native capability split, connected protocol, storage formats, and native authority.
- Empty helper lanes on desktop and tablet are intentional. Phone layout continues to use the
  existing full-screen helper overlay and does not reserve invisible lanes.
- Terminal sessions and xterm instances remain native-server-backed and retained across surface
  switches. Their visible controls move to Smart Panel; the removed Info action has no replacement.
- Dictation remains dependent on browser/OS speech support, service reachability, language support,
  secure-context policy, and owner-granted microphone permission. AIC installs no speech pack and
  uploads audio to no new service.
- Browser-workspace navigation remains confined to the owner-granted directory handle. It does not
  reinterpret that folder as the native project root or weaken protected AIC-state filtering.
- Automated browser, contract, Rust, packaging, bundle, and publication gates are the release
  authority. A successful external browser speech-service request and the final physical ChromeOS
  installed-PWA matrix remain unclaimed when the required provider or device is unavailable.
- Existing projects, notes, files, browser-workspace permissions, layout preferences, recovery
  drafts, and PTY records require no data migration. Publication does not install the release or
  restart the running owner service.

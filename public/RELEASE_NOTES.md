# AIC 7.0.16

This cumulative Release 7 hotfix preserves the published `7.0.0` architecture and adds sixteen
verified bug fixes. The release axis stays at `7`; the cumulative ledger now contains zero feature
outcomes and sixteen bug outcomes.

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
- **B10 — Native folder opening from an authoritative location.** Connected folder browsing now
  begins at the active project instead of the server process directory. An unattached server exposes
  a bounded native-folder browser that starts near the configured project, filters malformed or
  legacy listing rows, and attaches the owner-selected Linux folder through `project.open`.
- **B11 — Icon-button descendant hit targets.** Presentation-only icon, SVG, label, and attention
  descendants no longer intercept pointer hit-testing, so taps on any visible part of an enabled
  icon button activate its semantic button exactly once.
- **B12 — Note actions have one Smart Panel owner.** The duplicate Pin and Close controls are removed
  from the inline note header. The context-aware Smart Panel remains the single action owner while
  pinned state, Escape handling, focus containment, mutation barriers, and blur-only saving remain
  unchanged.
- **B13 — Unattached folder confirmation activates the native project.** The Smart Panel folder
  picker now routes confirmation through the explicit attached or unattached generation authority.
  An unattached Chromebook or other client sends exactly one `project.open`, completes connected
  boot, and reaches the selected project; stale confirmation fails without sending a request.
- **B14 — Dictation abort diagnoses speech-service startup.** A browser `aborted` event before
  recognition reaches `onstart` now explains that the browser or Android profile could not start its
  speech service. An abort after listening begins remains a normal interruption, and every retry
  still requires a new owner mic tap.
- **B15 — Approved updates activate the current native and PWA release.** A user-approved update now
  owns recovery across its expected server restart without enabling background reconnect for ordinary
  disconnects. After durable native success, browser-shell replacement checks current worker/cache
  state before subscribing, settles from service-worker lifecycle and `controllerchange` events, and
  reloads exactly once only after the complete new shell controls the client.
- **B16 — Reserved unattached project recovery.** The installed service no longer accepts its private
  mount-independent `unattached` working directory as project authority. Poisoned remembered state
  returns to honest unattached recovery, the reserved directory and its canonical aliases are
  rejected before reroot, and a real owner-selected folder immediately supplies Explorer sources.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- This is a cumulative Release 7 hotfix. It preserves the `7.0.0` Preact/Kinu ownership boundary,
  connected RPC shapes, storage formats, and the separation between browser and native authority.
- Empty helper lanes on desktop and tablet are intentional. Phone layout continues to use the
  existing full-screen helper overlay and does not reserve invisible lanes.
- Terminal sessions and xterm instances remain native-server-backed and retained across surface
  switches. Their visible controls remain in Smart Panel; the removed Info action has no
  replacement.
- Dictation remains dependent on browser/OS speech support, service reachability, language support,
  secure-context policy, and owner-granted microphone permission. On Android/Vanadium, the current
  profile must provide a usable selected speech-recognition service. AIC installs no speech pack,
  adds no automatic retry loop, and uploads audio to no new service.
- Browser-workspace navigation remains confined to the owner-granted directory handle. It does not
  reinterpret that folder as a native project root. Native folder browsing remains server-backed,
  accepts only absolute Linux paths, and does not weaken protected AIC-state filtering.
- Attached folder switching still flushes pending editor work and uses its current generation.
  Unattached confirmation uses the server-provided unattached generation and the existing boot path;
  it does not reuse a stale project context or duplicate project installation.
- The private installed `unattached` directory remains the service's stable WorkingDirectory but is
  now reserved from project admission. An installation that remembered this invalid root presents
  the existing recovery UI and requires one explicit real-folder selection; valid unavailable
  ChromeOS paths remain retained for later recovery.
- General native reconnect remains manual. Only a persisted, owner-approved update may repeat native
  connection attempts across the installer-owned restart. Update success is read from durable native
  state after reconnect; elapsed time never claims completion.
- A changed browser shell retains the prior complete service-worker cache until the replacement is
  active. Worker installation failure remains visible and retryable, and a current replacement
  document consumes the persisted update marker without a reload loop.
- Smart Panel remains the single owner of contextual note actions. Removing the duplicate header
  controls does not change note contents, pinned-state persistence, or autosave behavior.
- Automated browser, contract, Rust, packaging, bundle, and publication gates are the release
  authority. A successful external browser speech-service request and the final physical ChromeOS
  installed-PWA matrix remain unclaimed when the required provider or device is unavailable.
- Existing projects, notes, files, browser-workspace permissions, layout preferences, recovery
  drafts, and PTY records require no data migration. Publication does not install the release or
  restart the running owner service.

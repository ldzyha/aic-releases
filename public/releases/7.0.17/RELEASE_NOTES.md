# AIC 7.0.17

This cumulative Release 7 hotfix contains zero feature outcomes and seventeen verified bug
outcomes. It retains the Preact/Kinu ownership boundary while making AIC Server the sole project
authority for the installed PWA.

## Feature outcomes

No separately counted feature outcomes.

## Bug outcomes

- **B01 — Application-frame editor height.** The Preact application frame grows through the complete
  flex column with a zero minimum height, so desktop and mobile editors use the available viewport.
- **B02 — Smart Panel mobile drag.** A larger grip, document-level pointer lifecycle, capture
  cleanup, cancellation, and persisted drop placement make the panel draggable by touch.
- **B03 — Browser-workspace folder navigation.** The former granted browser-folder implementation
  exposed nested directories, breadcrumbs, Root/Up navigation, and stale-result suppression. B17
  retires that secondary project authority after field use proved it less stable than native access.
- **B04 — Dictation service resilience.** Dictation distinguishes permission, capture, language,
  start, and service-network failures while using the available browser recognition path.
- **B05 — Smart Panel action labels.** Every visible action has a compact label beneath its unchanged
  icon inside the unchanged button geometry.
- **B06 — Terminal full sidebar surface.** Terminal-owned overlays, information control, project
  tabs, and session tabs are removed so xterm fills its active side-panel content area.
- **B07 — Smart Panel single-source actions.** Smart Panel owns contextual terminal navigation,
  creation/deletion, active-route closing, editor save/close, grouping, and Commander de-duplication.
- **B08 — Guide RPC semantic validation.** Guide comparison ignores JSON object key order while
  retaining exact keys, values, schemas, array order, and security text.
- **B09 — Editor stable side-lane reservation.** Desktop and tablet keep empty helper lanes while
  panels are closed, preventing editor geometry and scroll jumps during panel toggles.
- **B10 — Native folder opening from an authoritative location.** Connected browsing starts at the
  active project; unattached recovery lists bounded native folders and attaches through
  `project.open`.
- **B11 — Icon-button descendant hit targets.** Presentation-only icon, SVG, label, and attention
  descendants no longer intercept pointer hit-testing.
- **B12 — Note actions have one Smart Panel owner.** Duplicate Pin and Close controls are removed
  from the inline note header while note state and blur-only saving remain unchanged.
- **B13 — Unattached folder confirmation activates the native project.** Folder confirmation uses
  attached or unattached generation authority and sends exactly one `project.open`.
- **B14 — Dictation abort diagnoses speech-service startup.** Abort before `onstart` identifies a
  browser/Android speech-service startup failure; abort after listening remains an interruption.
- **B15 — Approved updates activate the current native and PWA release.** An approved update owns
  recovery across its expected server restart and reloads only after browser release activation.
- **B16 — Reserved unattached project recovery.** The service rejects its private mount-independent
  `unattached` working directory as project authority and returns to real-folder recovery.
- **B17 — Server-required PWA project authority.** The installed PWA no longer exposes or restores a
  browser-selected project, browser search/mutation provider, or cached offline editor. A cold launch
  requires AIC Server; a loaded client retains explicit manual reconnect; an unattached compatible
  server offers only native folder recovery. The network-only service worker retains an empty
  versioned cache name solely so older installed clients can complete their first update.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- This is a cumulative Release 7 hotfix with zero feature outcomes and seventeen bug outcomes.
- B17 intentionally removes the Release 6 browser-folder workspace and cached offline shell. PWA
  installation, standalone presentation, browser preferences, recovery drafts used by the native
  editor, dictation, wake lock, and other browser-native UI remain supported.
- Project files, Explorer, search, mutations, Git, Terminal, packages, updates, and editor bridging
  require a compatible AIC Server and current native project generation.
- Cold launch without the HTTP server reaches the browser/OS network-unavailable page. If the client
  is already loaded when its socket or handshake fails, the existing launcher guidance and manual
  **Reconnect** action remain available; no timer, focus, visibility, or online event opens a socket.
- Connected unattached recovery remains server-backed. It lists only bounded absolute Linux folder
  paths and attaches one owner-selected path through `project.open`.
- The service worker stores no application bytes and never answers from cache. Its empty
  `aic-shell-*` marker preserves update interoperability with pre-7.0.17 controllers, and activation
  removes earlier complete shell caches.
- Previously persisted browser directory handles are inert. Current code does not open their
  IndexedDB, query permissions, access the directory, or run a deletion transaction that an old tab
  could block.
- Existing native projects, notes, files, layout preferences, editor recovery drafts, and PTY
  records require no data migration.
- Dictation remains dependent on browser/OS speech support, selected service reachability, language,
  secure-context policy, and microphone permission. AIC adds no speech pack or automatic retry.
- Terminal and xterm remain server-backed and retained across surface switches. Smart Panel remains
  the single owner of contextual terminal and note actions.
- Automated browser, contract, Rust, packaging, bundle, and publication gates are release authority.
  Hardware/provider cases unavailable to the release environment remain explicitly unclaimed.
- Publication does not install the release or restart the currently running owner service.

# AIC 6.5.1

This counted release advances the verified public-release sequence after `5.12.18`. Its version
records Release 6, five included feature outcomes, and one included bug fix.

## Feature outcomes

- **F01 — Installed PWA offline shell.** The installed app owns presentation, browser state, cached
  startup, and browser-capable work instead of blocking its shell on the AIC server. Project-native
  operations remain explicitly unavailable until a verified server connection exists, while the
  service worker serves one immutable, version-bound application release.
- **F02 — Finite native status and owner launch.** Native availability is reported through bounded
  socket and handshake attempts with explicit disconnected, connecting, unavailable, incompatible,
  unattached, and ready states. There is no background five-second reconnect loop: the owner chooses
  **Reconnect**, and the fixed ChromeOS launcher remains an explicit OS/user action rather than page
  process-spawn authority.
- **F03 — ChromeOS shared workspace.** A user-selected browser workspace remains usable when
  Crostini is stopped because its File System Access handle is browser-owned. Optional **Share with
  Linux** handoff is separate: AIC accepts a `/mnt/chromeos/MyFiles/...` project only after Crostini
  is running and a fresh two-way owner-confirmed challenge proves the browser and native views are
  current. Missing or late mounts leave the server truthfully unattached instead of freezing the UI.
- **F04 — Context-aware mobile control deck.** One cross-device Smart Panel replaces duplicated
  sidebar tabs. Its default top or bottom bar contains Terminal, Explorer, Commander, and Open;
  dragging it creates a safe-clamped 3×3 sticky palette with at most five actions for the last valid
  Editor, Terminal, Note, Explorer, or generic-tool focus. Keyboard placement, safe-area clamping,
  durable local position, route attention, and stale dictation-target cancellation share one global
  controller.
- **F05 — Fixed Note blur autosave.** Notes keep exact recovery drafts while focused and save dirty
  bytes only through explicit **Save** or a blur/presentation boundary. The former off/delay settings
  and Commander rows are removed; legacy values normalize to blur without changing exact whitespace,
  mutation ordering, or conflict safeguards.

## Bug outcomes

- **B01 — Mobile dictation policy.** The served app now permits same-origin microphone use instead of
  blocking it with an empty policy. Dictation preserves distinct unsupported, permission, capture,
  service, no-speech, network, language, stale-target, insertion, and start errors; one final result
  is inserted only into the remembered focused text owner, and recognition aborts when that owner
  changes.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- AIC remains server-based for Terminal, git, packages, updates, editor bridge, unrestricted native
  filesystem access, and other native capabilities. A PWA cannot start Crostini or AIC by itself.
- Browser workspace support depends on compatible File System Access APIs and an owner-granted
  directory. The browser handle is not a native path, and `/mnt/chromeos` exists only inside running
  Crostini after the folder is shared with Linux.
- Dictation still depends on the browser/OS speech service, language support, secure-context rules,
  and owner-granted permission. The policy repair does not grant capture automatically.
- Automated and local-browser acceptance passed, but the final stable-ChromeOS installed-PWA matrix
  for microphone permission/service, Crostini transitions, shared-mount timing, virtual keyboard,
  and safe areas was not run before publication. The owner accepted this device-specific risk for
  production testing and a same-release hotfix if needed; no physical-device pass is claimed.
- Existing projects, notes, files, browser-workspace permissions, and PTY records require no data
  migration. Publication does not install the release or restart the running owner service.

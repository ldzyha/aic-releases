# AIC 2.11.3

This is the first counted AIC release after the legacy `1.0.100` line. Its version records one
verified public-release sequence, eleven included feature outcomes, and three included bug fixes.

## Feature outcomes

- **F01 — Focused editor and navigation.** AIC converges on one mounted center editor with owner
  notes on the left and project tools on the right. Explorer and project search share one surface;
  `Ctrl/Cmd+Shift+E` reveals the valid active file; ignored paths stay hidden; private draft
  recovery uses a typed browser-only route; tabs size to their content; and find/replace is a compact
  icon rail with CSS-only responsive reflow.
- **F02 — Project-aware Terminal processes.** Terminal sessions are grouped by project. Selecting a
  session shows it without changing the editor project, the adjacent project control switches the
  editor deliberately, and closing a process tab closes only that PTY.
- **F03 — Exact installed-service restart.** `aic restart` validates the installed AIC unit and its
  cgroup before restarting it, without accepting a caller-named lookalike service.
- **F04 — Note and AI lifecycle controls.** Note and AI surfaces provide bounded delete-all reviews
  and anchored exact-target confirmation without weakening runtime-owned path protection.
- **F05 — Agent context and handoff contract.** The canonical English guide now provides typed
  context resolve/audit/retire, cross-session task recovery, editor context binding, native
  instruction delivery, authority ordering, concise Key Maps, and literal `GO` / `DONE` gates.
- **F06 — Package migration intelligence.** Opening a clean saved `package.json` starts one bounded
  background analysis of the exact locked package against the selected Node/npm runtime and latest
  known LTS, including deprecation, bridge candidates, guarded matching actions, and a content-bound
  30-day successful-result cache.
- **F07 — Capability-gated Git and SFCC tools.** Git and SFCC load only for matching projects. The
  SFCC tab uses pinned Salesforce B2C tooling for reviewed cartridge deployment and one bounded
  recent-log request; it adds no watcher, tailer, activation, deletion, reload, or debugger action.
  The bundled dependency inventory, notices, SBOM, and reviewed upstream advisory snapshot ship
  with the release.
- **F08 — Mobile extra-key dock.** Focused code and live Terminal inputs gain a compact keyboard-only
  dock for Esc, Tab, modifiers, navigation keys, paging, and Enter. It uses browser/CSS viewport
  behavior and contains no resize polling, microphone, dictation, transcript, or AI rewrite path.
- **F09 — Local Mermaid preview.** Mermaid source gains a manual Edit/Preview switch for standalone
  diagrams and the fenced block under a Markdown cursor. The pinned local renderer loads only on
  Preview or Retry, keeps unsaved editor state mounted, and performs no runtime network fetch.
- **F10 — Optional browser-built-in model status.** Supporting desktop Chrome builds can show a
  status-only Models tab for exposed built-in APIs. It checks availability on open or explicit
  Refresh and never creates, downloads, retains, or activates a model session.
- **F11 — Counted release accounting.** AIC product waves now record stable feature or bug outcomes;
  release freeze assigns contiguous local IDs, and the public version is derived as
  `release.featureCount.bugCount`. Tests, documentation, refactors, generated files, and hardening
  evidence do not inflate the counts.

## Bug outcomes

- **B01 — Android Developer Mode systemd repair.** The one-line installer emits an unquoted absolute
  `WorkingDirectory=`. An ordinary rerun in Android Developer Mode's Debian GNU/Linux environment
  transactionally repairs only the byte-exact prior AIC-generated unit reported as
  `LoadState=bad-setting`, preserving its project, port, and web selector. Customized units,
  drop-ins, unsafe ownership, and native Android/Termux remain outside this repair boundary.
- **B02 — No hidden multi-page editor state.** The center editor now retains exactly zero or one code
  buffer. Opening another file prepares it while the current file remains usable, durably preserves
  unsaved text before an atomic replacement, discards stale loads, and removes the inaccessible
  `6/13` counter, editor-only page cycling, and Close Others behavior. Terminal process tabs and the
  independent note lane remain intact.
- **B03 — Clear Worktree and search ownership.** Worktree, file search, and content search now reuse
  Explorer hierarchy rhythm. Passive folder legends visibly own their file rows, files remain the
  primary actions, and content hits no longer drift behind an excessive horizontal offset.

## Compatibility record

- `1.0.100` is the final legacy-numbered release; `2.11.3` starts counted release accounting and is
  not a SemVer compatibility claim.
- Existing project layouts containing several historical open paths normalize to the valid active
  path only. Other durable recovery drafts remain available without recreating hidden editor pages.
- Native Android/Termux remains unsupported. The supported Android path is its Developer Mode Debian
  GNU/Linux environment with user systemd.

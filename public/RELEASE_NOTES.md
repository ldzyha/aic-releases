# AIC 5.12.17

This cumulative Release 5 hotfix preserves the seven feature and seven bug outcomes published in
`5.7.7`, then adds five verified feature outcomes and ten verified bug fixes. The release axis stays
at `5`; the cumulative ledger now contains twelve features and seventeen bug fixes.

## Feature outcomes

- **F01 — Bidirectional cross-provider review.** Optional repository plugins let Codex-authored work
  receive verified read-only Claude review and Claude-authored work receive verified read-only Codex
  review. Global simplification, code review, and final review bind provider family, scope, and input
  digest; the author validates and dispositions every finding. AIC remains an editor and terminal.
- **F02 — Controllable Note autosave.** Commander provides project-scoped **off**, **blur**, and
  **delay** modes. Delay saves exact text after a short pause and flushes on blur; off writes only
  through explicit Note Save while preserving recovery drafts. Code blur-save remains independent.
- **F03 — Opt-in Browser AI support.** Browser-managed availability and download support defaults to
  disabled per project. Enabling it is visible and explicit; disabling it stops browser checks and
  preparation without hiding external Codex or Claude terminal agents. AIC performs no inference or
  provider routing.
- **F04 — Bounded large-resource editing.** UTF-8 regular files above the 2 MiB complete-editor cap
  open in reduced plain-text resource mode with a browser window capped at 256 KiB. Byte/line
  navigation, literal search, exact-window recovery drafts, cancellation, progress, explicit save,
  and guarded streaming replacement avoid loading an unbounded document into the editor.
- **F05 — Width-defined layered responsive workspace.** Mobile is 0–767 CSS pixels, tablet is
  768–1279, and desktop begins at 1280. Width alone selects the layout; focus, helper, transient, and
  modal layers remain distinct through live resize while touch capability only adjusts ergonomics.
- **F06 — Provider-neutral simplification skill.** Separate optional Codex and Claude plugins package
  the same bounded, behavior-preserving `/simplify` workflow. It reviews reuse, clarity, efficiency,
  and abstraction depth, supports dry-run and inline fallback, and never installs or changes provider
  credentials or settings automatically.
- **F07 — Adaptive retained panel composition.** Desktop can show Note, code, and a right helper in
  three columns or use a persisted **Workspace: Two panels** toggle. Tablet keeps code plus one
  retained helper; mobile presents one modal surface. Hidden tracks collapse without losing editor,
  Note, Explorer, Terminal, or resource state.
- **F08 — Mobile Terminal control deck.** Mobile Terminal exposes a symmetric custom-icon 3×3 deck
  for Shift, Ctrl, Alt, Escape, Enter, and arrows, plus Home, End, English dictation, and Commander.
  Horizontal terminal gestures send Tab or Shift+Tab, dictation does not focus the terminal or open
  the software keyboard, and terminal carousel arrows remain without panel-toggle overlap.
- **F09 — Shared right-sidebar work surfaces.** Commander and Open are registered tabs in one right
  sidebar on mobile and desktop. Keyboard shortcuts and mobile controls use the same deterministic
  routing path, and the duplicate legacy dialogs are removed.
- **F10 — Manual ignored Explorer visibility.** Manual Explorer navigation shows gitignored files and
  folders in a dimmed state, keeps dependency/runtime exclusions hidden, and visually distinguishes
  confirmed-empty folders from ignored folders. Search and indexes remain strictly ignore-aware.
- **F11 — Terminal command intelligence.** Authenticated shell events identify missing executables,
  bounded completion and package resolution return reviewed candidates, and explicit browser
  confirmation installs only the exact approved candidate into AIC's private user tool store for new
  terminals. No system/global privileged path or model provider is modified.
- **F12 — Primary-harness task-AI ownership.** One current direct-owner primary harness may write or
  retire its task AI artifact. Delegated and peer models remain read-only; later direct-owner takeover
  requires audit, owner-context/evidence revalidation, and an exact Next action, without persisting
  provider or model identity.

## Bug outcomes

- **B01 — Exact Note text preservation.** Note saves preserve intentional spaces, tabs, blank lines,
  Unicode, and final-newline choice. Pausing after a space no longer concatenates surrounding words,
  and an older asynchronous save cannot replace newer focused text.
- **B02 — Explorer returns focus to code.** File and resource activation on every width presents the
  selected editor and places the caret there. Automatic Notes may load hidden but cannot steal focus;
  only an explicit Note action moves focus into Notes.
- **B03 — Coalesced editor-context publication.** Bursty document and selection changes collapse into
  one bounded quiescent publication plus at most one freshest trailing update. Lifecycle ownership
  stays stable through repeated surface cycles, reducing redundant work and typing-latency risk.
- **B04 — Actionable Browser AI status.** Disabled, unavailable, failed, busy, retry, and preparation
  states expose a visible reason and recovery action. Native controls are fenced while busy and
  cleanup failures remain visible.
- **B05 — Responsive large-file open and restore.** Large-file parsing avoids repeated prefix scans,
  open and restore share one guarded complete/resource preparation path, and crash-consistent exact-
  target markers prevent an interrupted resource from freezing workspace startup. Release timing
  evidence records complete and resource open/restore independently.
- **B06 — Rendered tables in Notes.** GFM tables in Note files now use the same rendered widget,
  source-on-caret editing, local-link navigation, and bounded horizontal overflow as Markdown code
  files, without changing stored Note bytes.
- **B07 — Scroll-safe flowchart previews.** Mermaid previews retain bounded horizontal overflow and
  click/keyboard source activation, but no longer own vertical scroll. Wheel, trackpad, and touch pan
  can continue through the surrounding Note or editor instead of stopping over a diagram.
- **B08 — Exact first Terminal input.** The first Terminal entry is sent exactly once and is never
  merged with, blocked by, or visually confused with placeholder state. Subsequent PTY input remains
  unchanged.
- **B09 — Deterministic Open and Commander routing.** Ctrl/Cmd+O always opens the registered Open
  surface, and Commander always opens its registered tab in the same right sidebar. No duplicate
  dialog path remains.
- **B10 — Empty Worktree Explorer access.** Working Tree remains enabled with zero changes, shows a
  count badge only when needed, and does not jump to another Explorer mode because its result is
  empty.
- **B11 — No-clobber project-root creation.** File and folder creation works at the project root,
  refreshes into Explorer, and rejects every existing target without overwriting it. Existing path,
  conflict, and atomic-write guards remain intact.
- **B12 — Terminal runtime continuity.** Incremental runtime and UI updates do not recreate the
  terminal controller, detach the active PTY, or open an unexplained replacement session on Android.
  Explicit close and restart actions still control PTY lifecycle.
- **B13 — New-terminal selection continuity.** Opening a new terminal keeps it selected across
  asynchronous listings and reconciliation instead of returning to the previous session. Existing
  sessions and replay remain available.
- **B14 — Ignored-content search exclusion.** Content and name search, together with indexes, continue
  to exclude gitignored paths even though manual Explorer navigation can display them.
- **B15 — Incremental Explorer reconciliation.** Explorer updates keyed rows and changed metadata in
  place, preserving selection, query, and scroll while eliminating whole-tree blink on routine
  runtime events. Full replacement remains available for project-generation or root changes.
- **B16 — Same-release hotfix accounting.** A hotfix retains release axis 5, carries prior outcome
  IDs, and advances cumulative counts without decrease; a direct-owner-declared new release advances
  exactly one axis after verified publication and resets its local counts. `5.7.7 → 5.12.17` and the
  separately planned `6.1.0` both follow the canonical guide and publication verifier.
- **B17 — Auditable public-update transition.** Public UI update state, logs, and Commander retain a
  validated old-to-new direction, bootstrap version, target version, completion time, and the fixed
  verified target-bundle installer provenance across restart and later equal-version checks. Older
  state stays readable, malformed history is ignored, and trust plus anti-downgrade gates are
  unchanged.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- This is a cumulative Release 5 hotfix: every `5.7.7` outcome remains present, with F08–F12 and
  B08–B17 added contiguously. Release 6 remains a separate planned migration.
- Desktop and fine-pointer Terminal input remain unchanged. Unsupported speech recognition reports
  unavailability without focusing the Terminal or invoking the software keyboard.
- Ignored files and folders become visible only through manual Explorer navigation. Search, indexes,
  dependency exclusions, and runtime exclusions retain their existing boundaries.
- Terminal command installation remains explicit, reviewed, unprivileged, and confined to AIC's
  private user tool store. AIC does not mutate a system package manager or provider credentials.
- Existing updater state without `lastUpdate` remains valid. Only canonical forward transitions from
  the fixed public-binary bootstrap and verified target-bundle installer are displayed.
- Existing projects, notes, editor files, PTY sessions, and external provider tools require no data
  migration. The running owner service is not restarted by publication.

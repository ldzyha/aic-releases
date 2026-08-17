# AIC 5.7.7

This counted release advances the verified public-release sequence after `4.2.4`. Its version
records seven included feature outcomes and seven included bug fixes.

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

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- Existing projects migrate to Note autosave **blur**, Browser AI support **disabled**, and desktop
  **Two panels** enabled. Narrow widths mask rather than overwrite the saved desktop preference.
- Tablet widths 768–1279 now use a non-modal code-plus-helper split. Mobile remains an exclusive
  surface; desktop begins at 1280 and may retain both helpers. Ctrl+Tab changes visibility on mobile
  and moves focus between live code and helper on tablet.
- Note saves no longer trim trailing whitespace. Non-Note code save normalization and kernel-owned
  code blur-save remain unchanged.
- Browser AI and both provider plugins are optional. Providerless operation remains supported; AIC
  does not install, authenticate, select, or route any model provider.
- Complete files through 2 MiB retain full editor services. Larger UTF-8 files use a bounded resource
  window; binary and invalid UTF-8 files continue to fail closed.
- Cross-provider review and simplification plugins remain repository capabilities outside the AIC
  binary. Their presence does not weaken the digest-bound release review or publication gates.

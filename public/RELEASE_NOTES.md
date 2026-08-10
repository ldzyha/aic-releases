# AIC 1.0.92

This release simplifies the editor surface and makes project maintenance resilient to mixed
monorepos.

- Desktop, tablet, and mobile now share one independent-button action bar. The duplicate mobile
  toolbar and dense dot/status rail are removed, while narrow portrait editors and side panels use
  the full viewport.
- Editor panes stay in one horizontal carousel on every viewport. Their scale follows live distance
  from the viewport center instead of an abrupt active/inactive transition.
- Terminal is a full-width horizontal carousel of independent retained PTYs. **+** creates a shell,
  **×** closes only the selected shell, and `Ctrl/Cmd+PageUp` / `Ctrl/Cmd+PageDown` switch terminal
  slides without also changing the editor page.
- The fixed global Markdown note at `~/.aic/note.md` is available from any project and from the
  installed PWA's operating-system shortcut. Its normal view is a minimal full-width Markdown code
  editor, with recovery controls revealed only when a revision conflict needs attention.
- Mermaid editing now rebases only its own accepted save normalization, so a newly inserted diagram
  can be edited immediately while genuine external source changes still fail closed.
- Package analysis reports malformed manifests as isolated issue nodes, keeps valid siblings
  usable, and shows deterministic workspace, path-nesting, shared-lock, and override-declaration
  evidence in the shared side panel. File and dependency-line actions remain locally scoped.
- Exact root `.node-version`, `.nvmrc`, or Volta pins can select one already-installed verified
  Node/npm pair for future terminals. Ranges, conflicts, and ambiguous matches are reported instead
  of guessed; automatic selection never downloads a runtime.
- Markdown headings, editor text, and line spacing now use compact relative sizing inherited from
  the browser/system scale. Palette/action icons have stable semantic identities, and the installed
  PWA icon uses a full-bleed background.

Package mutation remains preview/token guarded, never runs lifecycle scripts or tests, and never
silently widens a declared dependency range. Native Android/Termux is still a separate target; the
public ARM64 bundle requires GNU/Linux with glibc 2.35 or newer and a working user systemd manager.

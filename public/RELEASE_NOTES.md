# AIC 1.0.95

This release tightens the editor, Terminal, package tooling, and source-update paths around one
responsive sidebar contract.

- One Terminal session fills the desktop sidebar. Adding another session activates the same
  horizontal carousel lifecycle used by editor panes; clicking a neighbouring console centers and
  focuses it, while slide-navigation shortcuts stay contained in the active editor or Terminal.
- The one action bar is smaller, evenly inset, and flat instead of clipping button shadows at phone
  edges. Phone-class Explorer stays full-screen in both orientations, keeps the connected desktop tree geometry, and
  its membership controls use quiet, accessible switches.
- Package analysis now uses compact wrapping cards at desktop-sidebar and mobile widths. Manifest
  problems appear once as project-relative file links with the exact available location, a clear
  cause, and an actionable fix instead of duplicating an absolute-path parser message.
- A malformed or semantically invalid `package.json` no longer blocks the system shell or the
  explicit **Choose Node** flow. Valid `.nvmrc` and `.node-version` evidence still filters available
  Node candidates; each choice shows its automatically paired npm version.
- The SFCC action is reduced to a live transferred/total counter whose colour communicates idle,
  active, and updating state without a duplicate status surface.
- CodeMirror follows the root/system text scale at the same compact baseline as the application.
  Sidebar notes use a smaller relative scale while retaining the editor's Markdown decorations and
  list editing behaviour.
- Direct source updates retain the existing verified service port and web selector when the caller
  does not explicitly override them, including custom-port installations.
- The reviewed browser vendor is refreshed to patched Mermaid, DOMPurify, and esbuild releases,
  with exact artifact, component, licence, and receipt hashes regenerated for the public bundle.

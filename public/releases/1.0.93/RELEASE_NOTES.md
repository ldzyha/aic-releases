# AIC 1.0.93

This release makes the retained multi-session Terminal match the editor's responsive side-panel
geometry.

- On desktop, Terminal now inherits the right-side space beside the active editor slide instead of
  overriding it with a full-viewport layout. Narrow portrait screens remain full-viewport.
- The duplicate shared title bar and terminal navigation row are removed. The console fills the
  panel, while previous, next, new-session, session-close, panel-close, and position controls float
  independently at its edges with low visual emphasis.
- The selected terminal session occupies the dominant center area while smaller neighbouring
  sessions remain visible at the edges and scale continuously with their distance from the center.
- Closing the panel still preserves every PTY; only the dedicated trash control closes the selected
  session. `Ctrl/Cmd+PageUp` and `Ctrl/Cmd+PageDown` remain contained within Terminal navigation.

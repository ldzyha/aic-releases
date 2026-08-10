# AIC 1.0.96

This release makes editor, Terminal, notes, and transient tools follow one controlled carousel and
sidebar presentation.

- Every Terminal session now uses the full available sidebar width without scaling its console or
  type. Multiple sessions keep the same horizontal carousel, floating controls, and compact
  top-centre `position/total` counter.
- Editor panes show `position/total` inside the existing breadcrumb. Inactive editors adjust type
  gently from their actual rendered width, retain a readable floor, and return to the normal
  root/system-relative size when active or expanded.
- Sidebar tools now project one explicit owner at a time. Suspended surfaces are hidden, inert, and
  inaccessible until resumed, so Explorer controls such as **Worktree** cannot leak into Mermaid,
  Commander, Packages, or another tool.
- Sidebar notes use the same ordered Markdown handlers, frontmatter behavior, and list/task editing
  model as the main editor. Their intentionally compact `rem` typography still follows the
  browser/system text scale and responds gently to the note panel's own width.

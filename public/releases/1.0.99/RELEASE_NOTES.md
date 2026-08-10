# AIC 1.0.99

This release simplifies the side-panel interaction model, makes Explorer calmer and more direct,
and routes every clickable project-file reference through one fail-closed navigator.

- The editor remains in the main carousel and Terminal remains a retained technical carousel in
  the sticky side overlay. The code/Terminal exchange control and shortcut are removed, and a
  hidden retained Terminal can no longer remain painted after the side panel closes.
- The fixed action chrome is now one compact, text-only **Commander** button near the safe bottom
  edge. Commands keep semantic icons inside Commander, including a dedicated Global Note icon;
  pin checkboxes, projected action buttons, and their persisted migration state are removed.
- Explorer removes per-file checkboxes, connector lines, and the inert ellipsis disclosure. Rows
  use compact indentation and a restrained monochrome zebra; the one Worktree switch sits beside
  Explorer's close control, and a successful file open or interaction with code closes Explorer.
- Escape closes non-Terminal side tools from code or sidebar focus. A live PTY retains raw Escape,
  while an empty or ended Terminal releases it so the panel can close.
- Packages, Markdown links and tables, quoted editor paths, Terminal links, agent-guide entries,
  and definition results now share one project navigator. Canonical links require an exact existing
  file, path containment is preserved across POSIX and Windows forms, and a missing redirect cannot
  recover a draft or expose an implicit file-creation continuation.

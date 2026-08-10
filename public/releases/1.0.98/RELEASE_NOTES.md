# AIC 1.0.98

This release restores the desktop side panel as a polished overlay, limits pane exchange to code
and Terminal, and makes the Node/npm install path explicit after version selection.

- The desktop side panel again overlays the stable inactive-editor lane instead of reserving a
  split or shrinking the code carousel. Its width follows the full workspace’s carousel geometry,
  retains the useful compact floor, and remains stable while slides move.
- Only the exact live code and Terminal carousel roots can exchange main and side placement.
  Explorer, Notes, Mermaid, Packages, Commander, and every other tool remain side-only; opening one
  first restores code to the main pane. Empty or hidden Terminal state cannot enable the exchange.
- Terminal now uses the shared carousel page, edge-peek, focus, settlement, and restrained inactive
  slide presentation while preserving each live PTY. Raw Escape still reaches the shell, Terminal
  cycling stays isolated from code, and `Ctrl/Cmd+P` opens Commander from Terminal focus.
- Opening either optional Node or npm action refreshes both server-backed dropdowns. After choosing
  a verified pair, the panel now exposes an explicit review step followed by a distinct
  **Install + activate** or **Activate** confirmation, without accepting client-supplied paths or
  arbitrary versions.

# AIC 1.0.91

This release focuses on mobile continuity and deterministic project maintenance.

- Commander and the retained Terminal now use the editor side panel, preserving the active file
  and its selection while tools are open.
- `Ctrl+E` reveals the active file in Explorer; Worktree scope is enabled by default.
- Two-level file breadcrumbs add folder navigation and file-context navigation.
- The PWA install promotion, screen wake lock, UI update status, reconnect recovery, and mobile
  action layout are hardened for Android browser use.
- Project-scoped Node/npm selection can activate a compatible existing runtime or install a
  checksum-verified official Node runtime for future terminals.
- Deterministic package intelligence analyzes project, file, and dependency-line scope, refreshes
  guarded `package.note.md` reports, and previews public-registry lockfile updates within declared
  version ranges.
- Public binary distribution is separated from the private source repository. Browser JavaScript
  and CSS are bundled/minified; the payload contains no source maps or private source inventory and
  is installed transactionally.
- A binary-only installation can discover, approve, verify, and install the next public bundle from
  the desktop or mobile update status; the direct curl command remains its bootstrap/recovery path.

Package mutation never runs lifecycle scripts or tests and never silently widens a declared
dependency range. Native Android/Termux remains a separate runtime target; the GNU/Linux ARM64
bundle requires a glibc 2.35-or-newer Linux environment such as a compatible proot/container.

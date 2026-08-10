# AIC 1.0.94

This release makes the editor surfaces, external-agent guidance, and persistent controls converge
on one compact interface.

- The action bar now has one fixed Commander entry. Explorer, Blame, SFCC, Update, notes,
  diagrams, and every other action can be pinned or hidden from Commander; a hidden available
  update appears as a small attention dot on Commander.
- The window title carries the AIC version and concise project, Git, connection, conflict, update,
  and active SFCC state. Update and SFCC no longer create duplicate status zones.
- Mermaid has a project-independent brainstorming workbench with a vertical location, source, and
  syntax-preview flow. A draft can be copied as a safe Markdown fence or inserted at the active
  Markdown cursor, while bound edits show their exact file and line.
- Git restore, ambiguous definition, and project-search previews stay in the shared right sidebar;
  obsolete dynamic-dialog preview and Commander pin paths are removed.
- Terminal remains a raw multi-session console in the responsive sidebar. Node toolchain discovery
  failures now surface as warnings without blocking a system shell, and slide-navigation keys stay
  contained in the active editor or terminal carousel.
- `aic rules sync` installs one byte-identical provider-neutral rule pack for Codex, Claude Code,
  OpenCode, Pi, and Antigravity with private backups and guarded replacement. Release install and
  update run this synchronization automatically.
- The external-agent guide exposes the same context, documentation, diagram, and bounded-wave
  contract for CLI, ACP, and MCP delivery without embedding an agent runtime in AIC.
- Successful background autosave is quiet; only conflicts, newer unsaved edits, and actionable
  failures interrupt the interface.

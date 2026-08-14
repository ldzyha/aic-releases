# AIC 3.8.4

This counted release advances the verified public-release sequence after `2.11.3`. Its version
records eight included feature outcomes and four included bug fixes.

## Feature outcomes

- **F01 — Reviewable AI maps and unified Explorer filters.** Unfinished task maps remain recoverable
  across sessions, Mermaid fences render inline in the editor and Notes, and Explorer provides one
  ordered `All`, `Worktree`, `Notes`, and `AI Notes` filter surface. Filters disable only when a
  complete authoritative projection is empty, while unknown, loading, failed, and truncated states
  remain recoverable. Explorer also fills its assigned sidebar without a trailing empty strip.
- **F02 — Click-only mobile edge controls.** Two native edge controls reveal, hide, or replace the
  mobile Notes and tools panes without gesture listeners that compete with system navigation. Their
  labels, expanded state, safe-area placement, focus boundary, and newest-intent behavior remain
  explicit.
- **F03 — Persistent project note pin.** A pinned Note is normalized per project and becomes visible
  only after a successful load. Restore, rename, delete, fallback, reload, and project-switch races
  reconcile without leaking a stale pin or suppressing the current Note fallback.
- **F04 — Browser-managed AI preparation.** The always-visible AI surface clearly separates Chrome
  built-in support models from terminal coding agents. Supported Chrome builds can inspect and
  prepare browser-managed availability or downloads; AIC sends no prompts and retains no browser
  model session.
- **F05 — Provider-neutral optional modules.** Optional modules use a generic descriptor-derived
  capability map with explicit Git activation and invalidation. Product behavior no longer depends
  on a provider-specific module contract.
- **F06 — English practice while working.** The synchronized instruction pack includes the approved
  English-practice behavior for fresh external harness sessions without changing product protocols
  or provider authentication.
- **F07 — Commander text wrapping control.** Commander can enable or disable wrapping in the central
  editor without replacing the document, selection, history, or active buffer. The normalized
  project-scoped preference survives reload and project switching; compact Notes stay wrapped.
- **F08 — Explicit terminal-agent profiles.** The AI surface provides ordered First and Second
  profiles for Codex or Claude Code, optional validated model names, complete-profile swapping, and
  visible Launch or Authenticate actions. Each action opens an ordinary AIC Terminal and runs an
  allowlisted interactive CLI command; AIC stores no keys, tokens, auth state, or transcripts and
  performs no automatic pairing or delegation.

## Bug outcomes

- **B01 — Terminal workload isolation and recovery.** Managed installations contain each PTY in a
  delegated killable cgroup, scope output to explicitly attached clients, and keep only the visible
  terminal renderer alive. Recovery and close operations remain responsive under a bounded runaway
  workload instead of allowing Terminal memory pressure to freeze AIC.
- **B02 — Remove the AIC-owned SFCC module.** Native SFCC routes and product surfaces are retired
  while the independently installed external B2C CLI remains outside AIC ownership. Optional-module
  discovery and generated output remain provider-neutral.
- **B03 — Exact explicit-relative navigation.** A reference such as `./addressAutocomplete` now uses
  exact project-relative metadata navigation rather than Explorer fuzzy search. Missing, unsafe,
  directory, and out-of-root references fail closed; only ambiguous non-path text enters search.
- **B04 — Global shortcuts remain active from Explorer.** The persistent non-modal Explorer no
  longer captures application modifier chords. `Ctrl/Cmd+\`` continues to toggle Terminal while
  Explorer or its filters have focus, while genuine modal choices retain exclusive keyboard
  ownership and ordinary Explorer navigation is unchanged.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- Existing project layout records gain only normalized optional wrap and non-secret terminal-profile
  preferences; malformed or older values fall back safely.
- AIC remains an editor and raw persistent terminal, not a model router. Codex and Claude Code retain
  ownership of their authentication, model selection, processes, and transcripts.
- File and Note changes retain the immediate pre-transition presentation; the rejected unpublished
  fade behavior is absent. PC mirroring remains canceled, and no AIC-owned SFCC surface is restored.

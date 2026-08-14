# AIC 4.2.4

This counted release advances the verified public-release sequence after `3.8.4`. Its version
records two included feature outcomes and four included bug fixes.

## Feature outcomes

- **F01 — Explicit tablet Notes and editor switching.** On coarse-pointer tablets, Notes stay hidden
  by default while their content and pin state remain available. The left edge control and
  `Ctrl+Tab` switch exclusively between Notes and the editor, including from focused Terminal and
  tool surfaces. Notes flush before hiding, editor focus returns reliably, and phone and desktop
  layouts retain their existing behavior.
- **F02 — Advisory terminal-agent authentication status.** The AI tab independently reports whether
  Codex and Claude Code say they are signed in, signed out, unavailable, or unable to verify. AIC
  uses fixed bounded CLI status commands and the effective project Terminal environment, including
  capped common runtime-manager layouts. Unsafe, ambiguous, partial, or stale executable discovery
  fails conservatively, and account identity, credentials, raw output, and status history are not
  exposed or stored.

## Bug outcomes

- **B01 — Exact Mermaid preview closing lines.** Inline Mermaid previews consume the complete
  closing-fence line break without leaving an extra blank line below the diagram. LF, CRLF, EOF,
  following prose, raw editing boundaries, and searchable Markdown source remain exact.
- **B02 — Stable Worktree opening.** Opening Worktree now waits for authoritative Git refresh before
  painting its projection. The filter no longer flashes or falls back to All during a valid refresh,
  and stale project, invalidation, and destruction races fail closed.
- **B03 — Project-bound terminal-agent launches.** Launch and Authenticate use only a Terminal owned
  by the current server instance and exact selected project. A retained Terminal from another
  project or server is never reused for command delivery, preventing an AI-tab launch from creating
  task or Note files outside the selected project.
- **B04 — Verified Claude instruction delivery.** AIC-initiated Codex and Claude Code sessions use an
  explicit direct launcher. Claude receives the canonical AIC instruction reminder exactly once
  through its verified append mechanism, without replacing vendor instructions, duplicating global
  rules, elevating the owner request, or invoking a shell. Codex keeps native managed-instruction
  discovery, Authenticate remains interactive and visible, and raw manually typed provider commands
  remain unintercepted.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- Authentication status is advisory CLI-owned state; it does not prove network access, token
  freshness, credits, subscription entitlement, or model availability.
- Existing Note files, project layout records, Git RPC shapes, Terminal protocols, provider
  credentials, model selection, processes, and transcripts remain externally owned and compatible.
- Unsupported or changed Claude launcher capabilities fail visibly instead of silently starting an
  AIC-initiated session without the required instruction-delivery contract. Provider behavior after
  verified delivery remains provider-owned.

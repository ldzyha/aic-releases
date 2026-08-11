# AIC 1.0.100

This release smooths the editor carousel, aligns the sticky side overlay with the adjacent slide,
and hardens navigation and transport behavior under real project and connection pressure.

- The editor carousel now uses a 0.9 visual floor and reconciles added, removed, and reordered
  panes without painting intermediate geometry. Focus and smooth reveal are applied only after the
  new layout is stable, including rapid updates and panes removed during reconciliation.
- On desktop, the side overlay follows the edge containing the visible inactive slide, begins at
  the active-to-inactive gap, covers that lane, and matches its rendered height without shrinking
  the editor. Mobile
  Terminal sessions use the same bordered card language with safe side spacing.
- Commander is a single icon control: opposite the visible desktop side lane, centered on mobile,
  and changes to a close icon while open. Its commands are grouped by task while preserving one
  keyboard navigation order. Explorer uses a trash icon for deletion and gives folders a restrained
  color and dotted underline so they remain distinct from files.
- Mermaid parse failures now show the missing diagram-type correction before the source-edit hint.
  Protected `.ai`/`.aic/state` paths are rejected by the browser navigator, including Windows
  case variants, before generic file tools are called.
- Packages, Markdown, Terminal, definitions, and quoted paths continue through one exact project
  navigator. Root-prefixed duplicates resolve to the canonical existing project file, while a
  missing navigation result remains lookup-only and cannot turn into implicit file creation.
- Git snapshots now recognize nested-repository boundaries explicitly instead of reporting a
  missing outer object for submodule descendants. Genuine missing Git objects remain visible as
  errors, and automatic diff/blame suppression is limited to the nested-repository case.
- Browser RPC traffic is scheduled through one bounded four-request connection queue. Boot retries
  transient `transport_busy` and `rpc_queue_full` responses with capped backoff, and draft recovery
  no longer misclassifies no-send or pressure failures as durable session corruption.

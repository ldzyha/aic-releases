# AIC 1.0.97

This release gives the editor and side tools one physical shell, makes global guidance more
fact-disciplined, and turns project Node/npm selection into an explicit optional control.

- The one live editor carousel and one live tools context now swap between identical main and side
  pane shells without cloning CodeMirror, xterm, or sidebar state. The permanent side action rail
  remains stable, mobile stays full-screen in both orientations, and focus/inert ownership follows
  the visible context.
- AIC global agent rules advance to v2 with the owner’s calibration and factual-hygiene contract.
  Install and update replace all managed provider-neutral instruction slots atomically; an older AIC
  refuses a future rules generation instead of silently downgrading it.
- Sidebar Markdown notes, including the project-independent global note, now use the shared Markdown
  profile and render Mermaid previews. Tap or Enter reveals that fence’s editable source locally;
  the detached mobile workbench keeps location, source, then preview in vertical order.
- Separate Node and npm action-bar buttons open compact server-backed dropdowns in the package side
  panel. Node changes choose the backend-owned default npm; npm can then select another verified
  compatible pair. Hiding either action disables that selector, hiding both stops toolchain queries,
  and activation accepts only short-lived root/package-bound opaque tokens.

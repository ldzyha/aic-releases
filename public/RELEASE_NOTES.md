# AIC 7.0.0

This counted release advances the verified public-release sequence after `6.5.1`. It contains no
separately counted feature or bug outcome: the release is an architecture migration and performance
hardening of the accepted Release 6 product.

## Feature outcomes

No separately counted feature outcomes.

## Bug outcomes

No separately counted bug outcomes.

## Compatibility record

- The version follows AIC counted-release accounting and is not a SemVer compatibility claim.
- The installed PWA now starts through a small Preact-owned browser shell before loading the
  connected runtime. Browser-safe presentation remains available without the AIC server; native
  actions keep the same explicit unavailable and manual-reconnect behavior.
- VanJS and the general custom `Component` lifecycle are removed. Application shell and Smart Panel
  state share one immutable external-store contract, while CodeMirror and xterm remain stable
  imperative engine leaves behind explicit adapters.
- Preact and Kinu remain pinned at their reviewed versions. Kinu is consumed only through AIC-owned
  wrappers; the migration introduces no new provider, protocol, storage, keyboard, workspace, or
  browser/native authority contract.
- Compared with the untouched `6.5.1` production build, the brotli-compressed synchronous JavaScript
  graph is 92.4% smaller. The complete brotli-compressed offline precache grows by 0.15%, within the
  frozen 5% ceiling. These are reproducible byte measurements, not device timing claims.
- Automated behavioral, ownership, build, vendor, offline-cache, Rust, packaging, and publication
  transaction gates are the release authority. The final stable-ChromeOS physical matrix and named
  Chrome timing run were unavailable before publication; the owner accepted production testing and
  a same-release hotfix for device-specific issues, so no physical-device timing pass is claimed.
- Existing projects, notes, browser-workspace permissions, layout preferences, files, drafts, and
  PTY records require no data migration. Publication does not install the release or restart the
  running owner service.

# Discord Search Blocker 1.2.0

This release refreshes the extension for public maintenance and Chrome Web Store publishing.

## Highlights

- Added Chrome extension localization for 50 locales.
- Added localized Chrome Web Store listing copy.
- Added Chrome Web Store single-purpose and host-permission justification copy.
- Reworked icons, promotional images, and screenshots.
- Added a clearer project structure with `src/`, `assets/`, `store-listing/`, `tools/`, and `dist/`.
- Added reproducible asset, screenshot, and package generation scripts.
- Improved the content script observer so Discord DOM updates are coalesced before rescanning.
- Removed unused background script code.
- Added SPDX-friendly source license headers.
- Narrowed the content script match pattern to Discord channel pages.

## Package

Chrome Web Store upload package:

```text
dist/discord-search-blocker-1.2.0.zip
```

## Privacy

Discord Search Blocker does not collect, store, or transmit data. It has no analytics, no tracking, and no remote server.

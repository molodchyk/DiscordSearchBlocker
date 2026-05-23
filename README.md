# Discord Search Blocker

A small Chrome extension that hides Discord's in-channel search field on `discord.com`.

This project started as a personal commitment tool. Discord lets you mute, block, or avoid channels, but the search field can still make it easy to pull those channels back into view. Browser cosmetic filters can hide the same element, but this extension is meant to be installed as a stricter browser-level block, including through forced installation policies if you want that setup.

## Current Status

The extension is intentionally simple and still works with Discord's current web UI at the time of maintenance. It is now maintained again, but Discord changes its frontend often, so breakage is possible.

If Discord changes the search field markup, the most likely symptom is that the search box appears again.

## How It Works

The content script runs on `discord.com`, watches for Discord UI changes, and hides search-related containers that include Discord's editable search input.

It does not:

- read messages
- send data anywhere
- modify your Discord account
- block Discord's backend search API directly

It only changes the visible web UI in your browser.

## Installation

For local development or personal use:

1. Download or clone this repository.
2. Open `chrome://extensions`.
3. Enable **Developer mode**.
4. Click **Load unpacked**.
5. Select this extension folder.

For stricter blocking, install it using your browser's managed extension or force-install policy. That setup is browser and operating-system specific, but the extension itself does not require any special configuration.

## Permissions

The extension uses a content script on:

```json
"*://discord.com/*"
```

This is needed so it can run inside Discord's web app and hide the search field when Discord renders it.

## Development

The important files are:

- `manifest.json` - Chrome extension manifest
- `src/content.js` - logic that hides the Discord search field
- `_locales/` - localized extension name and description strings
- `assets/icons/` - extension icons
- `assets/store/` - Chrome Web Store promotional images
- `assets/store/screenshots/` - Chrome Web Store screenshots
- `STORE_LISTING.md` - Chrome Web Store listing index
- `store-listing/` - Chrome Web Store description copy split by locale
- `tools/generate-assets.ps1` - reproducible icon and promotional image generator
- `tools/generate-store-screenshots.ps1` - reproducible store screenshot generator
- `tools/package.ps1` - reproducible Chrome Web Store package builder
- `dist/` - packaged extension builds
- `.webstoreignore` - files to exclude when creating a Chrome Web Store upload package
- `LICENSE.txt` - GPL license text

After making changes, reload the extension from `chrome://extensions` and refresh Discord.

To create a Chrome Web Store upload package:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\package.ps1
```

## Localization

The extension uses Chrome's built-in localization system and includes manifest text for 50 locales. The product name stays consistent as "Discord Search Blocker"; the extension description is translated per locale in `_locales/<locale>/messages.json`.

Chrome Web Store listing copy is maintained separately in `store-listing/`, with `STORE_LISTING.md` as the index.

## Privacy

Discord Search Blocker does not collect, store, or transmit any data. It has no analytics, no tracking, and no remote server.

## Support

If this extension saves you time and you want to support its development:

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support-FFDD00?logo=buymeacoffee&logoColor=000)](https://buymeacoffee.com/molodchyk)
[![Patreon](https://img.shields.io/badge/Patreon-support-F96854?logo=patreon&logoColor=fff)](https://www.patreon.com/OMolodchyk)

## License

This project is licensed under the GNU General Public License. See `LICENSE.txt` for details.

# Changelog

All notable changes to Discord Search Blocker will be documented in this file.

This project follows a simple changelog format inspired by [Keep a Changelog](https://keepachangelog.com/), with dates in `YYYY-MM-DD` format.

## [Unreleased]

## [1.2.0] - 2026-05-23

### Added

- Added Chrome extension localization support with 50 locale files in `_locales/`.
- Added localized extension descriptions for supported locales.
- Added a fuller README with installation, privacy, permissions, maintenance, and localization notes.
- Added this changelog.
- Added a reproducible asset generator for extension icons and promo images.
- Added dedicated 32px and 48px icon assets.
- Added modular Chrome Web Store listing copy with localized descriptions for 50 locales.
- Added a structured project layout with `src/`, `assets/icons/`, `assets/store/`, `store-listing/`, and `dist/`.
- Added `.webstoreignore` for extension packaging.
- Added a reproducible Chrome Web Store package builder.
- Added Chrome Web Store screenshots generated from raw Discord screenshots.

### Changed

- Updated `manifest.json` to use Chrome's `__MSG_...__` localization placeholders.
- Added `default_locale` to the extension manifest.
- Replaced the extension icons and promo images with a clearer Discord search blocking design.
- Updated the manifest to use a real 48px icon instead of scaling the 64px asset.
- Removed text from promotional images because Chrome Web Store promo images are not locale-specific.
- Renamed promotional image files to describe their Chrome Web Store roles.
- Removed the empty action popup declaration from the manifest.
- Coalesced Discord DOM observer work to avoid repeated full scans during rapid UI updates.
- Replaced the verbose content script license header with SPDX identifiers.
- Moved runtime code and image assets into purpose-specific folders.

### Removed

- Removed the unused background script from the package.

## [1.1.1] - 2024-08-09

### Fixed

- Updated the search bar blocking logic after Discord UI changes.

## [1.1] - 2023-11-21

### Changed

- Made element detection more robust.

## [1.0] - 2023-10-01

### Added

- Initial Discord Search Blocker extension.

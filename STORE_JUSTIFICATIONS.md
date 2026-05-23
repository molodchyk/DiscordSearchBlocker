# Chrome Web Store Justifications

Copy for Chrome Web Store submission fields.

## Single Purpose

Discord Search Blocker has one narrow purpose: it hides the in-channel search field in Discord's web app. It is intended for users who mute, block, or intentionally avoid distracting Discord channels, but can still reach messages from those channels through Discord search. The extension does not add unrelated features; it only removes that visible search entry point from Discord channel pages.

## Host Permission

Discord Search Blocker needs access to `discord.com/channels/*` because Discord renders the in-channel search field inside its web app, not in the extension itself. The content script must run on Discord channel pages so it can detect that search UI and hide it when Discord renders or updates the page.

The permission is limited to Discord channel pages. The extension does not run on other websites, does not read or transmit messages, does not call Discord's backend search API, and does not collect analytics. The host access is used only to apply this visible UI change in the browser.

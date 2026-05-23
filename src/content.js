// SPDX-FileCopyrightText: 2023-2026 Oleksandr Molodchyk
// SPDX-License-Identifier: GPL-3.0-or-later

const SEARCH_CLASS_PATTERN = /search/i;

function hideElement(element) {
  element.style.display = "none";
}

function hideDiscordSearchBar() {
  const searchBarElements = document.querySelectorAll('div');

  searchBarElements.forEach((element) => {
    if (SEARCH_CLASS_PATTERN.test(element.className) && element.querySelector('[contenteditable="true"]')) {
      hideElement(element);
    }
  });
}

let hideScheduled = false;

function scheduleHideDiscordSearchBar() {
  if (hideScheduled) {
    return;
  }

  hideScheduled = true;
  requestAnimationFrame(() => {
    hideScheduled = false;
    hideDiscordSearchBar();
  });
}

const observer = new MutationObserver(scheduleHideDiscordSearchBar);

observer.observe(document.body, { childList: true, subtree: true });
scheduleHideDiscordSearchBar();



/*
 * Discord Search Blocker Extension
 *
 * file: content.js
 * 
 * This file is part of the Discord Search Blocker Extension.
 *
 * Discord Search Blocker Extension is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Discord Search Blocker Extension is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Discord Search Blocker Extension. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Oleksandr Molodchyk
 * Copyright (C) 2023-2024 Oleksandr Molodchyk
 */

// Function to hide the specified element
function hideElement(element) {
  element.style.display = "none";
}

// Function to hide the Discord search bar
function hideDiscordSearchBar() {
  // Regular expression pattern to match search bar elements
  const pattern = /search/;

  // Select all div elements and check if their class name matches the pattern
  const searchBarElements = document.querySelectorAll('div');
  
  searchBarElements.forEach((element) => {
    if (pattern.test(element.className) && element.querySelector('[contenteditable="true"]')) {
      hideElement(element); // Hide the search bar element
    }
  });
}

// Call the function to hide the search bar whenever DOM changes occur
const observer = new MutationObserver((mutationsList, observer) => {
  for (const mutation of mutationsList) {
    if (mutation.type === 'childList' || mutation.type === 'subtree') {
      hideDiscordSearchBar();
    }
  }
});

// Start observing changes in the document body
observer.observe(document.body, { childList: true, subtree: true });




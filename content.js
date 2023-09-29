// content.js

// Function to hide the specified element
function hideElement(element) {
  element.style.display = "none";
}

// Function to hide the Discord search bar
function hideDiscordSearchBar() {
  const searchBarSelector = ".searchBar-jGtisZ";
  const searchBarElement = document.querySelector(searchBarSelector);

  if (searchBarElement) {
    hideElement(searchBarElement); // Hide the search bar element
  }
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

// content.js

// Function to hide the specified element
function hideElement(element) {
  element.style.display = "none";
}

// Function to hide the Discord search bar
function hideDiscordSearchBar() {
  // Select elements that match the structural pattern of the search bar
  const searchBarElements = document.querySelectorAll('div[class*="search__"] > div > div');

  searchBarElements.forEach((element) => {
    // Perform additional checks if necessary to ensure it's the correct element
    if (element.querySelector('div[contenteditable="true"]')) {
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



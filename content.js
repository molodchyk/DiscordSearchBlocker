// content.js

// Function to hide the specified element
function hideElement(element) {
  element.style.display = "none";
}

// Function to block the Discord element
function blockDiscordElement() {
  // Locate and block the specified element on Discord channels
  const discordElement = document.querySelector("div.searchBar-jGtisZ");
  if (discordElement) {
    hideElement(discordElement); // Hide the specified element
  }
}

// Check if the current page is a Discord channel page
if (window.location.href.startsWith("https://discord.com/channels/")) {
  // Initial call to block the specified element
  blockDiscordElement();
}

const observer = new MutationObserver((mutationsList, observer) => {
  for (const mutation of mutationsList) {
    if (mutation.type === 'childList') {
      // Call the function to check and block the specified element whenever DOM changes occur
      blockDiscordElement();
    }
  }
});

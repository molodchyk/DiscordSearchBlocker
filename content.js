// content.js

// Function to hide the specified element
function hideElement(element) {
  element.style.display = "none";
}

// Function to block the Discord element
function blockDiscordElement() {
  // Locate and block the specified element on Discord channels
  const discordElement = document.querySelector(".searchBar-jGtisZ");
  if (discordElement) {
    hideElement(discordElement); // Hide the specified element
  }
}

// Check if the current page is a Discord channel page
if (window.location.href.includes("discord.com") && window.location.href.includes("/channels")) {
  // Initial call to block the specified element
  blockDiscordElement();
}
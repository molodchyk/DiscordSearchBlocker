// content.js

// Function to reduce the size or opacity of the specified element
function reduceElementSize(element) {
  element.style.height = "10px"; // Adjust as needed
  element.style.width = "10px"; // Adjust as needed
  element.style.opacity = "0.2"; // Adjust as needed
}

// Function to block the Discord element
function blockDiscordElement() {
  setTimeout(() => {
    const discordElement = document.querySelector("searchBar-jGtisZ");
    if (discordElement) {
      reduceElementSize(discordElement);
    }
  }, 2000); // Delay execution for 2 seconds (adjust the delay as needed)
}

if (window.location.href.startsWith("https://discord.com/channels/")) {
  blockDiscordElement();
}

const observer = new MutationObserver((mutationsList, observer) => {
  for (const mutation of mutationsList) {
    if (mutation.type === 'childList') {
      blockDiscordElement();
    }
  }
});

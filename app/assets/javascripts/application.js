// High Five Button functionality for users page
const setupHighFiveButtons = () => {
  const token = document.querySelector("meta[name='csrf-token']")?.content;
  const messages = [
    "Calibrating ideal hand trajectory...",
    "Locating the perfect five...",
    "Warming up the virtual hand...",
    "Testing out finger dexterity...",
    "Optimizing palm velocity...",
    "Simulating test slaps..."
  ];

  document.querySelectorAll("[data-high-five-form]").forEach((form) => {
    if (form.dataset.highFiveBound) return;
    form.dataset.highFiveBound = "true";

    form.addEventListener("submit", async (event) => {
      event.preventDefault();

      const button = form.querySelector("[data-high-five-button]");
      const card = form.closest("[data-high-five-card]");
      const count = card?.querySelector("[data-high-five-count]");
      const message = button?.querySelector(".high-five-message");

      if (!button || button.classList.contains("is-loading")) return;

      button.classList.add("is-loading");
      button.disabled = true;

      // Start message rotation
      let messageIndex = Math.floor(Math.random() * messages.length);
      if (message) {
        message.textContent = messages[messageIndex];
        message.style.animation = 'none';
        void message.offsetWidth; // Force reflow
        message.style.animation = '';
      }
      const messageTimerId = window.setInterval(() => {
        messageIndex = (messageIndex + 1) % messages.length;
        if (message) {
          message.textContent = messages[messageIndex];
          // Restart animation
          message.style.animation = 'none';
          void message.offsetWidth; // Force reflow
          message.style.animation = '';
        }
      }, 1200);

      const startTime = Date.now();
      let requestOk = false;

      try {
        const response = await fetch(form.action, {
          method: "POST",
          headers: {
            "X-CSRF-Token": token || "",
            "X-Requested-With": "XMLHttpRequest",
          },
          body: new FormData(form),
        });

        if (!response.ok) throw new Error("Request failed");
        requestOk = true;

      } catch (error) {
        requestOk = false;
      }

      const elapsed = Date.now() - startTime;
      if (elapsed < 2000) {
        await new Promise((resolve) => setTimeout(resolve, 2000 - elapsed));
      }

      // Stop message rotation
      window.clearInterval(messageTimerId);

      if (!requestOk) {
        button.classList.remove("is-loading");
        button.disabled = false;
        return;
      }

      if (count) {
        const current = Number.parseInt(count.textContent, 10);
        if (!Number.isNaN(current)) {
          count.textContent = current + 1;
        }
      }

      button.classList.add("is-flipped");

      window.setTimeout(() => {
        button.classList.remove("is-flipped");
        button.classList.remove("is-loading");
        button.disabled = false;
      }, 3000);
    });
  });
};

// Random High Five functionality
const runRandomHighFive = () => {
  const container = document.querySelector("[data-random-container]");
  const status = document.querySelector("[data-random-status]");
  const button = document.querySelector("[data-random-again]");
  const spinner = document.querySelector("[data-random-spinner]");
  const token = document.querySelector("meta[name='csrf-token']")?.content;
  const startTime = Date.now();
  const messages = [
    "Selecting a worthy recipient...",
    "Shuffling the high five deck...",
    "Calibrating ideal hand trajectory...",
    "Locating the perfect five...",
    "Warming up the virtual hand...",
    "Calculating hand size compatibility...",
    "Optimizing palm velocity...",
    "Simulating test slaps..."
  ];
  let messageIndex = 0;
  let messageTimerId = null;

  if (container) {
    container.classList.remove("random-high-five--done");
  }

  if (spinner) {
    spinner.classList.remove("random-high-five__spinner--hidden");
  }

  if (button) {
    button.classList.add("hidden");
    button.disabled = true;
  }

  if (status) {
    status.textContent = messages[messageIndex];
    messageTimerId = window.setInterval(() => {
      messageIndex = (messageIndex + 1) % messages.length;
      status.textContent = messages[messageIndex];
    }, 1200);
  }

  fetch("/random_high_five", {
    method: "POST",
    headers: {
      "X-CSRF-Token": token || "",
      "X-Requested-With": "XMLHttpRequest",
    },
  })
    .then((response) => {
      if (!response.ok) throw new Error("Request failed");
      return response.json();
    })
    .then((data) => {
      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, 3500 - elapsed);

      window.setTimeout(() => {
        if (messageTimerId) {
          window.clearInterval(messageTimerId);
          messageTimerId = null;
        }
        if (spinner) {
          spinner.classList.add("random-high-five__spinner--hidden");
        }
        if (status) {
          status.innerHTML =
            "<span class=\"block text-2xl font-semibold\">🎉 High five logged!</span>" +
            "<span class=\"block mt-4 text-base font-medium\">You have high fived <a href=\"/users\" class=\"font-semibold text-[rgb(58_187_139)] hover:text-[rgb(46_156_114)] transition-colors\">" +
            data.name +
            "</a></span>";
        }
        if (container) {
          container.classList.add("random-high-five--done");
        }
        if (button) {
          button.classList.remove("hidden");
          button.disabled = false;
        }
      }, remaining);
    })
    .catch(() => {
      if (messageTimerId) {
        window.clearInterval(messageTimerId);
        messageTimerId = null;
      }
      if (spinner) {
        spinner.classList.add("random-high-five__spinner--hidden");
      }
      if (status) {
        status.textContent = "Something went wrong. Please try again.";
      }
      if (container) {
        container.classList.add("random-high-five--done");
      }
      if (button) {
        button.classList.remove("hidden");
        button.disabled = false;
      }
    });
};

const setupRandomAgain = () => {
  const button = document.querySelector("[data-random-again]");
  if (!button || button.dataset.bound) return;
  button.dataset.bound = "true";
  button.addEventListener("click", runRandomHighFive);
};

// Initialize on page load
document.addEventListener("turbo:load", () => {
  setupHighFiveButtons();
  setupRandomAgain();
  // Only run random high five if we're on that page
  if (document.querySelector("[data-random-container]")) {
    runRandomHighFive();
  }
});

document.addEventListener("DOMContentLoaded", () => {
  setupHighFiveButtons();
  setupRandomAgain();
  // Only run random high five if we're on that page
  if (document.querySelector("[data-random-container]")) {
    runRandomHighFive();
  }
});

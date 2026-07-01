const menuToggle = document.querySelector(".menu-toggle");
const navLinks = document.querySelector(".nav-links");
const navItem = document.querySelector(".nav-item");
const navTrigger = document.querySelector(".nav-trigger");
const dropdown = document.querySelector(".dropdown");
let pointerActivatingTrigger = false;

function setDropdown(open) {
  navTrigger.setAttribute("aria-expanded", String(open));
  dropdown.dataset.open = String(open);
}

function setMobileMenu(open) {
  menuToggle.setAttribute("aria-expanded", String(open));
  navLinks.dataset.open = String(open);
  if (!open) setDropdown(false);
}

navItem.addEventListener("pointerenter", () => {
  if (window.matchMedia("(hover: hover) and (min-width: 721px)").matches) setDropdown(true);
});

navItem.addEventListener("pointerleave", () => {
  if (window.matchMedia("(hover: hover) and (min-width: 721px)").matches) setDropdown(false);
});

navTrigger.addEventListener("pointerdown", () => {
  pointerActivatingTrigger = true;
});

navItem.addEventListener("focusin", () => {
  if (!pointerActivatingTrigger) setDropdown(true);
});

navItem.addEventListener("focusout", (event) => {
  if (!navItem.contains(event.relatedTarget)) setDropdown(false);
});

navTrigger.addEventListener("click", () => {
  setDropdown(navTrigger.getAttribute("aria-expanded") !== "true");
  pointerActivatingTrigger = false;
});

menuToggle.addEventListener("click", () => {
  setMobileMenu(menuToggle.getAttribute("aria-expanded") !== "true");
});

document.addEventListener("pointerdown", (event) => {
  if (!event.target.closest(".nav-shell")) {
    setDropdown(false);
    setMobileMenu(false);
  }
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    setDropdown(false);
    setMobileMenu(false);
    menuToggle.focus();
  }
});

navLinks.addEventListener("click", (event) => {
  if (event.target.matches("a") && window.innerWidth <= 640) setMobileMenu(false);
});

if (new URLSearchParams(window.location.search).get("menu") === "open") {
  requestAnimationFrame(() => setDropdown(true));
}

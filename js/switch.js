// Switch for Light/Dark Mode

var theme = localStorage.getItem("theme") || "light";
document.documentElement.setAttribute("data-theme", theme);

const modeBox = document.querySelector("#modeBox");
modeBox.checked = (theme === "dark");

function themeSwitch(e) {
    var root = document.querySelector(":root");
    root.style.setProperty("--transitionSpeed", "0.5s");
    let mode = e.target.checked ? "dark" : "light";
    localStorage.setItem("theme", mode);
    document.documentElement.setAttribute("data-theme", mode);
}

modeBox.addEventListener("change", themeSwitch, false);

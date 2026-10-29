/* Publication discovery and citation tools. The complete list also works without JavaScript. */
(() => {
  "use strict";
  const root = document.getElementById("publication-index");
  if (!root) return;

  const search = root.querySelector("#publication-search");
  const year = root.querySelector("#publication-year");
  const type = root.querySelector("#publication-type");
  const status = root.querySelector("[data-publication-status]");
  const empty = root.querySelector("[data-publication-empty]");
  const items = Array.from(root.querySelectorAll("[data-publication]"));
  const groups = Array.from(root.querySelectorAll("[data-publication-year]"));
  const normalize = (text) =>
    text
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/ł/g, "l")
      .replace(/\bbatteries\b/g, "battery");
  const searchable = new Map(items.map((item) => [item, normalize(item.dataset.search)]));
  root.querySelector("[data-publication-controls]").hidden = false;

  function filter(updateURL = true) {
    const terms = normalize(search.value.trim()).split(/\s+/).filter(Boolean);
    let count = 0;
    items.forEach((item) => {
      const matches =
        (year.value === "all" || item.dataset.year === year.value) &&
        (type.value === "all" || item.dataset.type === type.value) &&
        terms.every((term) => searchable.get(item).includes(term));
      item.hidden = !matches;
      if (matches) count += 1;
    });
    groups.forEach((group) => {
      const visible = Array.from(group.querySelectorAll("[data-publication]")).filter((item) => !item.hidden).length;
      group.hidden = visible === 0;
      group.querySelector("[data-year-count]").textContent = `${visible} ${visible === 1 ? "work" : "works"}`;
    });
    root.querySelectorAll("[data-year-link]").forEach((link) => {
      link.hidden = !items.some((item) => !item.hidden && item.dataset.year === link.dataset.yearLink);
    });
    status.textContent = `${count} ${count === 1 ? "publication" : "publications"}${count !== items.length ? ` of ${items.length}` : ""}`;
    empty.hidden = count !== 0;
    if (updateURL) {
      const url = new URL(window.location.href);
      ["q", "year", "type"].forEach((key) => url.searchParams.delete(key));
      if (search.value.trim()) url.searchParams.set("q", search.value.trim());
      if (year.value !== "all") url.searchParams.set("year", year.value);
      if (type.value !== "all") url.searchParams.set("type", type.value);
      window.history.replaceState(null, "", url);
    }
  }

  function readURL() {
    const params = new URLSearchParams(window.location.search);
    search.value = params.get("q") || "";
    year.value = Array.from(year.options).some((o) => o.value === params.get("year")) ? params.get("year") : "all";
    type.value = Array.from(type.options).some((o) => o.value === params.get("type")) ? params.get("type") : "all";
    filter(false);
  }

  search.addEventListener("input", () => filter());
  year.addEventListener("change", () => filter());
  type.addEventListener("change", () => filter());
  root.querySelectorAll("[data-reset-publications]").forEach((button) =>
    button.addEventListener("click", () => {
      search.value = "";
      year.value = "all";
      type.value = "all";
      filter();
      search.focus();
    })
  );
  window.addEventListener("popstate", readURL);

  const copyTimers = new WeakMap();
  async function copy(button, node) {
    const message = root.querySelector("[data-copy-status]");
    try {
      await navigator.clipboard.writeText(node.textContent.trim());
      const original = button.dataset.copyLabel || button.textContent;
      button.dataset.copyLabel = original;
      window.clearTimeout(copyTimers.get(button));
      button.textContent = "Copied ✓";
      message.textContent = "Citation copied to clipboard.";
      copyTimers.set(
        button,
        window.setTimeout(() => {
          button.textContent = original;
        }, 1800)
      );
    } catch (_) {
      const selection = window.getSelection();
      const range = document.createRange();
      range.selectNodeContents(node);
      selection.removeAllRanges();
      selection.addRange(range);
      message.classList.remove("sr-only");
      message.textContent =
        "Automatic copy is unavailable. The citation is selected; use your browser’s copy command, or download the citation file.";
    }
  }
  root.querySelectorAll("[data-copy-citation], [data-copy-bibtex]").forEach((button) =>
    button.addEventListener("click", () => {
      const article = button.closest("[data-publication]");
      copy(button, article.querySelector(button.hasAttribute("data-copy-bibtex") ? "[data-bibtex-text]" : "[data-citation-text]"));
    })
  );

  function revealHash() {
    let id;
    try {
      id = decodeURIComponent(window.location.hash.slice(1));
    } catch (_) {
      return;
    }
    const target = document.getElementById(id);
    if (!target || !root.contains(target)) return;
    if (target.matches("details")) target.open = true;
    const article = target.closest("[data-publication]");
    if (article && article.hidden) {
      search.value = "";
      year.value = "all";
      type.value = "all";
      filter();
    }
    target.scrollIntoView({ block: "start" });
  }
  window.addEventListener("hashchange", revealHash);
  readURL();
  if (window.location.hash) revealHash();
})();

// The browser's native print dialog also saves PDFs.
(() => {
  const printButton = document.querySelector("[data-cv-print]");
  if (!printButton) return;
  printButton.hidden = false;
  printButton.addEventListener("click", () => window.print());
})();

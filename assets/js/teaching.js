// Course catalogue filters; the complete catalogue remains readable without JavaScript.
(() => {
  const root = document.getElementById("teaching-catalog");
  if (!root) return;
  const choice = root.querySelector("#course-choice");
  const search = root.querySelector("#course-search");
  const courses = Array.from(root.querySelectorAll("[data-course]"));
  const status = root.querySelector("[data-course-count]");
  root.querySelector("[data-course-controls]").hidden = false;
  const normalize = (text) =>
    text
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase();
  function filter() {
    const terms = normalize(search.value.trim()).split(/\s+/).filter(Boolean);
    let count = 0;
    courses.forEach((course) => {
      const matches =
        (choice.value === "all" || choice.value === course.id) && terms.every((term) => normalize(course.dataset.search).includes(term));
      course.hidden = !matches;
      if (matches) count += 1;
    });
    status.textContent = `${count} ${count === 1 ? "course" : "courses"}`;
    root.querySelector("[data-course-empty]").hidden = count > 0;
  }
  choice.addEventListener("change", filter);
  search.addEventListener("input", filter);
  root.querySelectorAll("[data-course-reset]").forEach((button) =>
    button.addEventListener("click", () => {
      choice.value = "all";
      search.value = "";
      filter();
      choice.focus();
    })
  );
  filter();
})();

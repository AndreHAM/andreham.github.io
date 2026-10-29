---
layout: page
title: teaching
display_title: Teaching
permalink: /teaching/
description: Courses in quantum information, open systems and superconducting circuits.
nav: true
nav_order: 4
---

{% assign courses = site.projects | where: 'teaching', true | sort: 'academic_year' | reverse %}
<div class="teaching-page" id="teaching-catalog">
  <div class="teaching-intro">
    <p>Explore a course, its central ideas and its outline. This catalogue will grow as new classes are added.</p>
    <p class="teaching-institution">ICTQT · University of Gdańsk</p>
  </div>

  <div class="course-controls" data-course-controls hidden>
    <div>
      <label for="course-choice">Choose a course</label>
      <select id="course-choice" aria-controls="course-results">
        <option value="all">All courses</option>
        {% for course in courses %}<option value="course-{{ course.slug | slugify }}">{{ course.title | escape }}</option>{% endfor %}
      </select>
    </div>
    <div>
      <label for="course-search">Find a topic</label>
      <input type="search" id="course-search" placeholder="Quantum mechanics, decoherence…" autocomplete="off" aria-controls="course-results">
    </div>
    <button class="course-reset" type="button" data-course-reset>Reset</button>
  </div>

  <div class="course-catalog-topline"><h2>Course catalogue</h2><p role="status" aria-live="polite" data-course-count>{{ courses.size }} {% if courses.size == 1 %}course{% else %}courses{% endif %}</p></div>
  <div class="course-grid" id="course-results">
    {% for course in courses %}
    {% assign course_topics = course.topics | join: ' ' %}
    <article class="course-card{% if courses.size == 1 %} course-card-single{% endif %}" id="course-{{ course.slug | slugify }}" data-course data-search="{{ course.title | append: ' ' | append: course.discipline | append: ' ' | append: course_topics | escape }}" aria-labelledby="course-title-{{ course.slug | slugify }}">
      <a class="course-image" href="{{ course.url | relative_url }}" tabindex="-1" aria-hidden="true">
        {% include figure.liquid path=course.img class="img-fluid" alt="Superconducting-qubit circuit illustration" %}
      </a>
      <div class="course-card-body">
        <div class="course-meta"><span>{{ course.level | escape }}</span><span>{{ course.term | escape }} {{ course.academic_year }}</span></div>
        <h3 id="course-title-{{ course.slug | slugify }}"><a href="{{ course.url | relative_url }}">{{ course.title | escape }}</a></h3>
        <p>{{ course.description | escape }}</p>
        <ul class="course-topics" aria-label="Course topics">{% for topic in course.topics %}<li>{{ topic | escape }}</li>{% endfor %}</ul>
        <div class="course-actions">
          <a class="site-button" href="{{ course.url | relative_url }}">Explore course <span aria-hidden="true">↗</span></a>
          {% if course.notes_url != blank %}<a href="{{ course.notes_url | relative_url }}">Course notes</a>{% else %}<span class="course-notes-status">Notes forthcoming</span>{% endif %}
        </div>
      </div>
    </article>
    {% endfor %}
  </div>
  <div class="course-empty" data-course-empty hidden><h3>No matching courses</h3><p>Try another topic or choose all courses.</p><button class="site-button" type="button" data-course-reset>Show all courses</button></div>
</div>
<script defer src="{{ '/assets/js/teaching.js' | relative_url | bust_file_cache }}"></script>

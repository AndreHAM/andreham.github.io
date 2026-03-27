---
layout: page
permalink: /teaching/
title: teaching
description: Course materials, schedules, and resources for classes taught.
collection: teaching
nav: true
nav_order: 5
---


<!-- pages/projects.md -->
<div class="teaching">
{% if site.enable_teaching_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {% for category in page.display_categories %}
  <a id="{{ category }}" href=".#{{ category }}">
    <h2 class="category">{{ category }}</h2>
  </a>
  {% assign categorized_teaching = site.teaching | where: "category", category %}
  {% assign sorted_teaching = categorized_teaching | sort: "importance" %}
  <!-- Generate cards for each project -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for teaching in sorted_teaching %}
      {% include teaching_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for teaching in sorted_teaching %}
      {% include teaching.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display projects without categories -->

{% assign sorted_teaching = site.teaching | sort: "importance" %}

  <!-- Generate cards for each project -->

{% if page.horizontal %}

  <div class="container">
    <div class="row row-cols-1 row-cols-md-2">
    {% for teaching in sorted_teaching %}
      {% include teaching_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for teaching in sorted_teaching %}
      {% include teaching.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>


<!--#<h2> Courses </h2>

#<ul>
#{% for course in site.courses %}
#  <li>
    <a href="{{ course.url }}">{{ Coherence and Decoherence in Superconducting Qubits }}</a>
#  </li>
#{% endfor %}
#</ul>



#<h2> teste </h2>
#{% assign teaching_items = site.teaching | sort: 'date' | reverse %}

#{% for item in teaching_items %}
##  <h3>{{ item.title }}</h3>
 # <p>{{ item.content }}</p>
#{% endfor %}

#<h2> teste2 </h2>
#{% if item.category == 'quantum' %}
#  <span class="badge">{{ item.category }}</span>
#{% endif %}

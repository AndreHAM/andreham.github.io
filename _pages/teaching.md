---
layout: book-shelf
permalink: /teaching/
title: teaching
description: Materials.
collection: teaching
nav: true
nav_order: 5
---


<h2> Courses </h2>

<ul>
{% for course in site.courses %}
  <li>
    <a href="{{ course.url }}">{{ Coherence and Decoherence in Superconducting Qubits }}</a>
  </li>
{% endfor %}
</ul>



<h2> teste </h2>
{% assign teaching_items = site.teaching | sort: 'date' | reverse %}

{% for item in teaching_items %}
  <h3>{{ item.title }}</h3>
  <p>{{ item.content }}</p>
{% endfor %}

<h2> teste2 </h2>
{% if item.category == 'quantum' %}
  <span class="badge">{{ item.category }}</span>
{% endif %}

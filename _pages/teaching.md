---
layout: page
permalink: /teaching/
title: teaching
description: Materials.
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




{% assign teaching_items = site.teaching | sort: 'date' | reverse %}

{% for item in teaching_items %}
  <h3>{{ item.title }}</h3>
  <p>{{ item.content }}</p>
{% endfor %}


{% if item.category == 'quantum' %}
  <span class="badge">{{ item.category }}</span>
{% endif %}

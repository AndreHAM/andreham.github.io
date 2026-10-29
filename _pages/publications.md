---
layout: default
permalink: /publications/
title: publications
description: Research articles, preprints and theses by André H. A. Malavazi, with reading links and downloadable citations.
nav: true
nav_order: 3
---

{% assign catalog = site.data.publication_catalog %}
<div class="publication-page" id="publication-index">
  <header class="pub-header">
    <p class="pub-eyebrow">Research output</p>
    <h1>Publications<span aria-hidden="true">.</span></h1>
    <p class="pub-intro">Quantum energy, information and open systems.<br>Explore my work, find a paper, or take a citation with you.</p>
    <div class="pub-overview">
      <p class="pub-counts"><span><strong>{{ catalog.counts.article }}</strong> papers</span><span><strong>{{ catalog.counts.preprint }}</strong> {% if catalog.counts.preprint == 1 %}preprint{% else %}preprints{% endif %}</span><span><strong>{{ catalog.counts.thesis }}</strong> {% if catalog.counts.thesis == 1 %}thesis{% else %}theses{% endif %}</span></p>
      <div class="pub-profile-links"><a class="pub-text-link" href="https://scholar.google.com/citations?user={{ site.data.socials.scholar_userid }}">Google Scholar <span aria-hidden="true">↗</span></a><a class="pub-text-link" href="https://orcid.org/{{ site.data.socials.orcid_id }}">ORCID <span aria-hidden="true">↗</span></a></div>
    </div>
    <div class="pub-library-links" aria-label="Download the complete bibliography">
      <span>Complete bibliography</span>
      <a href="{{ '/assets/bibliography/all-publications.bib' | relative_url }}" download>BibTeX <span aria-hidden="true">↓</span></a>
      <a href="{{ '/assets/bibliography/all-publications.ris' | relative_url }}" download>RIS / Zotero <span aria-hidden="true">↓</span></a>
    </div>
  </header>
  <div class="pub-toolbar" data-publication-controls hidden>
    <div class="pub-search-field">
      <label for="publication-search">Find a publication</label>
      <input type="search" id="publication-search" placeholder="Title, author, topic or DOI…" autocomplete="off" aria-controls="publication-results">
    </div>
    <div class="pub-select-field">
      <label for="publication-year">Year</label>
      <select id="publication-year" aria-controls="publication-results">
        <option value="all">All years</option>
        {% for year in catalog.years %}<option value="{{ year }}">{{ year }}</option>{% endfor %}
      </select>
    </div>
    <div class="pub-select-field">
      <label for="publication-type">Type</label>
      <select id="publication-type" aria-controls="publication-results">
        <option value="all">All work</option>
        <option value="article">Articles &amp; proceedings</option>
        <option value="preprint">Preprints</option>
        <option value="thesis">Theses</option>
      </select>
    </div>
    <button class="pub-reset" type="button" data-reset-publications>Reset</button>
  </div>
  <div class="pub-browse-row">
    <nav class="pub-years" aria-label="Jump to publication year">
      {% for year in catalog.years %}<a href="#year-{{ year }}" data-year-link="{{ year }}">{{ year }}</a>{% endfor %}
    </nav>
    <p class="pub-result-count" role="status" aria-live="polite" data-publication-status>{{ catalog.counts.total }} publications</p>
  </div>
  <div id="publication-results">
    {% assign year_groups = catalog.items | group_by: 'year' %}
    {% for group in year_groups %}
    <section class="pub-year-group" id="year-{{ group.name }}" aria-labelledby="heading-{{ group.name }}" data-publication-year>
      <div class="pub-year-heading">
        <h2 id="heading-{{ group.name }}">{{ group.name }}</h2>
        <span data-year-count>{{ group.items.size }} {% if group.items.size == 1 %}work{% else %}works{% endif %}</span>
      </div>
      <div class="pub-year-items">
        {% for paper in group.items %}{% include publication-item.liquid paper=paper %}{% endfor %}
      </div>
    </section>
    {% endfor %}
  </div>
  <div class="pub-empty" data-publication-empty hidden>
    <h2>No matching publications</h2>
    <p>Try another keyword, year or publication type.</p>
    <button class="pub-action" type="button" data-reset-publications>Show all publications</button>
  </div>
  <footer class="pub-footer">
    <p>Articles are listed by publication year. Preprints are labelled separately; published versions are listed once.</p>
    <p>For related questions or collaboration, <a href="mailto:andrehamalavazi@gmail.com">get in touch</a>.</p>
  </footer>
  <p class="sr-only" role="status" aria-live="polite" data-copy-status></p>
</div>
<script defer src="{{ '/assets/js/publications.js' | relative_url | bust_file_cache }}"></script>

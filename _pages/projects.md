---
layout: page
title: research
display_title: Research
permalink: /research/
description: Storing useful energy, controlling heat, and understanding interacting quantum systems.
nav: true
nav_order: 2
---

<div class="research-page">
  <div class="research-lead">
    <div>
      <p class="research-intro">I develop theoretical approaches to energy storage and heat control in open quantum systems, connecting quantum information with thermodynamic device design.</p>
      <p>My work combines analytical models and numerical analysis to identify useful physical mechanisms, their limitations, and routes towards experimentally testable implementations.</p>
    </div>
    <div class="research-figure research-overview-figure">
      {% include figure.liquid path="assets/img/venn.png" class="img-fluid" alt="Research at the intersection of quantum thermodynamics, quantum information and open quantum systems" %}
    </div>
  </div>

  <aside class="research-direction" aria-labelledby="current-direction">
    <p class="section-eyebrow">Current direction · SONATINA 2025–2028</p>
    <h2 id="current-direction">Modular quantum thermal devices</h2>
    <p>I lead a project at ICTQT, University of Gdańsk, investigating how heat manipulation and energy storage can be integrated in multifunctional quantum devices. A central goal is to adapt theoretical designs to superconducting circuits.</p>
    <a href="https://projekty.ncn.gov.pl/en/index.php?projekt_id=641119">Explore the funded project <span aria-hidden="true">↗</span></a>
  </aside>

  <section class="research-theme" aria-labelledby="energy-storage">
    <div class="research-theme-copy">
      <p class="section-eyebrow">01 · Quantum energy storage</p>
      <h2 id="energy-storage">Charging and protecting useful energy</h2>
      <p>I study how measurements, controlled operations and engineered couplings affect the energy that can be extracted from a quantum battery.</p>
      <p>Our contributions include charge-preserving operations, protocols that mitigate environmental discharge, and a charging scheme based on chiral squeezing.</p>
      <ul class="research-paper-links">
        <li><a href="https://journals.aps.org/prl/abstract/10.1103/zg87-t4y5">Chiral squeezing</a> <span>PRL · 2026</span></li>
        <li><a href="https://journals.aps.org/prxenergy/abstract/10.1103/2jtp-jpkn">Charge-preserving operations</a> <span>PRX Energy · 2026</span></li>
        <li><a href="https://journals.aps.org/prxenergy/abstract/10.1103/bv4w-jr6q">Ergotropy protection</a> <span>PRX Energy · 2025</span></li>
      </ul>
    </div>
    <div class="research-figure">
      {% include figure.liquid path="assets/img/QBattery.png" class="img-fluid" alt="A collection of quantum battery cells interacting with a thermal environment" zoomable=true %}
      <p class="caption">Energy storage in an open quantum battery.</p>
    </div>
  </section>

  <section class="research-theme" aria-labelledby="heat-control">
    <div class="research-theme-copy">
      <p class="section-eyebrow">02 · Quantum thermal devices</p>
      <h2 id="heat-control">Controlling heat flow</h2>
      <p>I investigate how interactions and energy-level structures determine thermal functionality. We showed how detuning in a three-subsystem model can support heat switching, rectification, stabilization and amplification.</p>
      <ul class="research-paper-links">
        <li><a href="https://journals.aps.org/pre/abstract/10.1103/PhysRevE.109.064146">Detuning effects for heat-current control</a> <span>Physical Review E · 2024</span></li>
      </ul>
    </div>
    <div class="research-figure">
      {% include figure.liquid path="assets/img/transistor.png" class="img-fluid" alt="Schematic of a quantum thermal transistor coupled to three thermal reservoirs" zoomable=true %}
      <p class="caption">A quantum counterpart of a thermal transistor.</p>
    </div>
  </section>

  <section class="research-theme" aria-labelledby="foundations">
    <div class="research-theme-copy">
      <p class="section-eyebrow">03 · Thermodynamic foundations</p>
      <h2 id="foundations">Local energy in interacting systems</h2>
      <p>We proposed a Schmidt-decomposition framework for the energetics of autonomous bipartite quantum systems. It identifies local effective Hamiltonians and preserves energy additivity, including in strong-coupling scenarios.</p>
      <ul class="research-paper-links">
        <li><a href="https://doi.org/10.3390/e24111645">A Schmidt decomposition approach</a> <span>Entropy · 2022</span></li>
        <li><a href="https://arxiv.org/abs/2211.07439">On the energetic analysis of autonomous quantum systems</a> <span>PhD thesis · 2022</span></li>
      </ul>
    </div>
    <div class="research-figure">
      {% include figure.liquid path="assets/img/energyAdd.png" class="img-fluid" alt="Local effective Hamiltonians whose energy expectations sum to the total energy of two interacting quantum systems" zoomable=true %}
      <p class="caption">Local effective Hamiltonians and energy additivity.</p>
    </div>
  </section>

  <div class="research-connect">
    <p>Interested in a shared research question?</p>
    <a class="site-button" href="mailto:andrehamalavazi@gmail.com">Discuss a collaboration <span aria-hidden="true">↗</span></a>
    <a href="{{ '/publications/' | relative_url }}">Browse all publications</a>
  </div>
</div>

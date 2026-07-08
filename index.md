---
layout: page
blog_posts: 5
---
<div id="front">
  <div id="intro">
    <picture>
      <source srcset="/assets/imgs/me/florian-latzel-2025-300px.avif" type="image/avif">
      <source srcset="/assets/imgs/me/florian-latzel-2025-300px.webp" type="image/webp">
      <img 
        src="/assets/imgs/me/florian-latzel-2025-300px.png" 
        alt="Florian Latzel, Metaforum Summercamp 2025. Foto © Mike Heitmann" 
        loading="lazy"
      />
    </picture>
    <h2>Hi, ich heiße Florian👋</h2>
    <p>Ich bin Trainer, Berater, Facilitator, Coach und Überzeugungstäter
    und begleite Individuen, Gruppen, Teams und Organisationen in Veränderung.
    <a href="/ueber-mich.html">Mehr über mich</a>.
    </p>
    {% include social.html %}
  </div>

  <div id="portfolio">
    <h2 id="mein-angebot">Mein Angebot</h2>
    <div class="angebot-1-2 angebot-1 coaching">
      <h3><a href="{% link pages/angebot/coaching.md  %}">Coaching</a></h3>
      <p>Hilfe zur Selbsterkenntnis.<br />Systemisch und Lösungsfokussiert. 
        <a href="{% link pages/angebot/coaching.md  %}">Mehr</a>.
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 wildnistraining">
      <h3><a href="{% link pages/angebot/wildnistraining.md %}">Wildnistraining</a></h3>
      <p>Bushcraft, Survival und eine tiefe Naturverbindung,
        die darüber hinausgeht.
        <a href="{% link pages/angebot/wildnistraining.md %}">Mehr</a>
      </p>
    </div>

    <div class="angebot-1-2 angebot-1 coach-and-walk">
      <h3><a href="{% link pages/angebot/coach-and-walk.md %}">Coach &amp; Walk</a></h3>
      <p>Coachings im Gehen und Draußen. Auf Wunsch in nahegelegenem Wald und Flur.
        <a href="{% link pages/angebot/coach-and-walk.md %}">Mehr</a>.
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 team-coaching">
      <h3>Team Coaching</h3>
      <p>Von einer Gruppe zum High Performing Team.
        Teambuilding und -coaching.
      </p>
    </div>

    <p class="teaser">Hast du Interesse oder Fragen?</p>

    <p id="kontakt-1">
      <a class="page-link kontakt" href="{% link pages/kontakt.md %}">Kontakt</a>
    </p>
  </div>
  
  <div id="kunden">
    <h2>Erfolgreiche Projekte &amp; Glückliche Kunden</h2>
    {% assign logo-path = "/assets/imgs/kunden" %}
    {% comment %} 3 Zeilen a 4 Logos in Vollansicht {% endcomment %}
    <ul class="kunden-logos">
      {% comment %} Zeile 1, Große Marken / Strahlkraft {% endcomment %}
      <li id="db"><img src="{{ logo-path }}/db-logo-red-rgb.svg" alt="Deutsche Bahn Logo" loading="lazy" /></li>
      <li id="rewe-digital"><img src="{{ logo-path }}/rewe-digital-logo.svg" alt="REWE digital Logo" loading="lazy" /></li>
      <li id="axa"><img src="{{ logo-path }}/axa-logo.svg" alt="AXA Logo" loading="lazy" /></li>
      <li id="myt"><img src="{{ logo-path }}/mytoys-group-logo.svg" alt="MYTOYS Group Logo" loading="lazy" /></li>
      {% comment %} Zeile 2, Agile / Coaching / Beratung {% endcomment %}
      <li id="reinblau"><img src="{{ logo-path }}/reinblau-logo.svg" alt="Reinblau Logo" loading="lazy" /></li>
      <li id="p1"><img src="{{ logo-path }}/paragraph-eins-logo.svg" alt="paragraph eins Logo" loading="lazy" /></li>
      <li id="startplatz"><img src="{{ logo-path }}/startplatz-accelerator-logo.png" alt="Startplatz Accelerator Logo" loading="lazy" /></li>
      <li id="init"><img src="{{ logo-path }}/init-logo.svg" alt="INIT Logo" loading="lazy" /></li>
      {% comment %} Zeile 3, Outdoor & Persönliche / regionale Story {% endcomment %}
      <li id="walkaboutyou">
        <picture>
          <source type="image/webp" srcset="{{ logo-path }}/walkaboutyou-logo.webp">
          <img src="{{ logo-path }}/walkaboutyou-logo.png" alt="walkaboutyou Logo" loading="lazy" />
        </picture> 
      </li>
      <li id="naturzeit">
        <picture>
          <source type="image/webp" srcset="{{ logo-path }}/naturzeitclub-logo.webp">
          <img src="{{ logo-path }}/naturzeitclub-logo.png" alt="Naturzeitclub Logo" loading="lazy" />
        </picture>
      </li>
      <li id="bib"><img src="{{ logo-path }}/bib-international-college-logo.svg" alt="bib International College Logo" loading="lazy" /></li>
      <li id="koeln"><img src="{{ logo-path }}/stadt-koeln-logo.svg" alt="Stadt Köln Logo" loading="lazy" /></li>
    </ul>

    <p class="teaser">Möchtest du auch dazugehören?</p>
    <div id="kontakt-2">
      <a class="page-link kontakt" href="{% link pages/kontakt.md %}">Kontakt</a>
    </div>
  </div>
 
  <h2>Aktuelle Blogeinträge</h2>
  {% include blog.html blog_posts=5 %}

</div>

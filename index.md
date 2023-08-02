---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
blog_posts: 5
---
<div id="front">
  <div id="intro">
    <figure role="group">
      <img src="/assets/imgs/florian-latzel-300x300.jpg" alt="Florian Latzel, Reinblau Teamtreffen, Mai 2017, Foto © Ronald Krentz">
    </figure>
    <h2>Hi, ich heiße Florian👋</h2>
    <p>Ich bin Trainer, Berater, Facilitator, Coach und Überzeugungstäter
    und begleite Individuen, Gruppen, Teams und Organisationen in Veränderung.
    <a href="/ueber">Mehr über mich</a>.
    </p>
    {% include social.html %}
  </div>

  <div id="portfolio">
    <h2>Mein Angebot</h2>
    <div class="angebot-1-2 angebot-1 coaching">
      <h3><a href="/coaching">Coaching</a></h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, 
        sed diam nonumy eirmod tempor invidunt ut.
        <a href="/coaching">Coaching</a>
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 wildnistraining">
      <h3><a href="/wildnistraining">Wildnistraining</a></h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, 
        sed diam nonumy eirmod tempor invidunt ut.
        <a href="/wildnistraining">Wildnistraining</a>
      </p>
    </div>

    <div class="angebot-1-2 angebot-1 coach-and-walk">
      <h3><a href="/coach-and-walk">Coach &amp; Walk</a></h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut.
        <a href="/coach-and-walk">Coach &amp; Walk</a>
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 team-coaching">
      <h3>Team Coaching</h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut.</p>
    </div>

     <div class="angebot-1-2 angebot-1 facilitierung">
      <h3>Facilitierung</h3>
      <p>Retrospektiven, Open Space und Team-Workshops und -Retreats.</p>
    </div>

    <div class="angebot-1-2 angebot-2 agile-coaching">
      <h3>Agile Coaching</h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut.</p>
    </div>

  </div>
  
  <div id="kontakt-1">
    <a class="page-link kontakt" href="/kontakt">Kontakt</a>
  </div>
  
  <div id="kunden">
    <h2>Zufriedene Kunden &amp; Erfolgreiche Projekte</h2>
    {% assign logo-path = "/assets/imgs/kunden" %}
    <ul class="kunden-logos" style="list-style: none;display: inline-flex;align-items:center;">
      <li id="rewe-digital"><img src="{{ logo-path }}/rewe-digital-logo.svg" alt="REWE digital Logo" /></li>
      <li id="axa"><img src="{{ logo-path }}/axa-logo.svg" alt="AXA Logo" /></li>
      <li id="burda"><img src="{{ logo-path }}/burda-logo.png" alt="Hubert Burda Media Logo" /></li>
      <li id="reinblau"><img src="{{ logo-path }}/reinblau-logo.svg" alt="Reinblau Logo" /></li>
      <li id="koeln"><img src="{{ logo-path }}/stadt-koeln-logo.svg" alt="Stadt Köln Logo" /></li>
      <li id=""><img src="{{ logo-path }}" alt="" /></li>
    </ul>
    <p>Möchtest du dabei sein?</p>
  </div>

  <div id="kontakt-2">
    <a class="page-link kontakt" href="/kontakt">Kontakt</a>
  </div>
 
  <div id="blog-posts">
    <h2>Aktuelle Blogeinträge</h2>
    <div class="archiv">
  {% assign i = 0 %}
  {% for post in site.posts %}
    {% unless forloop.first %}
    </ul>
    {% endunless %}
    {% assign i = i | plus: 1 %}
    <ul>
      <li class="h-entry">
        <span class="title p-name">
          <a class="u-url" href="{{ post.url }}">{{ post.title }}</a>
        </span>
        <hr>
        <time class="dt-published" datetime="{{ post.date | date: "%Y-%m-%dT%H:%M:%S"}}">
          {{ post.date | date: site.date_format }}
        </time>
      </li>
    {% if i == page.blog_posts %}
    </ul>
      {% break %}
    {% endif %}
  {% endfor %}
    </div>
    <p class="blog-link">
      <a href="/blog">Alle Blogeinträge</a>
    </p>
    <p class="feed-subscribe">
      <svg class="svg-icon orange">
        <use xlink:href="{{ '/assets/minima-social-icons.svg#rss' | relative_url }}"></use>
      </svg>
      <a href="{{ "/feed.xml" | relative_url }}">Abonieren</a>
    </p>
  </div>

</div>

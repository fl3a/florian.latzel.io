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
    <a href="/ueber-mich">Mehr über mich</a>.
    </p>
    {% include social.html %}
  </div>

  <div id="portfolio">

    <h2>Mein Angebot</h2>
    <div class="angebot-1-2 angebot-1 coaching">
      <h3><a href="/angebot/coaching">Coaching</a></h3>
      <p>Systemisches Coaching. 
        <a href="/angebot/coaching">Mehr</a>.
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 wildnistraining">
      <h3><a href="/angebot/wildnistraining">Wildnistraining</a></h3>
      <p>Bushcraft, Survival und eine tiefe Naturverbindung,
        die darüber hinausgeht.
        <a href="/angebot/wildnistraining">Mehr</a>.
      </p>
    </div>

    <div class="angebot-1-2 angebot-1 coach-and-walk">
      <h3><a href="/angebot/coach-and-walk">Coach &amp; Walk</a></h3>
      <p>Coachings im Gehen und draußen. Auf Wunsch in nahegelegenem Wald und Flur.
        <a href="/angebot/coach-and-walk">Mehr</a>.
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 team-coaching">
      <h3>Team Coaching</h3>
      <p>Von einer Gruppe aus Individuen zum High Performing Team.
        Teambuilding und -coaching.
      </p>
    </div>
{% comment %}
     <div class="angebot-1-2 angebot-1 facilitierung">
      <h3>Facilitierung</h3>
      <p>Retrospektiven, Open Space, Team-Workshops 
        und -Retreats, Offsites, Kickoffs und Walkabouts.
      </p>
    </div>

    <div class="angebot-1-2 angebot-2 agile-coaching">
      <h3>Agile Coaching</h3>
      <p>Für die Organisation, Product Owner und Team. 
        Als Scrum Master und Agile Coach.
      </p>
    </div>
{% endcomment %}

  </div>
  
  <p id="kontakt-1">
    <a class="page-link kontakt" href="/kontakt">Kontakt</a>
  </p>

<style>

ul.kunden-logos {
  list-style: none;
  margin-left: 0; 
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}
ul.kunden-logos li {
  width: 25%;
  text-align: center;
}
ul.kunden-logos li img {
  width: 70%;
  height: auto;
  webkit-filter: grayscale(1);
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  filter: gray;
  filter: grayscale(100%);
}
ul.kunden-logos li img:hover {
  webkit-filter: grayscale(0);
  -webkit-filter: grayscale(0);
  -moz-filter: grayscale(0);
  filter: grayscale(0);
  transform: scale(1.05);
}
#rzfnrw img {
  width: 98%;
}
#axa img {
  width: 50%;
}
#reinblau img, #pixelpark img{
  width: 55%;
}
#pixelpark img{
  width: 60%;
}
#naturzeit img, #p1 img, #bib img, #koeln img {
  width: 80%;
}
#kontakt-1 {
  clear: left;
}
</style>

  
  <div id="kunden">
    <h2>Erfolgreiche Projekte &amp; Glückliche Kunden</h2>
    {% assign logo-path = "/assets/imgs/kunden" %}
    <ul class="kunden-logos">
      <li id="rewe-digital"><img src="{{ logo-path }}/rewe-digital-logo.svg" alt="REWE digital Logo" /></li>
      <li id="axa"><img src="{{ logo-path }}/axa-logo.svg" alt="AXA Logo" /></li>
      <li id="myt"><img src="{{ logo-path }}/mytoys-group-logo.jpg" alt="MYTOYS GROUP Logo" /></li>
      <li id="naturzeit"><img src="{{ logo-path }}/naturzeitclub-logo.webp" alt="Naturzeitclub Logo" /></li>
      <li id="walkaboutyou"><img src="{{ logo-path }}/walkaboutyou-logo.webp" alt="walkaboutyou Logo" /></li>
      <li id="koeln"><img src="{{ logo-path }}/stadt-koeln-logo.svg" alt="Stadt Köln Logo" /></li>
      <li id="init"><img src="{{ logo-path }}/init-logo.svg" alt="INIT Logo" /></li>
      <li id="reinblau"><img src="{{ logo-path }}/reinblau-logo.svg" alt="Reinblau Logo" /></li>
      <li id="p1"><img src="{{ logo-path }}/paragraph-eins-logo.svg" alt="paragraph eins Logo" /></li>
      <li id="startplatz"><img src="{{ logo-path }}/startplatz-accelerator-logo.png" alt="Startplatz Accelerator Logo" /></li>
      <li id="paltine"><img src="{{ logo-path }}/platine-logo.png" alt="Platine Logo" /></li>
      <li id="visitberlin"><img src="{{ logo-path }}/visitberlin-logo.svg" alt="VisitBerlin Logo" /></li>
      <li id="pixelpark"><img src="{{ logo-path }}/digitas-pixelpark-logo.png" alt="Digitas Pixelpark Logo" /></li>
      <li id="burda"><img src="{{ logo-path }}/burda-logo.png" alt="Hubert Burda Media Logo" /></li>
      <li id="rzfnrw"><img src="{{ logo-path }}/ministerium-der-finanzen-des-landes-nrw-logo.png" alt="Ministerium der Finanzen des Landes NRW Logo" /></li>
      <li id="bib"><img src="{{ logo-path }}/bib-international-college-logo.svg" alt="bib International College Logo" /></li>
    </ul>
    <p>Möchtest du auch dazugehören?</p>
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

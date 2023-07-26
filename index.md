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
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut</p>
    </div>

    <div class="angebot-1-2 angebot-2 wildnistraining">
      <h3><a href="/wildnistraining">Wildnistraining</a></h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut</p>
    </div>

    <div class="angebot-1-2 angebot-1 team-coaching">
      <h3>Team Coaching</h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut</p>
    </div>

    <div class="angebot-1-2 angebot-2 agile-coaching">
      <h3>Agile Coaching</h3>
      <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut</p>
    </div>
  </div>
  
  <div id="kontakt">
    <a class="page-link kontakt" href="/kontakt">Kontakt</a>
  </div>
  
  <div id="kunden">
    <p>Eine Reihe Logos in Grau, mit Hover auf Farbig, ggf eine Slideshow</p>
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
          {{ post.date | date: "%Y.%m.%d"  }}
        </time>
      </li>
    {% if i == page.blog_posts %}
    </ul>
      {% break %}
    {% endif %}
  {% endfor %}
    </div>
    <a href="/blog">Alle Blogeinträge</a>
  </div>

</div>

---
layout: page
title: Über diese Website 
permalink: /ueber-diese-website.html
image: /assets/imgs/gears-of-industry.jpg
last_modified_at: 2024-08-25
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
(CC BY-NC-ND 2.0), House Photography' %}
## Blog

Bis in den Sommer 2023 war dies ein reines [Blog](/blog/). 
Seit dem geht es inkrementell in Richtung Portfolio Website für mein [Coaching](
{% link pages/angebot/coaching.md %})
und [Wildnistraining]( 
{% link pages/angebot/wildnistraining.md %})
Angebot.  

In meinem [Blog](/blog/) schreibe ich seit 2004 über [diverse Themen](/themen).     
Mal für mich, um meine Gedanken in schriftlicher Form auszuspeichern
und zu verarbeiten.     
Mal für Andere, um Wissen und Gedanken zu teilen.

Blogposts zu Updates dieser Website finden sich [hier](/thema/netzaffe).   
Den Blog kannst du via [RSS Feed](/feed.xml) 
z.B. mit dem Feedreader deiner Wahl abonnieren.

## Software

Diese Website wird von [*freier Software*](/thema/open-source/) angetrieben. Danke🙏!   

Die Basis bilden der statische Seitengenerator [Jekyll](/thema/jekyll/)
und das [Minima Theme](https://github.com/jekyll/minima).   
Gespeist wird das ganze aus [Textdateien in einem Git-Repository](
https://github.com/fl3a/florian.latzel.io).  
Bis Ende 2019 lief diese Website mit [Drupal](/thema/drupal/).

Diese Website wird auf [uberspace](https://uberspace.de) gehosted
und via [Git Bare Repository und post-receive Hook](
{% post_url 2021-03-30-jekyll-deployment-via-bare-repository-und-post-receive-hook %})   
mithilfe meines selbst geschriebenen [Jekyll Deployment Shell Skript](
https://github.com/fl3a/jekyll_deployment) dorthin deployed.

## Nachhaltig

Ich möchte diese Website so ressourcenschonend wie möglich gestalten. 
Durch den Einsatz eines statischen Seitengenerators fallen abgesehen von der Auslieferung der HTML-Seiten 
keine serverseitigen Rechenoperationen oder Datenbankzugriffe an.

{% responsive_image path:assets/imgs/website-carbon-results-florian-latzel-io.png figure:true 
alt:'Screenshot Website Carbon Calculator für florian.latzel.io. 0.01 Gramm CO2 je Seitenaufruf' %}

- Diese Website produziert weniger als 0,01 Gramm CO<sub>2</sub> pro Seitenaufruf 
und ist laut [Website Carbon Calculator ](
https://www.websitecarbon.com/website/florian-latzel-io/)[^test_date] 
98 % sauberer als andere Seiten. 
- Die Website ist im *Team Green (>100kb)* des [512kb Clubs](https://512kb.club/)[^512][^test_date_512]  
- Die Rechenzentren bei [uberspace](
https://uberspace.de) werden ausschließlich mit Ökostrom betrieben.

## Lizenz der Inhalte

Die Inhalte dieser Website, soweit nicht anders angegeben, 
sind unter der [CC BY-SA 4.0]({% link pages/copyleft.md %}) 
lizensiert.      
Siehe [Copyleft 🄯]({% link pages/copyleft.md %}) für weitere Details.

Fußnoten

[^test_date]: Getestet am 14.06.2026
[^test_date_512]: Aufnahme in den 512KB Club am 28.09.2025 mit einer Seitengröße von 40 KB (unkomprimiert).
[^512]: Das [*512kb Club*-Projekt](https://512kb.club/), initiiert von [Kev Quirk](https://kevquirk.com), 
    sammelt Webseiten, deren Gesamtgröße unter 512 KB liegt, um effizientes und nachhaltiges Webdesign zu fördern
    und einen Gegenentwurf zu aufgeblähten Seiten mit mehreren Megabytes darzustellen. 

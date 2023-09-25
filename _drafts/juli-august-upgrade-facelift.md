---
title: "Juli + August: Upgrade und Facelift"
tags:
- Jekyll
- Coaching 
- netzaffe
- liquid
- Learnings
layout: post
date: 2023-09-22
image: /assets/imgs/gears-of-industry.jpg
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
CC BY-NC-ND 2.0, House Photography' %}

Im Juli und August habe ich viel Zeit im kühlen Maschinenraum verbracht 
und dieser Site gearbeitet. 
Sowohl unter der Haube als auch am Anlitz.

## Upgrade auf Jekyll 4.x

Seit der Migration von Drupal Ende 2018 lief diese Site mit der damals aktuellen Version 3.8.5.
Grund genug ein Update zu fahren um in Genuß der Verbesserungen von Jekyll 4 zu kommen.

Gerade das angekündigte 

> Jekyll builds should be much faster.[^j4] 

macht beim lokalen Arbeiten mit `jekyll serve` bereits 
auch ohne `--incremental`[^inc] einen deutlichen Unterschied.
Das Schreiben und Arbeiten an der Site 
macht durch die schnellere Resonanz mehr Spaß. 

## Blog, Tags und Tagseiten

Das Facelift habe ich mit der [Blogübersichtsseite](/blog.html) begonnen
und mich dann über [Tags](/themen.html) zu den einzelnen Tagseiten vorgearbeitet.
Mich hat das sehr Reduzierte und die Übersichtlichkeit 
auf <https://dri.es> schon sehr lange angesprochen. 
So habe ich das nachgebaut.

## Startseite und Navigation

Neben der ganzen Technik hat die Startseite ein komplett neues Gesicht bekommen.
Ich habe Startsseite, Navigation und einige Seiten überarbeitet.
Mein Portfolio als Coach und Wildnistrainer stehen jetzt Vorgrund
und bekommen auf der Startseite jetzt den entsprechenden Raum. 

## CO₂ Ausstoß der Website stark reduziert

Ein Nebeneffekt der Überarbeitungen, gerade das Weglassen der Teaserbilder 
in Übersichtsseiten bei Blog und Tags, 
ist viel geringere Datenmenge, die je Seitenaufruf generiert wird

Das hat zu einer starken Reduzierung des CO₂ der Website geführt.
Laut [Website Carbon Calculator](
https://www.websitecarbon.com/website/florian-latzel-io/) 
sind das jetzt 0,03 Gramm CO₂ pro Seitenaufruf.

## Learnings

- Filter link und post_url[^links]
- Frontend
  - HTML und CSS
  - Mediaqueries
  - filter + Transitions 
  - Listen mit Columns oder display-flex und Prozentangabe
  - Ich mache kein Frontend
- Spaß bei den Liquids (Blog und Tags) und jquery
- Prokratstination (
- Reduktion Portfolio und Kunden

[^j4]: <https://jekyllrb.com/news/2019/08/20/jekyll-4-0-0-released/>
[^inc]: <https://jekyllrb.com/docs/configuration/incremental-regeneration/>
[^links]: <https://jekyllrb.com/docs/liquid/tags/#links>

---
title: "Juli + August: Upgrade und Facelift"
tags:
- Jekyll
- netzaffe
- Liquid
- Portfolio
- Nachhaltigkeit
- Learnings
layout: post
image: /assets/imgs/gears-of-industry.jpg
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
CC BY-NC-ND 2.0, House Photography' %}

Im Juli und August habe ich viel Zeit im kühlen Maschinenraum verbracht 
und dieser Site gearbeitet. 
Sowohl unter der Haube als auch am Antlitz.

## Upgrade auf Jekyll 4.x

Seit der [Migration von Drupal nach Jekyll](
{% post_url  2019-11-09-von-drupal-nach-jekyll %})
Ende 2018 lief diese Site 
mit der damals aktuellen Version 3.8.5.
Grund genug, mal ein Upgrade zu fahren.
Zudem wollte ich in Genuss der Verbesserungen von Jekyll 4 zu kommen.

Gerade das angekündigte 

> Jekyll builds should be much faster.[^j4] 

macht beim lokalen Arbeiten mit `jekyll serve` bereits 
ohne `--incremental`[^inc] einen deutlichen Unterschied.
Das Schreiben und Arbeiten an der Site 
macht durch die schnellere Resonanz mehr Spaß. 

## Blog, Tags und Tagseiten

Das Facelift habe ich mit der [Blogübersichtsseite]({% link pages/blog.html %}) begonnen
und mich dann über [Tags (jetzt Themen)]({%link pages/themen.html %}) zu den einzelnen Themenseiten vorgearbeitet.
Mich hat das sehr Reduzierte und die Übersichtlichkeit 
auf <https://dri.es> schon sehr lange angesprochen. 
So habe ich das jetzt mal nachgebaut.

## Startseite und Navigation

Neben der ganzen Technik hat die [Startseite](/) ein komplett neues Gesicht bekommen.
Ich habe wieder mal Startseite, Navigation und einige Seiten überarbeitet.
Mein [Portfolio](/#mein-angebot) als [Coach]({%link pages/angebot/coaching.md %}) 
und [Wildnistrainer]({% link pages/angebot/coaching.md %}) stehen jetzt Vorgrund
und bekommen auf der Startseite jetzt den entsprechenden Raum. 

## CO₂ Ausstoß der Website stark reduziert

Ein Nebeneffekt der Überarbeitungen, gerade das Weglassen der Teaserbilder 
in Übersichtsseiten bei Blog und Tags, 
ist viel geringere Datenmenge, die je Seitenaufruf generiert wird

Das hat zu einer starken Reduzierung des CO₂ Fußabdrucks der Website geführt.
Laut [Website Carbon Calculator](
https://www.websitecarbon.com/website/florian-latzel-io/) 
sind das jetzt 0,03 Gramm CO₂ pro Seitenaufruf.

Mal schauen, ob ich den mit dem [Picture Plugin](
https://rbuchberger.github.io/jekyll_picture_tag/)
und dem Ausbau vom Lazyload-Skript und dem TOC Plugin (geht ja auch via Kramdown[^toc]
noch weiter drücken kann.

## Learnings

Bei Jekyll bin ich über die Filter *link* und *post_url*[^links] gestoßen.
Beide sorgen für valide Permalinks 
und brechen den Build Prozess bei Fehlern ab. 
Interne *broken links* ade.

In Punkto Frontend habe ich sehr viel Neues gelernt und angewandt.
Gerade was HTML und CSS angeht, zum Beispiele Mediaqueries,
filter + Transitions, Listen mit Columns oder display-flex und Prozentangabe.
Seitdem ich in den frühen Zweitausendern mit HTML gestartet bin,
hat sich doch einiges getan.
Während meiner Zeit als Softwareentwickler habe ich mich 
diesem Themenkomplex immer verschlossen.

> Ich mache kein Frontend.

Vielleicht gerade deswegen.

Bei Blog und Themen habe ich mich tiefer mit Liquid[^liquid], 
der Template Sprache von Jekyll auseinandergesetzt.
Habe programmiert, ausprobiert und auf Stackoverflow geforscht (repeat).
Zudem habe ich nach über 10 Jahren auch mal wieder mit einem Javascript-Framework 
gearbeitet und habe die Idee trotz des funktionierenden Versuchs verworfen.
Bei vielen der kleinen Fortschritte, 
gerade beim Aufeinandertreffen von Frontend und Backend 
habe ich öfters mal ein lautes *Ja* ausgestoßen 
und bin von meinen Sitzball für den ein oder anderen *Erfolgstanz* aufgestanden.
Schön zu erfahren, dass ich "es" noch kann 
und schön mal wieder so tief im Tunnel gewesen zu sein. 

Die Überarbeitung die Startseite ließ mich 
viel über mein Portfolio nachdenken.
Was will ich anbieten und wie stelle ich das dar?
Wie transportiere ich den Punkt als Teaser in zwei Zeilen auf etwa 70 Zeichen
(von der Überarbeitung der Detailseiten (WIP) ganz abgesehen)?
Welche Referenzen möchte ich nutzen 
und in welcher Reihenfolge möchte ich sie darstellen? 
Zuletzt habe ich mein Angebot von sechs auf vier Punkte
und die Referenzen in Relation von vier auf drei Zeilen reduziert.

[^j4]: <https://jekyllrb.com/news/2019/08/20/jekyll-4-0-0-released/>
[^inc]: <https://jekyllrb.com/docs/configuration/incremental-regeneration/>
[^links]: <https://jekyllrb.com/docs/liquid/tags/#links>
[^liquid]: <https://shopify.github.io/liquid/>
[^toc]: <https://kramdown.gettalong.org/converter/html.html#toc>

*[TOC]: Table of Contents
*[WIP]: Work in Progress

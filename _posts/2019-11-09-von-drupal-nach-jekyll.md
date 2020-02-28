---
title: "s/Drupal/Jekyll"
tags: 
- Drupal
- Jekyll
- Open Source
- SSG
- netzaffe
- uberspace
layout: post
toc: true
last_modified_at: 2019-11-10 11:48
image: /assets/imgs/jekyll-logo-dark-solid.png
---
<figure role="group">
  {% responsive_image path: assets/imgs/jekyll-logo-dark-solid.png alt:"Jekyll Logo, dark solid " %}
  <figcaption>Jekyll Logo, CC-BY 4.0</figcaption>
</figure>
tl;dr Von Drupal[^drupal] nach Jekyll[^jekyll].   
Seit Anfang 2019 läuft mein Blog bereits mit Jekyll[^jekyll], 
einen *Statischen Seiten Generator*.  
Dieser Artikel beschreibt, 
warum ich nach fast 15 Jahren *Drupal CMS Framework*[^drupal] 
durch *Jekyll SSG* als zugrundeliegende Technologie ersetzt habe.<!--break-->

# Kleiner Geschichtsabriss

Ich betreibe dieses Blog, oder genauer gesagt,
das Stück Software, aus dem dieses Blog hervorgegangen ist, seit 2004.
Das waren um die 15 Jahre mit Drupal, gestartet mit der Version 4.5.
Diese Installation war auch immer meine Spielwiese, 
um z.B. interessante Drupal-Module auzuprobieren.
In 2009 habe ich dann das Update von Drupal 5 auf Drupal 6 gemacht.

Seit dem Erscheinen von Drupal 8 im Jahr 2016, 
nutze ich  Drupal 6 LTS mit einigen Verbiegungen[^hacks], 
welches weiterhin aus der Community mit Sicherheits-Updates versorgt wird.
Es sei angemerkt, dass laut Drupal Policy immer nur 2 Versionen unterstützt werden, 
ergo zu diesen Zeitpunkt Drupal in der Version 7 und 8.

Trotz der Versorgung mit Sicherheits-Updates und, 
abgesehen von dem einen oder anderen Rudiment in der Datenbank aus den Jahren,
ist und bleibt es ein 10 Jahre altes Stück Software 
mit einer recht altertümlichen Anmutung, weit vor der *Ära Mobile*. 

Ein Upgrade war also unabwendbar. Also habe ich teils mit dafür gesorgt, 
daß die von mir benötigten Module auch für Drupal 8 zur Verfügung stehen
und habe entsprechend mit an entsprechenden Modul-Portierungen für Drupal 8 mitgearbeitet. 
Z.B. an Footnotes[^fn], GeshiFilter[^geshi] oder dem Gist Input Filter[^gist].
Aber unabhängig davon, dass die Migrationsversuche 
nach Drupal 8 bei mir auf Anhieb nicht korrekt durchliefen,
hat sich für mich Drupal 8 irgendwie als zu groß und sperrig 
für einen simples Blog wie meines angefühlt.
 
Aber da war dann noch Jekyll, 
welches seit Anfang 2016 in meinem Backlog stand 
(Danke Ben von der GzEvD für die Inspiration!).
Im Winter 2018 bin ich dann endlich dazu gekommen, 
Jekyll zu installieren und das Step by Step Tutorial[^sbst] durchzugehen.

# Warum Jekyll?

Was hat mich an Jekyll so begeistert und mich dazu bewegt auf diesen SSG zu wechseln?

## Drupal-Importer

Jekyll hat einen *Drupal Importer* für die Versionen 6 und 7, 
das ist natürlich weniger ein Beweggrund, 
als eine Grundvorraussetzung, 
da ich meine *Nodes*, also meine geschriebenen Beiträge natürlich mitnehmen wollte.

## KISS - Jekyll ist einfach.  

### Einfacher Start

Mit bereits installiertem *Ruby* und *Ruby Gems* sind es nur ein `gem install jekyll bundler`  
für die Installation,  
ein `jekyll new example.com` für das Erstellen einer Site  
und ein `bundle exec jekyll serve --drafts` das *Hochfahren* des lokalen Webservers,
der dann unter <http://127.0.0.1:4000> erreichbar ist notwendig,
um mit einem lokalem Jekyll auf Tuchfühlung zu gehen.

### Einfache Struktur

Jekylls einfache Funktionsweise spiegelt sich auch seiner Verzeichnisstruktur[^dir] wider:

```
example.com
├── 404.html
├── _config.yml
├── Gemfile
├── Gemfile.lock
├── index.md
├── _drafts
|   ├── ideenfindung.md
|   └── hier-wird-noch-dran-gefeilt.md
├── _posts
|   └── 2019-04-22-agile-ruhr-hattrick.md
└── _site
    ├─ 2019
    |   └── 04
    |         └── 22
    |             └── agile-ruhr-hattrick.html
    ├── 404.html
    ├── feed.xml
    └── index.html
```

Im Minimalumfang sind die folgenden Einträge relevant:
- *_config.yml* Die zentrale Konfigurationsdatei. 
Hier werden grundlegende Einstellungen für die Website und seine Erweiterungen vorgenommen.
- *Gemfile + Gemfile.lock* Die Abhängigkeiten für dieses Projekt. 
Hier werden die sog. Gems[^gems] wie Jekyll selbst und seine Plugins inkl. Version festgehalten,
welche via Bundler[^gems] verwaltet werden. 
Bundler lässt sich mit Composer[^composer] in der Drupal/PHP-Welt vergleichen.
- *_drafts* Hier liegen, wie der Name bereits vermuten lässt, Entwürfe. 
- *_posts* Der Ordner für die publizierten Artikel.
Den Posts muss noch ein Datumsprefix vorangestellt werden.
- *_site* Die von Jekyll erzeugte Website bestehend aus statischen HTML-Dateien.
Also das was am Ende durch einen Webserver oder `jekyll serve` ausgeliefert wird.

### Geringe Komplexität

Jekyll benötigt im Vergleich zu einem CMS wie Drupal keine Datenbank
und damit verbunden auch keine Programmiersprache wie PHP, 
die die Verbindung zur DB herstellt, 
um die nötigen SQL-Abfragen für den Aufbau der angefragten Seite auszuführen.

Also keine wechselseitigen Abhängkeiten 
und einzelnen Stellschrauben wie bei LAMP in Setup und Betrieb mehr.

Das alles führt zu einer deutlichen Veringerung der Komplexität.

### Markdown

Markdown[^md] ist eine vereinfachte Auszeichnungssprache.  
Ein erklärtes Ziel bei der Entstehung von Markdown war die leichte Lesbarkeit.

Bei Jekyll kommt der Markdown Dialekt Kramdown[^kramdown] zum Einsatz.
Dessen Umfang wurde unter anderem durch Fußnoten, Tabellen, 
Definitions-Listen und Abkürzungen erweitert.

Im Gegensatz zum HTML ist Markdown nicht nur viel leichter lesbar, 
sondern auch wesentlich schlanker und entsprechend einfach 
und auch ohne WYSIWYG Editor gut und recht intuitiv bearbeitbar.

## Geschwindigkeit 

Bei Drupal erfolgt zuerst der sogenannte *Bootstrap Prozess*[^boot1] [^boot2],
welcher für das Laden der Konfiguration, 
Initialsierung der Datenbank und Variablen zuständig ist.
Dann wird entschieden, unter anderem via Auswertung der URL, was ausgeliefert wird.
Hier kommt maßgeblich die Datenbank an ins Spiel.

Auch wenn das sog. Bootstrapping bei anderen CMS unterschiedlich sein mag,
gleich ist die Ausführung von Code und Datenbankabfragen 
für die dynamische Auslieferung einer Seite durch einen Request.

Im Vergleich zum CMS werden beim SSG direkt statische HTML Dateien ausgespielt.
Das ist wesentlich performanter.

## Keine Sicherheits-Updates

Durch die Verwendung einer serverseitigen Skriptsprache,
egal ob es nun PHP, Python oder Perl im Beispiel des Apache Webservers ist, 
kann auch auf das CMS zugegriffen werden.
Software wie CMS enthält potenziell wie jede andere Software auch Fehler.
Gleiches gilt auch für Zusatzmodule,
welche nicht nur den Funktionsumfang, sondern auch das Einfallstor
für Angriffe vergrößern.

Wie beim Punkt Geschwindgkeit punktet hier auch wieder statisches HTML,
das aus dem SSG heraus erzeugt wird. Da keine Skiptsprache bzw. Software nachgelagert ist
bzw. diese nicht über die Anfrage auf den Webserver erreichbar ist, 
fällt dieser Angriffsvektor weg.

Spätestens seit dem letzten Drupalgeddon[^sa1] [^sa2], bin ich heilfroh, 
dass Sicherheits-Updates nichts mehr sind, worum ich mich (zeitnah) kümmern muss!

## Viele Plugins & Themes 

Jekyll ist weit verbreitet, das ist bestimmt nicht nur darin begründet,
dass die kostenlosen *GitHub Pages*[^githubpages] auch mit Jekyll betrieben werden können,
sondern, sicherlich auch wegen der nicht geringen Anzahl von sogenannten Plugins,
welche den Funktionsumfang erweitern und Themes, welche für das Look'n'Feel verantworlich sind.

Für alle von mir benötigten *Drupal Module* habe ich das jeweilige *Jekyll Plugin* Pendant einsetzten können
oder es mit Bordmitteln geschafft.

Plugins
- [Planet Jekyll](https://github.com/planetjekyll/awesome-jekyll-plugins)
- [jekyll-plugin topic auf GitHub](https://github.com/topics/jekyll-plugin)

Themes
- <http://jamstackthemes.dev>
- <https://jekyllthemes.org>
- <https://jekyllthemes.io>

## Arbeitsweise

Begünstigt dadurch, dass eine Jekyll Installation nur aus Dateien besteht, 
lassen sich Erstellung und Änderung von Inhalt, 
Konfiguration und Template-Logik mit einen Editor, 
in meinem Fall dem Vim[^vim], durchführen.
Es gibt auch keinen Zwischenschritt 
über den Browser zur Bearbeitung und Speicherung von Inhalt mehr.

Darauf aufbauend lassen sich natürlich Text-Dateien wunderbar mit einem VCS verwalten,
und das Deployment in die *DocumentRoot* auf Uberspace 
läuft über einen *post-receive git-hook*. 
Das heißt, alle einzelnen Schritte sind über die Konsole möglich.

> Blogging Like a Hacker[^tpw]

Diese Arbeitsweise sagt mir mehr zu. 
Ich habe das Gefühl effizienter zu arbeiten 
und kann mich wesentlich mehr auf die eigentliche Arbeit, 
der Erstellung von Inhalt, konzentrieren.

## Ein neues Spielzeug

Ein neues Stück Software und ein sich daraus erschließender Mikrokosmos.  
Es fing alles mit einer *Sandbox Installation* und dem *Jekyll Step by Step Tutoriali*[^sbst] an.  
Mit dem *Jekyll Importer für Drupal 6* und dessen Anpassung ging es weiter
und das, obwohl ich eigentlich kein Ruby spreche.
Den Funktionsumfang durch Plugins erweitern und konfigurieren, 
Anpassung des *Standardthemes Minima*[^minima], 
Inkludieren von Logik via *Liquid Template Engine*[^liquid], alles neue Spielzeuge.  
Viel Neues und Unbekanntes, viel ausprobieren und experimentieren 
und die immens große Freude über erzielte Erfolge.

## FLOSS

Klar, Jekyll ist mit MIT Lizenz FLOSS.
Und klar, die Lizenz ist wichtig, 
aber ich möchte zudem auf noch etwas anderes hinaus:

Dadurch, dass Konfiguration sowie *Template Logik* in Code festgehalten wird,
zusammen mit der Möglichkeit, GitHub Pages mit Jekyll zu betreiben,
und der Verbindung von Netlify nach GitHub oder GitLab,
gibt viele öffentlich verfügbare Repositories auf GitHub und Co.

Das hat einen großen Lerneffekt, spart viel Zeit und noch mehr Frust.
Man muss das Rad ja nicht immer wieder neu erfinden.

# Negatives

Last but not least, etwas Negatives: Geschwindigkeit.  
Es dauert lange,  bis eine Änderung (Inhalt, Theme, etc.)
von `jekyll serve --draft` erkannt wird und die Seite "regeneriert" wird.

# To be continued

Ich habe noch 2 verwandte Artikel in *_draft*, die bald folgen werden:

- *Migration von Drupal 6 nach Jekyll*. 
Vorbereitende Schritte, Anpassung des *Jekyll Drupal6 Importers* und Nacharbeiten.
- *Jekyll Deployment auf Uberspace via Bare Repo und post-receive Hook*.
Uber das Aufsetzen und das *post-receive* Shellskript für ein Deployment auf Uberspace.

---

[^drupal]: [Drupal CMS](https://drupal.org)
[^jekyll]: [Jekyll](https://jekyllrb.com)
[^hacks]: Pressflow Drupal, modifiertes Drush in Symbiose mit dem [MydropWizzard Modul](https://www.drupal.org/project/mydropwizard) für Updates über github statt d.o
[^fn]: [footnotes 8.x port](https://www.drupal.org/sandbox/fl3a/2593257)
[^sbst]: [Jekyll Step by Step Tutorial](https://jekyllrb.com/docs/step-by-step/01-setup/)
[^geshi]: [GeSHi Filter for syntax highlighting](https://www.drupal.org/project/geshifilter)
[^gist]: [Gist Input Filter (gist_filter) 8.x Port](https://www.drupal.org/sandbox/fl3a/2819998)
[^dir]: [Jekyll: Directory Structure](https://jekyllrb.com/docs/structure/)
[^gems]: [Ruby-Programmierung: Rubygems und Bundler](https://de.wikibooks.org/wiki/Ruby-Programmierung:_Rubygems#Rubygems_und_Bundler)
[^composer]: [Composer](https://getcomposer.org/)
[^md]: [Markdown Syntax](https://daringfireball.net/projects/markdown/syntax)
[^kramdown]: [Kramdown Syntax](https://kramdown.gettalong.org/syntax.html)
[^boot1]: [How Drupal returns a page request](https://befused.com/drupal/page-request)
[^boot2]: [How Drupal handles the page request: Bootstrap Process](https://www.valuebound.com/resources/blog/how-drupal-handles-page-request-bootstrap-process)
[^sa1]: [Drupal core - Highly critical - Remote Code Execution - SA-CORE-2018-002](https://www.drupal.org/SA-CORE-2018-002)
[^sa2]: [Drupalgeddon 2: Angreifer attackieren ungepatchte Drupal-Webseiten](https://www.heise.de/security/meldung/Drupalgeddon-2-Angreifer-attackieren-ungepatchte-Drupal-Webseiten-4024700.html)
[^githubpages]: [Setting up a GitHub Pages site with Jekyll](https://help.github.com/en/articles/setting-up-a-github-pages-site-with-jekyll)
[^vim]: [Vim Editor](https://www.vim.org/)
[^tpw]: [Tom Preston-Werner, Blogging Like a Hacker](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html)
[^liquid]: [Liquid template languagei](https://shopify.github.io/liquid/)
[^minima]: [Minima theme](https://github.com/jekyll/minima)

*[CMS]: Content Management System
*[SSG]: Statischer Seiten Generator
*[LTS]: Long Term Support
*[KISS]: Keep It Stupid Simple
*[GzEvD]: Gesellschaft zur Entwicklung von Dingen mbH
*[d.o]: drupal.org
*[LAMP]: Linux Apache MySQL/MariaDB PHP
*[VCS]: Version Control System
*[DB]: Datenbank
*[FLOSS]: Free/Libre Open Source Software
*[Vim]: Vi IMproved

---
layout: post
title: Responsive Images und Lazyload bei Jekyll
toc: true
tags:
- Jekyll
- howto
- Nachhaltigkeit
- SEO
- uberspace
---

Vorher:[^fnet] [^front]

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images | 1.357,97 KB | 1.360,75 KB |
|3       |html   |    50,54 KB |    18,27 KB |
|1       |css    |   11,26 KB  |     3,49 KB |

Nachher, mit jekyll-responsive-images und Lazyload: [^fnet] [^front] [^conf] 

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images |   646,17 KB |   648,95 KB |
| 3      |html   |    52,56 KB |    18,50 KB |
| 1      |css    |    11,60 KB |     3,65 KB |
| 1      |js     |        0 KB |    28,06 KB |

> Reduzierte Inhalte sparen Ressourcen und damit auch Emissionen bei jedem Seitenaufruf.[^rbklima]    

Das ist nicht nur Nachhaltig im Sinne von Resourcenschonend und gut fürs Klima
sondern Google mag es auch noch gerne.

> Zudem fließt die Performance der Website auch in die Ranking-Kriterien 
> von Google ein, sodass auch die Auffindbarkeit über die Suchmaschine davon profitiert.[^rbklima]

So empfahl mir *Google PageSpeed Insights* zur Verbesserung der Performance auch folgendes:
- Bilder richtig dimensionieren
- Bilder in modernen Formaten bereitstellen


Diese Howto beschreibt die Installtion und Konfiguration von *jekyll-responsive-images*
und Zusammenspiel mit einem Lazyload Skript im Zusammenspiel mit Jekylls *Standardtheme* miminma 
unter Linux, hier auf uberspace mit dem Ziel die übertragene Datenmenge von Bildern und somit CO2 einzusparen.
<!--break-->

## Installation

Die Installation des *jekyll-responsive-image Gems*.

### jekyll-responsive-image 

Hier muss *jekyll-responsive-image* im *Gemfile* vermerkt werden.

```ruby
gem 'jekyll-responsive-image'
```

### ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.

Beim Versuch *jekyll-responsive-image* zu installieren brach Bundler 
mit der folgenden Meldung ab.

> ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.

Das via Default verlangte rmagic Gem kann nicht mit ImageMagick in der Versison 7[^rmagick],
bei u7 ist Version ImageMagick in der Version 7.0.9-26.

Tipp war beim rmagick Gem auf Version 4.1.0.rc2, das hat bei mir geklappt.[^rmagick].

Im *Gemfile*, vor `group :jekyll_plugins do` muss *rmagick* 
mit Versionsnummer *4.1.0.rc2* spezifiziert werden.

Die Einbindung erfolgt im Gemile vor den *jekyll_plugins*:

```ruby
...
gem "rmagick", "4.1.0.rc2"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
  gem 'jekyll-sitemap'
  gem 'jekyll-seo-tag'
  gem 'jekyll-toc'
  gem 'jekyll-paginate-v2', '2.0.0'
  gem 'jekyll-responsive-image'
end
```

Jetzt nochmal den Bundler bemühen und die Installation läuft durch:

```bash
bundle install
```

## Konfiguration

Die Settings erfolgen wie gewohnt in *_config*.

### _config

Ich habe Ratans[^ratan] Angaben um *strip* ergänzt, 
so lässt sich nochmal die Bildgröße Daten durch ein *strip* 
von  EXIF und JPEG Profilen minimieren. Google mags.

## Image templates anlegen

Die Templates benutzten `srcset` innerhalb von des Img-Tags. 
Das Entscheidende ist das `sizes` Attribut[^sizes].
Bei der Verwendung von `sizes` entscheidet der Browser via *Media Queries*
welche der in `srcset` angegebene Bilder geladen werden soll 
und nicht nach Breite des Viewports.

Ich habe auf 800px und 400px *min-width* die verkleinerten Bilder
mit 740px und 370px gemappt (sog. *media conditions*). 
Das entspricht exakt der Größe,
die ein Bild bei Desktop- und Mobileansicht einnimmt.

Ein Template für normale Bilder.

### _includes/responsive-image.html

```liquid
{% raw %}
{% capture srcset %}
{% for i in resized %}
    /{{ i.path }} {{ i.width }}w,
{% endfor %}
{% endcapture %}

{% assign smallest = resized | sort: 'width' | first %}

<img width="100%" src="/{{ smallest.path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }}" sizes = "(min-width: 800px) 740px, (min-width: 400px) 370px" class="blur-up lazyautosizes lazyload {{ class }}">
{% endraw %}
```

Ein Template für Bilder im `<figure>` Tag.

### _includes/figure.html

```liquid
{% raw %}
{% capture srcset %}
{% for i in resized %}
    /{{ i.path }} {{ i.width }}w,
{% endfor %}
{% endcapture %}

{% assign smallest = resized | sort: 'width' | first %}

<img width="100%" src="/{{ smallest.path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }}" sizes = "(min-width: 800px) 740px, (min-width: 400px) 370px" class="blur-up lazyautosizes lazyload {{ class }}">
{% endraw %}
```

## lazysizes.js

Wir nutzten zusätzlich noch  lazysizes.js, 
einen hochperformanten und SEO freundlicher Lazy-Loader von aFarkas[^lazysizes].

### Installation

Anlegen des *js* Ordners, sofern nicht da, wechsel dorthin und Download via Curl:

```
mkdir assets/js
cd assets/js
curl -O http://afarkas.github.io/lazysizes/lazysizes.min.js
```

### Einbindung

Einbindung von lazyload.js.min in *_includes/head.html*[^head] zwischen *feeds_meta* 
und dem schließendem head-Tag:


```html
{% raw %}
<head>
  <meta charset="utf-8">
  ...
  {%- feed_meta -%}
  <script src="{{ '/assets/js/lazysizes.min.js'| relative_url }}"></script>   
</head>
{% endraw %}
```

Hier verwende ich anders als Ratan den `relative_url`  Filter[^filter],
so wird nicht auf `config.url`, wie bei `absolute_url` zugegriffen.

Dieser Ansatz funktioniert dann auch bei Subdomains.

relative_url

### CSS Anpassung

```css
.no-js img.lazyload {
  display: none;
}

.blur-up {
  filter: blur(10px);
  transition: filter 400ms;
}

.blur-up.lazyloaded {
  filter: blur(0);
}

.fade-in {
  opacity: 0;
  transition: opacity 400ms;
}

.fade-in.lazyloaded {
  opacity: 1;
}
```

## Benutzung

## Fazit

Bei Mobile Devices wird richtig deutlich[^fnet] [^frontm] [^confm]:

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images |   203,06 KB |   205,83 KB |
| 3      |html   |    52,56 KB |    18,50 KB |
|1       |css    |    11,60 KB |     3,65 KB |
|1       |js     |        0 KB |    28,06 KB |

Bei der Desktop Ansicht haben wir eine Dateneinsparung um den Faktor 2.1 (1.360,75 KB / 648,95 KB = 2,0968).

Bei der Mobile Ansicht haben wir sogar eine Dateneinsparung um den Faktor 6,6 (1.360,75 KB / 205,83 KB = 6,611).

{% responsive_image figure: true path: assets/imgs/carbon-calculator-netzaffe-76-percent.png 
alt: "Website Carbon Calculator Ergebniss für netzaffe.de" %} 

Durch die Nutzung von *Responsive Images* in Kombination mit Lazyloading 
konnte ich die *Carbon results* von netzaffe.de von 56% auf 76% erhöhen. 

## Danke

Die Inspiration für diesen Artikel lieferte Dietmar vom Reinblau mit seinem Artikel 
*Klimaschutz und Webentwicklung*[^rbklima], danke dafür.


Ein großer Dank geht an Ratan Parai, mein erster Anlauf war sein Howto 
*Responsive image on jekyll*[^ratan], auf dem diese Anleitung basiert.


jpegtran

```
jpegtran -copy none -optimize -progressive -outfile asterix-bei-den-briten-grafitti-hanbury-st-london.jpg asterix-bei-den-briten-grafitti-hanbury-st-london.jpg
```

## Fußnoten

[^front]: Startseite, Minima Theme mit Desktop Auflösung  
[^fnet]: Gemessen mit dem Firefox Netzwerkanalyse Werkzeug  
[^conf]: Konfiguration: *width: 740px* bei *quality: 90* und *strip: true*
[^rmagick]: [Installation issue: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h. #806](https://github.com/rmagick/rmagick/issues/806#issuecomment-535301931)
[^rbklima]: [reinblau: Klimaschutz und Webentwicklung](https://reinblau.coop/blog/klimaschutz-und-webentwicklung/)
[^ratan]: [Ratan Sunder Parai, Responsive image on jekyll](https://www.ratanparai.com/jekyll/Responsive-image-on-jekyll/)
[^lazysizes]: <https://github.com/aFarkas/lazysizes>
[^head]: [minima/_includes/head.html](https://github.com/jekyll/minima/blob/master/_includes/head.html)
[^sizes]: [selfhtml: Gestaltung mit sizes](https://wiki.selfhtml.org/wiki/HTML/Multimedia_und_Grafiken/picture)
[^filter]: [Liquid Filters](https://jekyllrb.com/docs/liquid/filters/)
[^ccalc]: [Website Carbon Calculator](https://www.websitecarbon.com/)
[^frontm]: Startseite, Minima Theme mit Galaxy 9/S9+ (360x740) Auflösung 
[^confm]: Konfiguration: *width: 370px* bei *quality: 80* und *strip: true*

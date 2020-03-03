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
und Zusammenspiel mit Lazyload im Zusammenspiel mit Jekylls *Standardtheme* miminma 
unter Linux, hier auf uberspace   
mit dem Ziel die übertragene Datenmenge von Bildern und somit CO2 einzusparen.
<!--break-->

## Installation

### jekyll-responsive-image 

```ruby
gem 'jekyll-responsive-image'
```

### ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.

> ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.[^rmagick]


Im Gemfile, vor `group :jekyll_plugins do`:

```ruby
gem "rmagick", "4.1.0.rc2"
```

Gemile

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

```bash
bundle install
```

## Konfiguration

strip Option

## Image templates anlegen

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

_includes/head.html


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


relative_url

## CSS Anpassung

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

Bei Mobile Devices wird richtig deutlich: [^fnet] [^frontm] [^confm]

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images |   203,06 KB |   205,83 KB |
| 3      |html   |    52,56 KB |    18,50 KB |
|1       |css    |    11,60 KB |     3,65 KB |
|1       |js     |        0 KB |    28,06 KB |


* 1.360,75 KB / 648,95 KB = 2,0968
* 1.360,75 KB / 205,83 KB = 6,611


Platzhalter Carbon Calculator[^ccalc], Verbesserung um 20%

## Danke

Inspiration[^rbklima] erster Anlauf war das Howto *Responsive image on jekyll*[^ratan] von Ratan Parai.

jpegtran

```
jpegtran -copy none -optimize -progressive -outfile asterix-bei-den-briten-grafitti-hanbury-st-london.jpg asterix-bei-den-briten-grafitti-hanbury-st-london.jpg
```

## Fußnoten

[^front]: Startseite, Minima Theme mit Desktop Auflösung  
[^fnet]: Gemessen mit dem Firefox Netzwerkanalyse Werkzeug  
[^conf]: Konfiguration: *width: 740px* bei *quality: 90* und *strip: true*
[^rmagick]: [Installation issue: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h. #806](https://github.com/rmagick/rmagick/issues/806#issuecomment-535301931)
[^rbklima]: [Klimaschutz und Webentwicklung](https://reinblau.coop/blog/klimaschutz-und-webentwicklung/)
[^ratan]: [Ratan Sunder Parai, Responsive image on jekyll](https://www.ratanparai.com/jekyll/Responsive-image-on-jekyll/)
[^ccalc]: [Website Carbon Calculator](https://www.websitecarbon.com/)
[^frontm]: Startseite, Minima Theme mit Galaxy 9/S9+ (360x740) Auflösung 
[^confm]: Konfiguration: *width: 370px* bei *quality: 80* und *strip: true*

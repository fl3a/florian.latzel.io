---
layout: post
title: 'C02 sparen: Responsive Images und Lazyload bei Jekyll'
toc: true
tags:
- Jekyll
- howto
- Nachhaltigkeit
- SEO
- uberspace
image: /assets/imgs/carbon-calculator-netzaffe-76-percent.png
---

Netzwerkdaten vorher:[^fnet] [^front]

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images | 1.357,97 KB | 1.360,75 KB |
|3       |html   |    50,54 KB |    18,27 KB |
|1       |css    |   11,26 KB  |     3,49 KB |

Netzwerkdaten, nachher (mit jekyll-responsive-images und Lazyload): [^fnet] [^front] [^conf] 

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images |   646,17 KB |   648,95 KB |
| 3      |html   |    52,56 KB |    18,50 KB |
| 1      |css    |    11,60 KB |     3,65 KB |
| 1      |js     |        0 KB |    28,06 KB |

> Reduzierte Inhalte sparen Ressourcen und damit auch Emissionen bei jedem Seitenaufruf.[^rbklima]    

Das ist nicht nur nachhaltig im Sinne von ressourcenschonend und gut fürs Klima,    
sondern Google mag es auch noch gerne.

> Zudem fließt die Performance der Website auch in die Ranking-Kriterien 
> von Google ein, sodass auch die Auffindbarkeit über die Suchmaschine davon profitiert.[^rbklima]

So empfahl mir *Google PageSpeed Insights* zur Verbesserung der Performance von netzaffe.de
auch die richtige Dimensionierung vom Bildern.

Dieses *[Howto](/tags/howto.html)* hat das Ziel die übertragene Datenmenge von Bildern
und somit den CO2-Ausstoß dieser Website mimimieren.

Ich beschreibe die Installation und Konfiguration von *jekyll-responsive-images[^resp]*,
im Zusammenspiel mit einem neuen Template und einen Lazyload Skript, 
eingebunden in [Jekylls](/tags/jekyll.html) *Standardtheme* miminma[^minima] 
unter [Linux](/tags/linux.html), hier CentOS auf [uberspace](/tags/uberspace) 7.<!--break-->

## Installation

Die Installation des *jekyll-responsive-image Gems* ist zweisschrittig.

Zuerst muss *jekyll-responsive-image* im *Gemfile* vermerkt werden...

```ruby
gem 'jekyll-responsive-image'
```

...dann wird Bundler auf das Gemfile losgelassen.

### ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.

Beim Versuch *jekyll-responsive-image* zu installieren brach Bundler 
mit der folgenden Meldung ab.

> ERROR: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h.

Das via Default verlangte *Gem rmagick* kann nicht mit ImageMagick in der Version 7[^rmagick],
bei *uberspace 7* war aber ImageMagick in der Version 7.0.9-26 an Board.

Ein Tipp[^rmagick] war beim *rmagick Gem* auf Version 4.1.0.rc2 zu *pinnen*, 
das hat bei mir geklappt.

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

Jetzt nochmal den Bundler als zweiten Schritt bemühen und die Installation läuft durch:

```bash
bundle install
```

## Konfiguration

Die Settings erfolgen wie gewohnt in *_config*.

### _config

Ich habe Ratans[^ratan] Angaben um *strip* ergänzt, 
so lässt sich nochmal die Dateigröße 
von EXIF und JPEG Profilen weiter minimieren. 
Google mags.

Die folgenden Zeilen müssen in *_config* hinzugefügt werden.

```yaml
{% raw %}
# jekyll-responsive-image
# https://github.com/wildlyinaccurate/jekyll-responsive-image
responsive_image:
  # Path to the image template.
  template: _includes/responsive-image.html

  # [Optional, Default: 85]
  # Quality to use when resizing images.
  default_quality: 90

  # [Optional, Default: []]
  # An array of resize configuration objects. Each object must contain at least
  # a `width` value.
  sizes:
    - width: 370  # [Required] How wide the resized image will be.
      quality: 80  # [Optional] Overrides default_quality for this size.
    - width: 740

  # [Optional, Default: false]
  # Rotate resized images depending on their EXIF rotation attribute. Useful for
  # working with JPGs directly from digital cameras and smartphones
  auto_rotate: false

  # [Optional, Default: false]
  # Strip EXIF and other JPEG profiles. Helps to minimize JPEG size and win friends
  # at Google PageSpeed.
  strip: true

  # [Optional, Default: assets]
  # The base directory where assets are stored. This is used to determine the
  # `dirname` value in `output_path_format` below.
  base_path: assets/imgs

  # [Optional, Default: assets/resized/%{filename}-%{width}x%{height}.%{extension}]
  # The template used when generating filenames for resized images. Must be a
  # relative path.
  #
  # Parameters available are:
  #   %{dirname}     Directory of the file relative to `base_path` (assets/sub/dir/some-file.jpg => sub/dir)
  #   %{basename}    Basename of the file (assets/some-file.jpg => some-file.jpg)
  #   %{filename}    Basename without the extension (assets/some-file.jpg => some-file)
  #   %{extension}   Extension of the file (assets/some-file.jpg => jpg)
  #   %{width}       Width of the resized image
  #   %{height}      Height of the resized image
  #
  output_path_format: assets/imgs/resized/%{width}/%{basename}

  # [Optional, Default: true]
  # Whether or not to save the generated assets into the source folder.
  save_to_source: false

  # [Optional, Default: false]
  # Cache the result of {% responsive_image %} and {% responsive_image_block %} 
  # tags. See the "Caching" section of the README for more information.
  cache: false

  #/ [Optional, Default: []]
  # By default, only images referenced by the responsive_image and responsive_image_block
  # tags are resized. Here you can set a list of paths or path globs to resize other
  # images. This is useful for resizing images which will be referenced from stylesheets.
  extra_images:
    - assets/foo/bar.png
    - assets/bgs/*.png
    - assets/avatars/*.{jpeg,jpg}
{% endraw %}
```

Hint: Damit die Konfigurationsänderungen greifen,
 muss `bundle exec jekyll serve` erneut gestartet werden.

## Image Template anlegen

Die Templates benutzten `srcset` innerhalb von des Img-Tags. 

Das Entscheidende ist aber das `sizes` Attribut[^sizes].  
Bei der Verwendung von `sizes` entscheidet der Browser via *Media Queries*
welche der in `srcset` angegebene Bilder geladen werden soll. 
Die geschieht hier nach der Größe des umgebenden Elements in Pixeln 
und nicht nach Breite des Viewports.

Ich habe auf 800px und 400px *min-width* die verkleinerten Bilder
mit 740px und 370px gemappt (sog. *media conditions*). 
Das entspricht exakt der Größe,
die ein Bild bei Desktop- und Mobileansicht einnimmt.

### _includes/responsive-image.html

Ein Template für Bilder in `<figure>` und standalone `<img>` Tags.

Innerhalb der Figure-Variante wird per Default das Alt-Attribute 
als `<figcaption>` genutzt, 
kann aber via Belegung der Variable `caption` überschrieben werden.

Siehe auch [Benutzung des Templates](/2020/04/07/responsive-image.html#benutzung).

```liquid
{% raw %}
{% capture srcset %}
{% for i in resized %}
    /{{ i.path }} {{ i.width }}w,
{% endfor %}
{% endcapture %}

{% assign smallest = resized | sort: 'width' | first %}

{% if figure %}
<figure role="group">
  <img width="100%" src="/{{ smallest.path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }}" sizes="(min-width: 800px) 740px, (min-width: 400px) 370px" class="blur-up lazyautosizes lazyload {{ class }}" />
<figcaption>{% if caption %}{{ caption }}{% else %}{{ alt }}{% endif %}</figcaption>
</figure>
{% else %}
<img width="100%" src="/{{ smallest.path }}" alt="{{ alt }}" srcset="{{ srcset | strip_newlines }}" sizes = "(min-width: 800px) 740px, (min-width: 400px) 370px" class="blur-up lazyautosizes lazyload {{ class }}" />
{% endif %}
{% endraw %}
```

## lazysizes.js

Wir nutzten zusätzlich noch lazysizes.js, 
einen hochperformanten und SEO freundlicher Lazy-Loader von aFarkas[^lazysizes].

### Installation

Anlegen des *js* Ordners, wechsel hinein und Download des Java-Scripts via Curl:

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

### CSS Anpassung

Am Ende der *_scss/minima.scss* habe `"netzaffe"` angehangen 
um Style Änderungen ohne Modifikation am Minima-Themes vornehmen zu können.
```
@import
  "minima/base",
  "minima/layout",
  "minima/syntax-highlighting",
  "netzaffe"
;
```

Das folgende Snippet für den Lazyloader fügst du *_scss/netzaffe.scss* hinzu:

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

Hier exemplarisch das Teaserbild in [Fünf Jahre Nichtraucher, mein Weg dorthin](/2020/03/29/fuenf-jahre-nichtraucher-mein-weg-dorthin.html):
- durch `figure: true` wird die Figure-Variante im Template genutzt. Fallback ist img.
- `path:`, gefolgt vom Pfad zum Bild, **ohne** führenden `/`
- Alternativer Text: `alt: 'Aschenbecher voll mit Wasser, Zigarettenkippen und Brinkhoffs No1 Kronkorken'`
- Das dedizierte `caption` wird für das `<figcaption>` genutzt, 
hier für Name des Werkes, Künstler, Quelle und Lizenz. 
Wenn nicht spezifizert, wird der Inhalt von *alt* hierfür genutzt.

```liquid
{% raw %}
{% responsive_image figure: true path: assets/imgs/voller-aschenbecher-brinkhoffs.jpg alt: 'Aschenbecher voll mit Wasser, Zigarettenkippen und Brinkhoffs No1 Kronkorken' caption: '<a href="https://www.flickr.com/photos/erix/8441122874/in/photostream/">circular misery</a> von Erich Ferdinand, CC BY 2.0' %}
{% endraw %}
```

## bundle install

Bei Updates des zu Grunde liegenden Systems kann es 
bei den Deployments, die auch Aktualisierungen des Gemfiles
berücksichtigen, gelegentlich rumpeln.

So ist auf uberspace zwischenzeitlich Imagemagick aktualisiert worden, 
dadurch ist mein Post-Receive Hook für das Jekyll Deployment[^post]
beim `bundle install` ausgestiegen:

> Gem Load Error is:  
> This installation of RMagick was configured with ImageMagick 7.0.9  
> but ImageMagick 7.0.10-0 is in use.[^redownload]

Abhilfe ist ein erneutes Ausführen von `bundle install` 
mit der Option `--redownload` wenn der vorige Befehl 
einen *Exit Status* != 0 liefert. 
So werden die Gems runtergeladen und neu gebaut.

`bundle install --path=~/.gem || bundle install --path=~/.gem --redownload`[^redownload]

## Fazit

### Netzwerkdaten

Bei Mobile Devices wird die Einsparung 
der übertragenen Daten richtig deutlich.

Netzwerkdaten vorher:[^fnet] [^front]

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images | 1.357,97 KB | 1.360,75 KB |
|3       |html   |    50,54 KB |    18,27 KB |
|1       |css    |   11,26 KB  |     3,49 KB |

Netzwerkdaten, nachher (mit jekyll-responsive-images und Lazyload):[^fnet] [^frontm] [^confm]:

|Dateien | Typ   | Größe       | Übertragen  |
|:------:|:-----:|------------:|------------:|
| 9      |images |   203,06 KB |   205,83 KB |
| 3      |html   |    52,56 KB |    18,50 KB |
|1       |css    |    11,60 KB |     3,65 KB |
|1       |js     |        0 KB |    28,06 KB |

Bei der Desktop Ansicht haben wir eine Dateneinsparung um den Faktor 2.1,  
1.360,75 KB / 648,95 KB = 2,0968.

Bei der Mobile Ansicht haben wir sogar eine Dateneinsparung um den Faktor 6,6,  
1.360,75 KB / 205,83 KB = 6,611.

### Website Carbon Calculator

{% responsive_image figure: true path: assets/imgs/carbon-calculator-netzaffe-76-percent.png  alt: 'Website Carbon Calculator Ergebniss für netzaffe.de nach Optimierung durch Responsive Images' %} 

Durch die Nutzung von *Responsive Images* in Kombination mit Lazyloading 
konnte ich die Ergebnisse des *Website Carbon Calculators[^ccalc]* von netzaffe.de 
um 20% verbessern. 

### Google Page Speed

{% responsive_image figure: true path: assets/imgs/screenshot-google-pagespeed-netzaffe-de-desktop.png alt: "Google PageSpeed für netzaffe.de, Desktop, Score 100 von 100" %}
Das Google es auch gerne mag, 
quittert mir *Google PageSpeed* jetzt mit einem Score von 100 bei der *Desktop Ansicht*
und 99 bei der *Mobil Ansicht*
nachdem ich die Bilder in den richtigen Dimensionen anbiete.
Hier habe ich leider keine Vorher-Nachher-Vergleiche...  
Mehr Datenersparnis wäre bei den Bildern nur nur noch mit Googles WebP[^webp] Format zu erreichen.

## Danke

Die Inspiration für diesen Artikel und etwas mehr Awareness für das Thema
lieferte mir Dietmar vom Reinblau mit seinem Artikel 
*Klimaschutz und Webentwicklung*[^rbklima], danke dafür!

Ein großer Dank geht an Ratan Parai, mein erster Anlauf war sein Howto 
*Responsive image on jekyll*[^ratan], auf dem dieses Howto basiert!

Ich werde selbst noch ein wenig mit den Parametern bei `quality` spielen
und schauen, wie weit man ohne Qualitätseinbuße gehen kann.

Vielleicht konnte ich euch inspirieren, auch wenn ihr ein anderes System nutzt.
Selbst mit Bordmitteln, wie das hier genutzte *convert* von Imagemagick
sind bereits Dateneinsparungen realisierbar. 
Vergleichbar wäre z.B. jpegtran.
```
jpegtran -copy none -optimize -progressive -outfile example.jpg example-opt.jpg
```

## Fußnoten

[reset.to: So verkleinerst du deinen digitalen Fußabdruck](https://reset.org/act/so-verkleinerst-du-deinen-digitalen-fussabdruck-08162019)

[^fnet]: Gemessen mit dem Firefox Netzwerkanalyse Werkzeug  
[^front]: Startseite, Minima Theme mit Desktop Auflösung  
[^conf]: jekyll-responsive-images Konfigurationsparameter: *width: 740px, quality: 90, strip: true*
[^resp]: [jekyll-responsive-image](https://github.com/wildlyinaccurate/jekyll-responsive-image)
[^rmagick]: [Installation issue: Can't install RMagick 4.0.0. Can't find magick/MagickCore.h. #806](https://github.com/rmagick/rmagick/issues/806#issuecomment-535301931)
[^rbklima]: [reinblau: Klimaschutz und Webentwicklung](https://reinblau.coop/blog/klimaschutz-und-webentwicklung/)
[^minima]: [Minima Theme](https://github.com/jekyll/minima)
[^ratan]: [Ratan Sunder Parai, Responsive image on jekyll](https://www.ratanparai.com/jekyll/Responsive-image-on-jekyll/)
[^lazysizes]: <https://github.com/aFarkas/lazysizes>
[^head]: [minima/_includes/head.html](https://github.com/jekyll/minima/blob/master/_includes/head.html)
[^sizes]: [selfhtml: Gestaltung mit sizes](https://wiki.selfhtml.org/wiki/HTML/Multimedia_und_Grafiken/picture)
[^post]: [jekyll_uberspace_deployment](https://github.com/fl3a/jekyll_uberspace_deployment)
[^redownload]: [Commit: Fallback für bundle install](https://github.com/fl3a/jekyll_uberspace_deployment/commit/d91452052d67f298366037726df0f13cb3b165f4)
[^filter]: [Liquid Filters](https://jekyllrb.com/docs/liquid/filters/)
[^ccalc]: [Website Carbon Calculator](https://www.websitecarbon.com/)
[^frontm]: Startseite, Minima Theme mit Galaxy 9/S9+ (360x740) Auflösung 
[^confm]: jekyll-responsive-images Konfigurationsparameter: *width: 370px, quality: 80, strip: true*
[^webp]: [Serve images in next-gen formats](https://web.dev/uses-webp-images/?utm_source=lighthouse&utm_medium=unknown)

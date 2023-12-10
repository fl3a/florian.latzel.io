---
layout: post
title: "CO2 sparen II: Das Jekyll Picture Tag Plugin"
tags:
- howto
- Jekyll
- liquid
- netzaffe
- Nachhaltigkeit
- uberspace
image: /assets/imgs/gears-of-industry.jpg 
---
{% responsive_image figure: true alt: Zahnräder
path: assets/imgs/gears-of-industry.jpg 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>,
CC BY-NC-ND 2.0, House Photography' %}


<figure>
<figcaption>Lighthouse Audit, Absschnitt Performance zu moderneren Bildformaten</figcaption>
<blockquote>
Serve images in next-gen formats<br />   
<br />
Image formats like WebP and AVIF often provide better compression than PNG or JPEG,<br />    
which means faster downloads and less data consumption. Learn more about modern image formats.
</blockquote>
</figure>
https://github.com/rbuchberger/jekyll_picture_tag, 595 Stars, 29 Contributors, Commits on Apr 6, 2023
https://github.com/wildlyinaccurate/jekyll-responsive-image 3320 Stars, 13, Contributors, Commits on Feb 23, 2021

in 2023 [C02 sparen: Responsive Images und Lazyload bei Jekyll]({%link _posts/2020-04-07-co2-sparen-responsive-images-lazyload-jekyll.md %})

<!--break-->
## Installation von libvips 

libpng, libwebp, libjpeg, and libheif 

### Local


#### Debian
```
sudo apt install libvips  libvips-dev                             
```

#### Mäc

```
ìnstall libvips libheif
```

### Remote (auf uberspace) 

```
wget https://github.com/libvips/libvips/releases/download/v8.14.5/vips-8.14.5.tar.xz
tar xf vips-8.14.5.tar.xz
cd vips-8.14.5
```

#### Build-System: Meson 

Libvips verwendet Meson als Build System.

```
pip3 install --user meson
```
PATH anspassen

```
export PATH=$HOME/.local/bin:$HOME/bin:$PATH
```

### Ninja

https://ninja-build.org/

> Meson can use ninja, Visual Studio or XCode as a backend, so you’ll also need one of them.
```
python -m pip install --user ninja
```

### Building libvips from source 

Text adventure


```
meson setup build-dir --prefix=$HOME
cd build-dir
ninja
ninja test
ninja install
```

### Jekyll deployments

https://github.com/fl3a/jekyll_deployment

Search path to search for extra libraries, e.g. **libvips.so.42** 

deploy.conf
```
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/lib64"
```

## Das jekyll_picture_tag Plugin


### Installation

Gemfile, https://github.com/fl3a/florian.latzel.io/blob/picture/Gemfile#L38-L39

```
gem "jekyll", "~>4.3.2"


group :jekyll_plugins do
   # (other jekyll plugins)

  gem 'jekyll_picture_tag', '~> 2.0.4'

end
```

```
bundle install
```

ruby-vips 2.0.17

### _config

https://github.com/fl3a/florian.latzel.io/blob/picture/_config.yml#L77-L78


```yml
picture:
  source: assets/imgs
  output: assets/imgs/generated
  suppress_warnings: false           # Default
  fast_build: false                  # Default
  ignore_missing_images: delevopment # Default: false
  disabled: nopics                   # Default: false
  nomarkdown: true                   # Default
```

### Presets

 _data/picture.yml
 https://rbuchberger.github.io/jekyll_picture_tag/users/presets/

```yml
presets:
  
  mobile:
    markup: direct_url
    fallback_format: webp
    fallback_width: 400 

  full:
    markup: direct_url
    fallback_format: webp
    fallback_width: 740 
  
  fallback:
    markup: direct_url
    fallback_format: original
    fallback_width: 740 
```


## Plugin für das responsive_image Tag

https://github.com/fl3a/florian.latzel.io/tree/picture/_plugins

```
_plugins
└── jekyll_my_responsive_image
    └── lib
        ├── jekyll_my_responsive_image
        │   ├── config.rb
        │   ├── renderer.rb
        │   └── tag.rb
        └── jekyll_my_responsive_image.rb
```


### _config

In *_config.yml*, siehe https://github.com/fl3a/florian.latzel.io/blob/picture/_config.yml#L77-L78
```
my_responsive_image:
  template: _includes/responsive-image.html
```

### Template

```liquid
{% raw %}
{% assign image =  path | remove: 'assets/imgs/' %}

{% capture picture %}
<a href="/{{ path }}">
  <picture>
    <source media="(max-width:430px)" srcset="{% picture mobile {{ image }} %}">
    <source media="(min-width:431px)" srcset="{% picture full {{ image }} %}">
    <img src="{% picture fallback {{ image }} %}" alt="{{ alt }}">
  </picture>
</a>
{% endcapture %}

{% if figure %}
<figure>
{{ picture }}
<figcaption>{% if caption %}{{ caption }}{% else %}{{ alt }}{% endif %}</figcaption>
</figure>
{% else %}
  {{ picture }}
{% endif %}
{% endraw %}
```




Footnotes

[^picture]: [<picture>: The Picture element - mdm](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/picture)
[^figure]: [<figure>: The Figure with Optional Caption element - mdm](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure)
[^canipicture]: [Can i use: Picture element](https://caniuse.com/picture)
[^caniwebp]: [Can i use: WebP image format](https://caniuse.com/webp)
[^caniavif]: [Can i use: AVIF image format](https://caniuse.com/avif)
[^installlibvips]: <https://www.libvips.org/install.html>

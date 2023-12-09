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
---
In 2023


{% responsive_image figure: true alt: Zahnräder
path: assets/imgs/gears-of-industry.jpg 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>,
CC BY-NC-ND 2.0, House Photography' %}
  
<!--break-->
## Installation von libvips 

### Local

```
sudo apt install libvips  libvips-dev                             
```

### Auf uberspace 

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

## Das jekyll_picture_tag Plugin


### Installation

Gemfile

```
gem "jekyll", "~>4.3.2"


group :jekyll_plugins do
   # (other jekyll plugins)

  # https://github.com/rbuchberger/jekyll_picture_tag
  gem 'jekyll_picture_tag', '~> 2.0.4'


end
```

```
bundle install
```

ruby-vips 2.0.17

### Presets

## Plugin für das respsonsive_image Tag

### Template

```
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
```

### Config



---
title: jekyll-deployment-1.0.1
tags:
- jekyll
- deployment
- '#!/bin/bash'
- git
layout: post
date: 2022-04-25 22:53
image: /assets/imgs/gears-of-industry.jpg
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
CC BY-NC-ND 2.0, House Photography' %}
Dieses Wochenende habe ich nach circa dreieinhalb Jahren [Jekyll](/tags/jekyll/)
und entsprechend auch dreieinhalb Jahren *Jekyll Deployments* 
auf meinen [uberspace🚀](https://uberspace.de)
vom gleichnamigen Skript [jekyll-deployment](https://github.com/fl3a/jekyll_deployment)
mal ein Release veröffentlicht.
Es waren genau gesagt zwei Releases, v1.0.0 am Samstag, 
[v1.0.1](https://github.com/fl3a/jekyll_deployment/releases/tag/1.0.1) am Sonntag.<!--break-->

Neben vielen Vereinfachungen, ein paar Fixes, 
einigen neuen Variablen und möglichen Overrides, 
und der Einführung eines *Post-Exec Tasks* war das Elementarste:    
Dokumentation, endlich mal eine [README.md](
https://github.com/fl3a/jekyll_deployment/blob/master/README.md).  
Über das besagte Skript habe ich bereits vor knapp einem Jahr den Post,
[*Jekyll Deployment via Bare Repository und post-receive Hook*](
/jekyll-deployment-via-bare-repository-und-post-receive-hook.html)
veröffentlicht, der für die Dokumentation als Grundlage diente.   
Im Patch von 1.0.0 auf [v1.0.1](
https://github.com/fl3a/jekyll_deployment/releases/tag/1.0.1)
waren weitere Verbesserungen der README und Korrekturen aus der Übersetzung.

In den etwa dreieinhalb Jahren gab es mal eine *post-receive* 
und eine *Standalone* Variante,    
aus der jetzt ein Skript geworden ist,
welches in beiden Fällen die selbe Konfiguration aus dem *Git (Bare) Repository* einliest.
Erst vor kurzem brauchte ich dann die Funktionalität eines *Post-Exec Tasks*,
da meine letzte Jekyll Instanz in ein Unterverzeichnis meiner Website generiert wird.
Das heißt, da sonst weg, muss nach jeden Deployment meiner Website 
auch das Deployment der anderen Jekyll Instanz direkt im Anschluss angestoßen werden.

Falls auch Jekyll nutzt und einen eigenen Server hast 
oder wie ich auf [uberspace](https://uberspace.de) bist	  
oder du deine Seite, *GitHub Actions* hin oder her, 
vielleicht einfach nicht via *GitHub Pages* hosten magst,
dann *clone*  das [Repository](https://github.com/fl3a/jekyll_deployment) 
und schau dir mal das [jekyll-deployment Skript](
https://github.com/fl3a/jekyll_deployment) an
oder lad dir direkt [v1.0.1](
https://github.com/fl3a/jekyll_deployment/releases/tag/1.0.1) runter!

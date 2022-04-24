---
title: jekyll-deployment-1.0.1
tags:
- jekyll
- deployment
- bash
- git
layout: post
image: /assets/imgs/gears-of-industry.jpg
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
CC BY-NC-ND 2.0, House Photography' %}
Dieses Wochenende habe ich nach circa dreieinhalb Jahren Jekyll
und entsprechend auch dreieinhalb Jahren *Jekyll Deployments* 
auf meinen [uberspace](https://uberspace.de)
vom gleichnamigen Skript [jekyll-deployment](https://github.com/fl3a/jekyll_deployment)
mal ein Release veröffentlicht.
Es waren genau gesagt zwei Releases, v1.0.0 am Samstag, 
[v1.0.1](https://github.com/fl3a/jekyll_deployment/releases/tag/1.0.1) am Sonntag.  

Neben ein paar Fixes und Vereinfachungen, 
der Einführung eines *Post-Exec Tasks*, 
einigen neuen Variablen und möglichen Overrides, 
war das Elementarste:    
Dokumentation, vor allem endlich mal eine README.   
Über das besagte Skript habe ich bereits 
vor knapp einem Jahr einen Post,
[*Jekyll Deployment via Bare Repository und post-receive Hook*](
/jekyll-deployment-via-bare-repository-und-post-receive-hook.html)
veröffentlicht, der für die Dokumentation als Grundlage diente.   
Im Patch von 1.0.0 auf [v1.0.1](
https://github.com/fl3a/jekyll_deployment/releases/tag/1.0.1)
waren weitere Verbesserungen und Korrekturen aus der Übersetzung.<!--break-->

In den etwa dreieinhalb Jahren gab es dann mal ein *post-receive* 
und eine *Standalone* Variante, aus der mittleweile ein Skript geworden ist,
welches die Konfiguration jetzt aus dem *Git (Bare) Repository* ausliest.   
Erst vor kurzem brauchte ich dann die Funktionalität eines *Post-Exec Tasks*,
da meine letze Jekyll Instanz in ein Unterverzeichnis meiner Website generiert wird.
Das heißt, da sonst weg, muss nach jeden Deployment meiner Website 
auch das Deployment der anderen Jekyll Instanz angestoßen werden.

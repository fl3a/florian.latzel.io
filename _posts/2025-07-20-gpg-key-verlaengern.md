---
title: 'GPG-Key abgelaufen? So verlängerst du Haupt- und Unterschlüssel'
tags:                                                                           
- howto
- gpg
- Datenschutz
- Sicherheit
- Verschlüsselung
- Linux
layout: post
image: /assets/imgs/gnupg/gnupg-logo.png
description: 'Schritt-für-Schritt-Anleitung, 
wie du in GnuPG das Verfallsdatum deines GPG-Hauptschlüssels und der Unterschlüssel verlängerst.'
---
{% responsive_image figure: true path: assets/imgs/gnupg/gnupg-logo.png         
alt: "GnuPG Logo" caption: "GnuPG Logo, Thomas Wittek, GnuPG Projekt, Gemeinfrei" %}

In den letzten Tagen ist mein [GnuPG Schlüssel](
{% post_url  2008-11-26-gnupg-micro-howto %}) abgelaufen.

Da das Verlängern des Ablaufdatums nicht zu den alltäglichen Aufgaben gehört, 
habe ich die Schritte protokolliert und mein [GnuPG Micro Howto](
{% post_url  2008-11-26-gnupg-micro-howto %}) 
um das Kapitel [**Verfallsdatum des GPG-Schlüssels und seiner Unterschlüssel ändern**](
/gnupg-micro-howto.html#verfallsdatum-des-gpg-schlüssels-und-seiner-unterschlüssel-ändern) 
erweitert.<!--break-->

Das ursprüngliche [GPG-Howto]({% post_url 2008-11-26-gnupg-micro-howto %}) 
stammt aus dem Jahr 2008 und basiert auf *GnuPG 1.4.6*.  
Ab 2021 habe ich es grundlegend aktualisiert – 
nun basierend auf einem mit *GnuPG 2.2.4* erstellten Schlüssel.

Neu hinzugekommen sind unter anderem folgende Kapitel:

- [Einrichtung von Web Key Directory (WKD)](
/gnupg-micro-howto.html#web-key-directory-wkd)  
- [Nutzung der keys.openpgp.org Keyserver](
/gnupg-micro-howto.html#public-key-auf-keysopenpgporg-ver%C3%B6ffentlichen)  
- [User-ID widerrufen (revuid)](
/gnupg-micro-howto.html#prim%C3%A4re-user-id-kennzeichnen)

Dieses Howto lebt von Aktualität und Praxisbezug.
Wenn dir beim Verlängern deines Schlüssels etwas aufgefallen ist 
oder du Ergänzungen hast:
- mach einen [Pull Request](
https://github.com/fl3a/florian.latzel.io/blob/master/_posts/2008-11-26-gnupg-micro-howto.md)
- oder schreib mir direkt

Danke für deine Unterstützung!



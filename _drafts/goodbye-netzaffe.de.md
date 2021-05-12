---
title: Goodbye netzaffe.de
tags:
- netzaffe.de
- Domain
- luckow
- apache2
- .htaccess
layout: post
image: /assets/imgs/fehler-umleitungsfehler.png
---
{%responsive_image path: assets/imgs/fehler-umleitungsfehler.png %}
Die Ära netzaffe.de geht nach über 14 Jahren zu Ende.
<!--break-->
Klickbait! Ich wollte eine wenig nerdig klingendere und etwas persönlichere Domain
für dieses Blog .
 
Da alle *klassischen* TLDs schon lange weg sind und mein Namenverwandter Wolf-Erich
leider auf keine Anfrage, eine seiner vielen latzel Domains abzugeben reagiert hat, 
ging der Gedanke die Tage in Richtung florianlatzel.tld. 

## latzel.io

In einem Telefonat mit meinem Freund Stephan Luckow bekam ich den 
Impuls für latzel.io.   
Der Goldene weg: io als TLD ist noch ein bischen nerdig
und bei florian als Subdomain (**florian.latzel.io**) 
habe genau jenes persönliche Konstrukt wieder.
Dann habe ich noch die Möglichkeit meinen Verwandten Subdomains bereitzustellen. 
Zuletzt: Mails ala vorname@nachname.tld haben natürlich auch was. tbd.

<figure>
<blockquote>
Mit Ein-/Ausgabe (abgekürzt E/A; englisch input/output, 
kurz I/O) bezeichnet man – als Begriff aus der EDV bzw. der Informatik – 
die Kommunikation / Interaktion eines Informationssystems mit seiner 'Außenwelt'[...]
</blockquote>
<figcaption>Catchphrase aus wikipedia.de zu &quot;Eingabe und Ausgabe&quot;</figcaption>
</figure>

## 301er Redirects auf florian.latzel.io

Natürlich behalte ich die Menge Content und auch die Domain netzaffe.de
Ich leite alle netzaffe.de Anfragen, auch von Subdomains 
u.a aus SEO Gründen wie *Duplicate Content* auf die neue Haupt-Domain 
inklusive Pfad via *Permament Redirect* um.

Das habe ich in der Datei `.htaccess` so gemacht:

```
RewriteCond %{HTTP_HOST} !^florian\.latzel\.io$
RewriteRule ^(.*)$ https://florian.latzel.io/$1 [L,R=301]
```

Hier gehe ich auf die Variable `HTTP_HOST` des HTTP Header[^doc] 
und vergleiche, ob der `HTTP_HOST` ungleich florian.latzel.io ist,
also der neuen Domain und leitei, wenn die Bedingung wahr ist,
inklusive "Pfad" auf florian.latzel.io weiter.

Hat nicht funktioniert: Umleitung auf eine neue Domain[^red1] [^red2].  
Habe ich ausprobiert und mich *im Kreis gedreht* (siehe Screenshot oben)
```
RewriteCond %{REQUEST_URI} (.*)
RewriteRule ^(.*)$ http://neue-domain.tld/$1 [L,R=301]
```

Danke Stephan für den kleinen Impuls mit der Domain, der nur ein Teil eines langen, guten Telefonats war.
Danke an mein Team-Kollegen Arne, der mir <https://www.namecheap.com/> günstigen als Registrar nahegelegt hat.

[^red1]: [selfhtml: Umleitung auf eine neue Domain](https://wiki.selfhtml.org/wiki/Webserver/htaccess/Umleitungen_mit_mod_rewrite#Umleitung_auf_eine_neue_Domain)
[^red2]: [Domains weiterleiten auf Hauptdomain](https://www.html-seminar.de/domains-weiterleiten-auf-hauptdomain.htm)
[^doc]: [http.apache.org: mod_rewrite#rewritecond](http://httpd.apachie.org/docs/2.4/mod/mod_rewrite.html#rewritecond)

*[TLD]: Top Level Domain

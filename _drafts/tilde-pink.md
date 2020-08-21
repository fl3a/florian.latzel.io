---
title: tilde.pink
tags:
- tildeverse
- UNIX
- Internet
- Netzkultur
- Open Source
- ssh
- gopher
layout: post
toc: true
image: /assets/imgs/tilde-pink-index-page.png
---
{% responsive_image path: assets/imgs/tilde-pink-index-page.png figure: 
true 
alt: 'tilde.pink´s index page. Hoher Nerdfaktor, denn ab hier geht es nur noch mit dem gopher oder gemini Protokoll  weiter.' %}

Nachdem ich *Carstens Post über envs.net[^envs] und das tildeverse[^pubnixes]* 
gelesen habe, war ich total angefixt. 
Ich wollte unbedingt auch sonen **Shell-Accont**!
Also schlaumachen, was ist dieses **tildeverse**?
<figure>
  <blockquote>we’re a loose association of like-minded tilde communities. 
if you’re interested in learning about *nix (linux, unix, bsd, etc) 
come check out our member tildes and sign up!</blockquote>
  <figcaption>
    Zu tildeverse auf <a href="https://tildeverse.org/">https://tildeverse.org</a>
  </figcaption>
</figure>
So habe ich mich für die eine *Tilde* 
aus den *Member Tildes/Pubnix-Servern[^pubnixes]* entscheiden, 
eine *Request Mail[^req]* verfasst 
und jetzt erkundige ich das *Tildeverse* auf tilde.pink.
<!--break-->

## Tilde?

Der Versuch einer Erklärung...

Zur Tilde (`~`) auf wikipedia[^tilde]:

> Die Tilde (~) (spanisch tilde, portugiesisch til, von lateinisch titulus 
> ‚Überschrift‘, ‚Überzeichen‘) ist ein Schriftzeichen in Form einer aus zwei 
> gleich großen Buchten gebildeten waagerechten Wellenlinie. 

Unter unixoiden Systemen steht die Tilde für das eigene Benutzerverzeichnis,  
ein `cd ~` entspricht also `cd /home/fl3a`.

Nähern wir uns dem *Tilde-Namen*, dieser ist hinter die URL gepackt 
und besteht der Tilde-Zeichen und dem Benutzernamen, `~fl3a`.  
Paul Ford, der *"Erfinder"* der tilde.clubs vergleicht die Tilde 
auch mit dem vorangestelltem `@` bei den Twitter-Handles, 
schlussfolgernd es handelt sich um eine Person.[^ford]

Unter dem Kunstwort *Tilde-Space*, 
verstehe ich `https://envs.net/~cblte`[^cblte] oder `gopher://tilde.pink:70/1/~fl3a`[^fl3a],
was auch eine Tilde sein könnte,
oder anolog auch das vorgelagerte Verzeichnis welches von jeweiligen Dienst
ausgeliefert wird, `/home/fl3a/public_gopher` oder `/home/cblte/public_html`,
oder vielleich einfach das Benutzerverzeichnis an sich?!

Eine *(Member) Tilde* ist auch ein Pubnix-Server[^pubnixes], 
ein gutes Beispiel wäre hier tilde.pink.

## Warum tilde.pink

https://en.wikipedia.org/wiki/Ken_Thompson#/media/File:Ken_Thompson_(sitting)_and_Dennis_Ritchie_at_PDP-11_(2876612463).jpg

Beim durchgehen der Pubnixes[^pubnixes] sprangen mir die *BSD´s 
(neben dem einem Windows-Server 😆)  
als erstes ins Auge.  
Mit Linux habe ich genug Erfahrung gesammelt, 
vor den BSD´s hatte ich bis dato irgendwie Respekt 
und habe deshalb wohl auch noch nie eines auf meiner Hardware installiert gehabt.
Wissend des *Nicht-Wissens*, der vermeindlichen Unterschiede zu Linux 
und der Tatsache, dass NetBSD historisch vom *Ur-UNIX*[^unixhist] abstammt 
(während Linux *nur* ein *UNIX-ähnliches* System ist, 
was sich parallel zum UNIX-Baum entwickelt hat)
waren auf jeden Fall ein Beweggrund. 


### gopher

Während ein Webserver scheinbar obligatorisch ist,
bietet tilde.pink[^pink] nur gopher[^phlog] [^gopher] [^gopherz]
und gemini[^gemini] an.
Zu gopher hatte ich nur *alt und Protokoll* im Kopf, musste selbst noch recherchieren.  
Kleine Zusammenfassung: gibts seit 1991, Netwerkprotokoll, RFC 1436, Port 70,
sowas wie ein Vorläufer des heutigen www, Dokumentenbasiert und sehr einfach.  
In 1994 gab es 8 mal mehr gopher Instanzen als WWW Server im Netz[^phlog],
das änderte dann unter anderem mit dem *NCSA Mosaik Browser*, 
der auch Grafiken darstellen konnte.

Das fand ich irgendwie reizvoll er
etwas auf gopher mit begrenzteren Mitteln zu publizieren,
zumal ich ja schon einen Blog habe, dazu kommt (kennen-)lernen.
Das war Beweggrund 2.

Unter `gopher://tilde.pink:70/1/~fl3a`[^fl3a] 
habe jetzt ein so genanntes *Gopherhole* 
und halte dort meine Schritte und (Re-)Learnings im tildeverse 
in einen so genannten Phlog[^wphlog] [^phlog] fest.

## Ein kleiner Rückblick

Getriggert
Angefixt und mit positiven Gedanken in die Vergangenheit zurück befördert, meine erste  
- bbsh2ala
- Social/Multiuser
- irc und Nicknames
- Shell Accounts



[^envs]: [Carstens Post über envs.net](https://blog.zn80.net/envs-net-envs-net)
[^pubnixes]: [tildeverse members/pubnixes](https://tildeverse.org/members/)
[^req]: Viele Pubnix-Server habe entsprechende Signup Formulare, bei tilde.pink geht das via Mail
[^tilde]: <https://de.wikipedia.org/wiki/Tilde>
[^cblte]: <https://envs.net/~cblte/>
[^pink]: <http://tilde.pink>
[^fl3a]: [gopher://tilde.pink:70/1/~fl3a (via Floodgap Proxy)](https://proxy.tilde.pink/cgi-bin/proxy.cgi?q=tilde.pink/1/~fl3a/)
[^ford]: [I had a couple drinks and woke up with 1,000 nerds - The story of Tilde.Club](https://medium.com/message/tilde-club-i-had-a-couple-drinks-and-woke-up-with-1-000-nerds-a8904f0a2ebf)
[^unixhist]: <https://de.wikipedia.org/wiki/Geschichte_von_Unix>
[^gopher]: <https://de.wikipedia.org/wiki/Gopher>
[^gemini]: [~solderpunk > gemini](https://gopher.floodgap.com/gopher/gw?=zaibatsu.circumlunar.space+70+312f7e736f6c64657270756e6b2f67656d696e69)
[^gopherz]: [gopher.zone - Highway to the Gopher Zone](https://gopher.zone/)
[^phlog]: [Jens Ohlig - GPN4:Phlog - Blogging über Gopher](https://entropia.de/GPN4:Phlog_-_Blogging_%C3%BCber_Gopher)
[^wphlog]: <https://en.wikipedia.org/wiki/Phlog>

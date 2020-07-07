---
title: GoAccess auf Uberspace
tags:
- GoAccess
- Linux
- uberspace
- howto
- Open Source
- apache2
- Logs
- Analytics
- cron
layout: post
toc: true
image: /assets/imgs/goaccess-ncurces-console-screenshot.png
last_modified_at: 2020-04-26
---
<figure>
  {% responsive_image path: assets/imgs/goaccess-ncurces-console-screenshot.png alt: "Screenshot: GoAccess Web-Analytics auf der Konsole" %}
  <figcaption>Screenshot: GoAccess Web-Log-Analytics auf der Konsole</figcaption>
</figure>
Nach einer längeren Suche nach einem *Apache Log Viewer* bzw. *Web Log Analyzer*, 
der auf der Konsole läuft und *404er/Not found* aussagekräftig darstellen kann, 
bin ich auf [GoAccess](https://goaccess.io/) gestoßen.

[GoAccess](https://github.com/allinurl/goaccess) ist eine schlanke, 
FLOSS (MIT Lizenz) Web Analytics-Software, die die Zugriffsdateien des Webservers, 
die sog. Access-Logs auswertet. Die Anwendung kann mit z.B. Apache-, Nginx-, Google Cloud Storage-, 
oder Amazon-S3-Logs umgehen,
läuft mit einer sogar recht ansprechenden Nucurse-Oberfläche[^ncurses] auf der Konsole
und kann zudem noch Exporte nach JSON, CSV und HTML, was bedeutet, 
dass die GoAccess auch wie Matomo(ehemals Piwik) oder Google-Analytics auch über den Browser bedienbar ist.

Hier beschreibe ich die Installation von GoAccess aus dem Quellcode auf Uberspace 6,  
bei U7 ist GoAccess per Default mit an Board(und alle so yeah)[^ureact].  
Zudem gebe dir neben der Konfiguration von GoAccess auch Einblick in die Nutzung auf der Shell,
ein paar nette Tipps und nützliche Beispiele mit an die Hand.

Der Großteil dieses Artikels, auch die Installation sollte so generisch sein, 
dass man ihn recht einfach auf andere Systeme übertragen kann.<!--break-->

Es sei noch angemerkt, dass GoAccess auch Ausgaben in Realtime erzeugen kann,
dieses Feature ist allerdings für die Anwendung auf Uberspace 6 irrelvant, da 
die Access-Logs dort nicht live geschrieben werden[^logs].

## Installation von GoAccess
```
mkdir ~/repos
```
```
cd ~/repos
```

Wir besorgen uns den Quelltext von GoAccess via Git.
```
git clone https://github.com/allinurl/goaccess.git
```

```
cd goaccess/
```

Gegebenenfalls möchtest Du eine speziellen Branch haben,
wie hier für die Version 1.3:
```
git checkout v1.3
```

```
autoreconf -fiv
```
Es folgt der *Dreisatz*: 
```
./configure --enable-utf8 --enable-tcb=btree --prefix=$HOME
```
Bis auf `--enable-utf8` und `--prefix=$HOME`, sofern als _Non-Root User_ ausgeführt,
sind unter anderem die folgenden Parameter optional:
- `--enable-tcb=btree` Kompiliere mit Tokyo Cabinet Datenbank für die  
   [Persistierung von Access Logs in On-Disk Datenbank mit GoAccess](/2020/02/02/goaccess-persistierung-von-weblogs-in-tokyo-cabinet-on-disk-datenbank.html).
- `--with-openssl` falls _Websocket Server_ verwendet werden soll.  
  Da es auf U6 im Gegensatz U7 keine Echtzeit Logs gibt, 
  ist das Feature hier uninteressant.
- `--enable-geoip=legacy` GeoLocation Unterstützung durch die GeoIP Datenbank von MaxMind.

```
make
```
```
make install
```

## uberspace 6

### Update von gettext

Wenn `autoreconf -fiv` mit z.B. folgender Meldung abricht,
dann ist das benötigte *gettext* auf dem System zu alt.
Das war bei mir auf einer Uberspace 6 Instanz der Fall.

> autoreconf: Entering directory `.'  
> autoreconf: running: autopoint --force  
> autopoint: *** The AM_GNU_GETTEXT_VERSION declaration in your configure.ac    
> file requires the infrastructure from gettext-0.18 but this version  
> is older. Please upgrade to gettext-0.18 or newer.  
> autopoint: *** Stop.  
> autoreconf: autopoint failed with exit status: 1

Kein Problem, das lässt sich mit toast[^toast1] [^toast2] lösen:
```
toast arm gettext
```
Jetzt könnt ihr euch einen Kaffee holen, das dauert ein wenig...

Nachdem toast durchgelaufen ist, wiederholen wir `autoreconf -fiv` 
und machen mit dem *Dreisatz*(s.o.) weiter. 

### Fehlende Tokyo Cabinet Bibliothek


Wenn configure abbricht, weil es die _Tokyo Cabinet Database_ nicht findet.

> checking for tchdbnew in -ltokyocabinet... no  
> configure: error: *** Missing development libraries for Tokyo Cabinet Database

Auf _Uberspace 6_  können wir das ebenfalls via toast[^toast1] [^toast2] lösen.  
Auf _Uberspace 7_ ist GoAccess gegen tokyocabinet kompiliert 
und weiss auch wo die die Lib ist.

Da toast sich bei mir während der Suche verschluckt hat,
helfen wir etwas nach und sagen toast genau was wir wollen:

```
toast add https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
```

...jetzt wird toast fündig...

```
toast find tokyocabinet
```
```
[...]

tokyocabinet
  version 1.4.48: found
    urls:
       https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
```

...jetzt kann _tokyocabinet_ via toast installiert werden:

```
toast arm tokyocabinet
```

Jetzt müssen wir nochmal obigen *Dreisatz* wiederholen.

#### Anpassung der Variablen MANPATH

Damit der Aufruf von `man goaccess` auch die dazugehörige Manpage und nicht

> Keine Handbuchseite für goaccess 

anzeigt wird, müssen wir die Umgebungsvariable *MANPATH* anpassen.

Dazu fügen wir in *.bash_profile* die folgende Zeile ein:
```
export MANPATH="$MANPATH:$HOME/share/man/"
```

### uberspace 7

Seit ein paar Tagen (heute ist der 26.04.2020) ist auf uberspace 7
ein kaputtes rpm von GoAccess in der Version  1.3 aufgespielt worden. 
Dem rpm fehlt die Unterstützung für die *Tokyo Datenbank*.

#### goaccess: unrecognized option '--keep-db-file' 

Das lässt bestehende Cronjobs, 
die [die Access Logs in der GoAccess Datenbank sichern](/2020/02/02/goaccess-persistierung-von-weblogs-in-tokyo-cabinet-on-disk-datenbank.html), nicht mehr durchlaufen.

Cron verschickt jetzt solche Mails:

> goaccess: unrecognized option '--keep-db-file'

Es soll ein Downgrade auf 1.2 durchgeführt werden,
das fixt zwar die Datenbank, aber nicht die *KEYPHASES* von Google,
die in 1.2 nicht dargestellt wurden. 

So installiert ihr die 1.3er Version von GoAccess mit Tokyo DB Support auf uberspace 7.
Wir starten mit der Tokyo DB, die wir als Abhängigkeit für GoAccess brauchen:

```
cd /tmp
wget https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
tar xfzv tokyocabinet-1.4.48.tar.gz
cd tokyocabinet-1.4.48
autoreconf -fiv
./configure  --prefix=$HOME
make
make install
```

Damit das *configure* von GoAccess durchläuft,
geben wir *C compiler flags* via Umgebungsvariable zwei Optionen mit:

```
export CFLAGS="-I/$HOME/include -L$HOME/lib"
```

Andernfalls würdest du das sehen:

> configure: error: *** Missing development libraries for Tokyo Cabinet Database

In den Cronjobs nutze ich, wenn fertig ein `$HOME/bin/goaccess`, 
also GoAccess mit vorangestelltem Pfad statt dem von uberspace geliefertem Standard.

Weiter geht es bei [Installation von GoAccess](#installation-von-goaccess)

## Konfiguration von GoAccess

### ~/etc/goaccess/goaccess.conf

Die Config von GoAccess liegt durch die `--prefix=$HOME` Option von *configure*
unter `etc/goaccess/goaccess.conf` in deinem Home-Verezeichnis.

```
vi ~/etc/goaccess/goaccess.conf
```

Es gibt nur eine Einstellung, die für GoAccess wirklich zwingend ist  
und zwar die für den Aufbau des *Access-Logs*[^logs]
```
log-format COMBINED
```

Dann möchten wir noch, dass uns GoAccess, die Suchbegriff, mit denen Besucher 
über Google und Co auf unsere Seiten kommen auswertet.

Dies ist via Default mit `ignore-panel KEYPHRASES` dektiviert, 
wir suchen die Stelle und kommentieren die Zeile mit einer `#` am Zeilenanfang aus:
```
#ignore-panel KEYPHRASES
```

gleiches wiederholen wir für die Referrer.
```
#ignore-panel REFERRERS
```

Im Artikel über die [inkrementelle Persistierung von Access Logs in einer Tokyo Cabinet On-Disk Datenbank mit GoAcess](2020/02/02/goaccess-persistierung-von-weblogs-in-tokyo-cabinet-on-disk-datenbank.html)
beschreibe ich detailiert die [Tokyo Cabinet Optionen in goaccess.conf](/2020/02/02/goaccess-persistierung-von-weblogs-in-tokyo-cabinet-on-disk-datenbank.html#tokyo-cabinet-optionen-in-goaccessconf).

## Nutzung von GoAccess

### Beispiele

Einfache Ausführung mit Config und *Standard-Logfile*:
```
goaccess -p ~/etc/goaccess/goaccess.conf ~/logs/access_log 
```

Hier ein paar Beispiele, die auf ganz praktisch fand:

Wir wollen uns nur die Logs von einem bestimmtem Tag anzeigen lassen, z.B. den 22. April 2019 
und *pipen* die Ausgabe von `grep` nach GoAccess:
```
grep '^.*-\ - \[22/Apr/2019' ~/logs/access_log | goaccess  -p ~/etc/goaccess/goaccess.conf
```

Die via *Gzip* komprierten Logs von ca. vier Wochen via `zcat` an GoAccess durchreichen,
diesmal ohne Config stattdessen mit Log-Fomat via Option:
```
zcat ~/logs/access_log.*.gz | goaccess --log-format COMBINED 
```

Ausgabe in eine Datei via `-o` Option, hier der Export in eine Webseite, entscheidend ist der Suffix der Datei.
```
goaccess -o export.html -a -d -p ~/etc/goaccess/goaccess.conf ~/logs/access_log 
```
Durch das Argument hinter `-o`, sind auch noch Exporte via Dateiendung `.csv` und `.json`
in die entsprechenden Formate möglich.

### Hotkeys

Hier noch ein paar gebräuchliche Hotkeys für die Bedienung der von GoAccess auf der Konsole:

* `TAB`, die Panels anwählen (nach unten)
* `SHIFT` + `TAB`, die Panels anwählen (nach oben)
* `ENTER`, das angwählte Panel öffen
* `1-9`, wählt das Panel mit der Nummer direkt an, z.B. `4` für die *404er HTTP Status Codes*
* `j`, in Panel nach unten scrollen
* `k`, in Panel nach oben scrollen
* `h`, öffnet die Hilfe
* `q`, schließt das aktive Element, z.B. Hilfe, Panel oder letztendlich GoAceccess selbst

Noch mehr Beispiele findest du via `goaccess --help` oder in der Manpage[^man]. 

* * *
[^ncurses]: [Ncurses](https://de.wikipedia.org/wiki/Ncurses)
[^ureact]: <https://twitter.com/ubernauten/status/1124018556922888196>
[^toast1]: [toast - packageless package manager for Unix systems and non-root users](https://wiki.uberspace.de/system:toast) 
[^toast2]: [toast homepage]([http://www.toastball.net/toast/)
[^logs]: [Webserver Logs, access_log](https://wiki.uberspace.de/webserver:logs#access_log)
[^man]: [GoAccess Manual Page](https://goaccess.io/man)
*[FLOSS]: Free/Libre Open Source Software

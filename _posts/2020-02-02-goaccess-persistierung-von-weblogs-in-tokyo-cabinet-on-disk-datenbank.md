---
layout: post
image:
toc: true
tags:
- GoAccess
- Linux
- uberspace
- howto
- Open Source
- apache2
- Logs
- Analytics
- Datenbank 
title: "GoAccess: Inkrementelle Persistierung von Access Logs in Tokyo Cabinet On-Disk Datenbank"
image: /assets/imgs/goaccess-web-frontend.png
---
<figure role="group">
  <img src="/assets/imgs/goaccess-web-frontend.png" alt="GoAccess Web Frontend" />
  <figcaption>Das "ansehnliche" Web Frontend von GoAccess mit Daten aus einem Monat</figcaption>
</figure>
GoAccess bietet die Möglichkeit die _flüchtigen_ _Access Logs_ des Webservers
dauerhaft in einem _dateibasierten Datenbankmanagementsystem_[^dbm], 
hier einer _Tokyo Cabinet On-Disk B+ Tree Datenbank_[^tcb] zu speichern. 
So lassen sich auch längere Zeitspannen mit GoAccess auswerten.

Dieser Artikel beschreibt, wie du mit einem Cronjob die Logfiles 
wiederholend in einer solchen Datenbank persistierst[^persistenz1] [^persistenz2] 
und wie auch noch ein ansehnlicher _HTML Report_,
der auf unser erzeugtes DBM zugreift, hinten rausfällt.

In meinem Artikel über den [GoAccess Web Log Analyzer](/2019/05/02/goaccess-auf-uberspace.html) 
habe ich den Abschnitt [Installation von GoAccess](/2019/05/02/goaccess-auf-uberspace.html#installation-von-goaccess) 
um die Abhängigkeit zur _Tokyo Cabinet Datenbank_ entsprechend ergänzt. 
<!--break-->
## Vorbereitungen

### Anknipsen der Access Logs auf U7

Wenn du auch _Uberspace 7_ nutzt, 
dann musst du die Access Logs erst aktivieren[^u7logs], 
da per Default gar keine *Webserver Logs* geschrieben werden,
was aus Gründen der Datensparsamkeit schon ziemlich cool ist.

```
uberspace web log access enable
```

### Zukünftige Heimat der Datenbank

Da GoAccess seine Datenbank per Default nach `/tmp` schreibt,  
wo a), die Dateien flüchtig sind  
und b), von jedem lesbar sind,  
legen wir in unserem `$HOME` extra ein Verzeichnis dafür an.

```
mkdir $HOME/goaccess.db
```

### Zeitpunkt für die Cronjobs bestimmen

Wann erfolgt die Rotation[^logrotate] der Webserver Logfiles?

```
ls -l logs/webserver/
```

Am Beispiel eines U7 Accounts werden sieben _Web Access Logs_ vorgehalten. 
Hier wird um 03:54 das aktuellste Logfile _access.log_ nach _access_log.1_ rotiert.


```
insgesamt 15668
-rw-r--r--. 1 root root  582507  9. Jan 10:45 access_log
-rw-r--r--. 1 root root 1839549  9. Jan 03:54 access_log.1
-rw-r--r--. 1 root root 2194096  8. Jan 03:59 access_log.2
-rw-r--r--. 1 root root 2115343  7. Jan 03:59 access_log.3
-rw-r--r--. 1 root root 2161323  6. Jan 03:59 access_log.4
-rw-r--r--. 1 root root 1999593  5. Jan 03:59 access_log.5
-rw-r--r--. 1 root root 2332544  4. Jan 03:58 access_log.6
-rw-r--r--. 1 root root 2744661  3. Jan 03:59 access_log.7
```

Somit enthält _access_log.1_ die Zugriffe von Vorgestern ab 03:54 bis Gestern um 03:54.

Ein guter Zeitpunkt wäre diese Datei gegen Vier Uhr in der Datenbank zu persistieren.

## Der Einzeiler zum Prozessieren des Access Logs

Dieser Einzeiler, 
den wir als _$USER/bin/goaccess_process_log_into_db.sh_ speichern
und via `chmod u+x $USER/bin/goaccess_process_log_into_db.sh` ausführbar machen,
bereitet das obige *AccessLogFile* auf
und persistiert es in der Datenbank:

```
#!/bin/bash

goaccess \
  --log-file=$HOME/logs/webserver/access_log.1 \
  --log-format=COMBINED \
  --process-and-exit \
  --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ 
```

Access Logs werden auf Uberspace anonymisiert, 
auf u7 werden die ersten 16 Bits einer _IPv4 Addresse_ 
und die ersten 32 Bits einer _IPv6 Adresse_ protokolliert.

Wäre das nicht der Fall, 
dann solltest du auf die Option `--anonymize-ip` von GoAccess zurückgreifen.

## Der Einzeiler zur Generierung des HTML-Reports aus der Datenbank

Dieser Einzeiler,
den wir als _$USER/bin/goaccess_db_to_html.sh_ speichern 
und via `chmod u+x $USER/bin/goaccess_db_to_html.sh` ausführbar machen,
generiert einen *HTML Report* aus der Datenbank. 

```
#!/bin/bash

goaccess \
  --log-format=COMBINED \
  --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ \
  --output $HOME/index.html
```
Dein HTML-Report ist nun über <https://deinusername.uber.space> erreichbar.

Gegebenenfall möchtest du das Verzeichnis _~/html_ mit einen Passwortschutz[^htaccess] 
via _.htaccess_ versehen
um es vor fremden Blicken zu schützen.

### Verwendete Optionen mit Datenbankbezug

- `--process-and-exit`, Ideal für Cronjobs: Parsen und Ende,  
  keine Ausgabe via ncurses oder in eine Datei.
- `--keep-db-file`, persistiere die geparsten Daten in der Datenbank.
- `--load-from-disk`, lade die Datenbank um neue Daten hinzuzufügen.
- `--db-path=$HOME/goaccess.db/`, der Ort an dem die _On-Disk-Datenbank_ leben und wachsen soll. 

#### Tokyo Cabinet Optionen in goaccess.conf

Die obigen Optionen hier analog für die unsere _~/etc/goaccess/goaccess.conf_:

```
keep-db-files true
load-from-disk false
db-path /home/deinusername/goaccess.db/
```
Für eine Minimalkonfiguration siehe auch [GoAccess Web Log Analyzer: ~/etc/goaccess/goaccess.conf](/2019/05/02/goaccess-auf-uberspace.html#etcgoaccessgoaccessconf).

# Die Cronjobs anlegen

Mit den folgenden Jobs sorgen wir für eine wiederholende, 
dauerhafte Speicherung der _Access Logs_ in der Datenbank 
und einen auf der Datenbank basierenden _HTML Report_:

```
crontab -e
```

```
5 4 * * * $HOME/bin/goaccess_process_log_into_db.sh
10 4 * * * $HOME/bin/goaccess_db_to_html.sh
```
# Fallstricke

Pitfalls aka _Lessons learned_ oder Erfahrungen, 
die ihr nicht unbedingt auch machen wollt: 
- Bei einer mehrfachen Ausführung auf das gleiche Logfile merkt sich GoAccess nicht, 
das die Datei schonmal geparst wurde. 
Ergo: Die Daten für den jeweiligen Zeitraum sind n mal aufgenommen worden.
- Der Weg zu einer schönen Lösung:  
Wenn GoAccess auf _uberspace 6_ via Cron aufgerufen wird, 
dann kennt GoAccess nicht mehr den Pfad zur selbstinstallierten 
_libtokyocabinet.so.9_ Bibliothek.  
> goaccess: error while loading shared libraries: libtokyocabinet.so.9:  
> cannot open shared object file: No such file or directory.  

  - Ein `source $HOME/.bash_profile` 
  in den Skripten macht alle nötigen Umgebungsvariablen verfügbar. 
  Finde ich hässlich und es hat nichts mit der Funktion zu tun, 
  zudem ist es in beiden Skripten nötig.
  - Etwas schöner, aber immer noch zwei mal nötig: 
  Dem Cron Command vorangestellt[^cronEnv]:  
  `5 4 * * * source $HOME/.bash_profile ; $HOME/bin/goaccess_process_log_into_db.sh`
  - BASH_ENV[^bash_env1]! Sofern die _BASH_, 
  wie bei _Shell Skripten_ und Cronjobs nicht interaktiv 
  gestartet wird, wird versucht auf diese Variable _BASH_ENV_ zuzugreifen 
  und die angegebene Datei (_$HOME/.bash_profile_) auszuwerten[^bash_env2].  
  Füge die folgenden zwei Zeilen vor den Cronjobs ein:
  ```
  SHELL=/bin/bash
  BASH_ENV=$HOME/.bash_profile
  ```
- Einmal das `--keep-db-file` vergessen, schon ist die mühsam angelegte Datenbank futsch.
- Der Trailing Slash bei der Angabe von `--db-path` ist wichtig, sonst gehts nicht.

* * * 

[^dbm]: [DBM (Datenbank)](https://de.wikipedia.org/wiki/DBM_(Datenbank))
[^tcb]: [Tokyo Cabinet DBM](https://fallabs.com/tokyocabinet/)
[^persistenz1]: [persistieren](https://de.wiktionary.org/wiki/persistieren)
[^persistenz2]: [Persistenz (Informatik)](https://de.wikipedia.org/wiki/Persistenz_(Informatik))
[^u7logs]: [uberspace 7: Web server logs](https://manual.uberspace.de/web-logs.html)
[^logrotate]: [logrotate(8) - Linux man page](https://linux.die.net/man/8/logrotate)
[^htaccess]: [Password protecting a directory and all of it's subfolders using .htaccess](https://stackoverflow.com/questions/5229656/password-protecting-a-directory-and-all-of-its-subfolders-using-htaccess)
[^cronEnv]: [How can I run a cron command with existing environmental variables? : unix.stackexchange.com](https://unix.stackexchange.com/questions/27289/how-can-i-run-a-cron-command-with-existing-environmental-variables)
[^bash_env1]: [Crontab, environment and BASH_ENV](http://heikok.blogspot.com/2016/09/crontab-environment-and-bashenv.html)
[^bash_env2]: [BASH_ENV and cron jobs](https://unix.stackexchange.com/questions/130941/bash-env-and-cron-jobs)

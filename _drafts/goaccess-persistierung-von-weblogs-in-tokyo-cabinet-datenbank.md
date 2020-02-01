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
title: "GoAccess: Inkrementelle Persistierung von Access Logs in Tokyo Cabinet Datenbank"
---
Tokyo Cabinet On-Disk B+ Tree[^tcb] DBM[^dbm]
<!--break-->
## Vorbereitungen

### Anknipsen der AccessLogs auf U7

Wenn du, wie ich auf *Uberspace 7* unterwegs bist, 
dann musst du die AccessLogs erst aktivieren[^u7logs], 
da per Default gar keine *Webserver Logs* geschrieben werden,
was aus Gründen der Datensparsamkeit schon ziemlich cool ist.

```
uberspace web log access enable
```

### Zukünftige Heimat der Datenbank

Da GoAccess seine Datenbank per Default nach `/tmp` schreibt, 
wo a), die Dateien flüchtig sind 
und b), von jedem lesbar sind, 
legen wir in unserem `$HOME` ein Verzeichnis dafür an.

```
mkdir $HOME/goaccess.db
```

### Zeitpunkt für die Cronjobs bestimmen

Wann erfolgt die Rotation[^logrotate] der Webserver Logfiles?

```
ls -l logs/webserver/
```

Am Beispiel eines U7 Accounts werden 7 _Web Access Logs_ vorgehalten. 
Hier wird um 03:54 das aktuelle Logfile _access.log_ nach _access_log.1_ rotiert.


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

## Der Einzeiler zum prozessieren des AccessLogs

Dieser Einzeiler, 
den wir als _$USER/bin/goaccess_process_log_into_db.sh_ speichern
und via `chmod u+x $USER/bin/goaccess_process_log_into_db.sh` ausführbar machen
bereitet das obige *AccessLogFile* auf
und persistiert diese in der Datenbank:

```
#!/bin/bash

goaccess \
  --log-file=$HOME/logs/webserver/access_log.1 \
  --log-format=COMBINED \
  --process-and-exit --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ 
```

Access Logs werden auf Uberspace anonymisiert, 
auf u7 werden die ersten 16 Bits einer _IPv4 Addresse_ 
und die ersten 32 Bits einer _IPv6 Adresse_ protokolliert.

Wäre das nicht der Fall, 
dann solltest du zusätzlich noch die Option `--anonymize-ip` verwenden.

## Der Einzeiler zur Generierung des HTML-Reports aus der Datenbank

Dieser Einzeiler,
den wir als _$USER/bin/goaccess_db_to_html.sh_ speichern 
und via `chmod u+x $USER/bin/goaccess_db_to_html.sh` ausführbar machen
generiert einen *HTML Report* aus der Datenbank. 

```
#!/bin/bash

goaccess \
  --log-format=COMBINED \
  --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ \
  --output  ~/html/index.html
```
Dein HTML-Report ist nun über <https://deinusername.uber.space> erreichbar.

Gegebenenfall magst du das Verzeichnis _~/html_ mit einen Passwortschutz[^htaccess] versehen
um es gegen fremde Blicke zu schützen.

### Verwendete Optionen mit Datenbank Bezug

- `--process-and-exit`, Ideal für Cronjobs: Parsen und Ende, keine Ausgabe via ncurses oder in eine Datei.
- `--keep-db-file`, persistiere die geparsten Daten in der Datenbank.
- `--load-from-disk`, lade die vormals persistierten Daten um neue Daten anzuhängen.
- `--db-path=$HOME/goaccess.db/`, der Ort an dem die _On-Disk-Datenbank_ leben und wachsen soll. 

#### Tokyo Cabinet Options in goaccess.conf

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
und einen darauf basierend aktuellen _HTML Report_.

```
5 4 * * * $USER/bin/goaccess_process_log_into_db.sh
10 4 * * * $USER/goaccess_db_to_html.sh
```
# Fallstricke

Pitfalls aka _Lessons learned_ oder Erfahrungen, die ihr nicht unbedingt auch machen müsst: 
- Bei einer mehrfachen Ausführung auf das gleiche Logfile merkt sich GoAccess nicht, 
das die Datei schonmal geparst wurde. Ergo: Die Daten für den jeweiligen Zeitraum sind n mal aufgenommen worden.
- Auf U6 kennt GoAccess nicht mehr den Pfad zur selbstinstallierten _libtokyocabinet.so.9_ Bibliothek, 
 wenn via Cron aufgerufen: 
 `goaccess: error while loading shared libraries: libtokyocabinet.so.9: cannot open shared object file: No such file or directory`.
 Ein `source $HOME/.bash_profile` im Skript zur Persistierung 
 macht alle nötigen Umgebungsvariablen verfügbar und schafft Abhilfe.
- Einmal das `--keep-db-file` vergessen, schon ist die mühsam angelegt Datenbank futsch.
- Der Trailing Slash bei der Angabe von `--db-path` ist wichtig, sonst gehts nicht.


```  
checking for tchdbnew in -ltokyocabinet... no
configure: error: *** Missing development libraries for Tokyo Cabinet Database
```  
  
```  
toast add https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
```  

```  
toast find tokyocabinet
```  
```  
wget -O- https://fallabs.com/tokyocabinet/
--2020-01-07 23:05:25--  https://fallabs.com/tokyocabinet/
Auflösen des Hostnamen »fallabs.com«.... 49.212.133.108
Verbindungsaufbau zu fallabs.com|49.212.133.108|:443... verbunden.
HTTP Anforderung gesendet, warte auf Antwort... 200 OK
Länge: 6819 (6,7K) [text/html]
In »»STDOUT«« speichern.

100%[===================================================================================================================>] 6.819       --.-K/s   in 0s      

2020-01-07 23:05:26 (127 MB/s) - auf die Standardausgabe geschrieben [6819/6819]


tokyocabinet
  version 1.4.48: found
    urls:
       https://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz
```  


```
toast arm tokyocabinet
```


```
echo $LD_LIBRARY_PATH 
/home/fl3a/.toast/armed/lib
```

 `--with-openssl` fehlt, neu kompilieren
```
make
./configure --enable-utf8 --enable-geoip=legacy --enable-tcb=btree  --prefix=$HOME
```

```
Your build configuration:

  Prefix         : /home/fl3a
  Package        : goaccess
  Version        : 1.3
  Compiler flags :  -pthread
  Linker flags   : -lnsl -ltokyocabinet -lncursesw -lGeoIP -lpthread   -lz -lbz2 -ltokyocabinet -lrt -lc
  Dynamic buffer : no
  Geolocation    : GeoIP Legacy
  Storage method : On-disk B+ Tree Database (Tokyo Cabinet)
  TLS/SSL        : no
  Bugs           : goaccess@prosoftcorp.com
```
* * * 


[^tcb]: [Tokyo Cabinet DBM] (https://fallabs.com/tokyocabinet/)
[^dbm]: [DBM \(Datenbank\)](https://de.wikipedia.org/wiki/DBM_(Datenbank))
[^u7logs]: [uberspace 7: Web server logs](https://manual.uberspace.de/web-logs.html)
[^logrotate]: [logrotate(8) - Linux man page](https://linux.die.net/man/8/logrotate)
[^htaccess]: [Password protecting a directory and all of it's subfolders using .htaccess](https://stackoverflow.com/questions/5229656/password-protecting-a-directory-and-all-of-its-subfolders-using-htaccess)

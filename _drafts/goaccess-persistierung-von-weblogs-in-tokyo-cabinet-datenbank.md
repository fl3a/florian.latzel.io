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
title: "GoAccess: Inkrementelle Persistierung von WebLogs in Tokyo Cabinet Datenbank"
---

<!--break-->
## Vorbereitungen

### Anknipsen der AccessLogs auf U7

Wenn du, wie ich auf *Uberspace 7* unterwegs bist, 
dann musst du die AccessLogs erst aktivieren[^u7logs], 
da per Default gar keine *Webserver Logs* geschrieben werden.
Diese müssen erst aktiviert werden. 

Zur Aktivierung der AccessLogs:

```
uberspace web log access enable
```

### Zukünftige Heimat der Datenbank

Da GoAccess seine Datenbank per Default nach `/tmp` schreibt, 
wo a, die Dateien flüchtig sind 
und b, rein theoretisch von jedem lesbar sind, 
legen wir in unserm `$HOME` ein Verzeichnis dafür an.

```
mkdir $HOME/goaccess.db
```

### Zeitpunkt für die Cronjobs bestimmen

Wann erfolgt die Rotation der Webserver Logfiles?

```
ls -l logs/webserver/

```

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

Ein guter Zeitpunkt wäre gegen kurz nach vier um via Cronjob den gestrigen Tag in der Dastenbank zu pesistieren.

## Der Einzeiler zum prozessieren des AccessLogs

Dieser Einzeiler bereitet die das gestrige *AccessLogFile* auf
und persistiert es in der Datenbank:

```
#!/bin/bash
goaccess \
  --log-file=$HOME/logs/webserver/access_log.1 \
  --log-format=COMBINED \
  --process-and-exit --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ 
```  

`LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/fl3a/.toast/armed/lib`

## Der Einzeiler zur Generierung des HTML-Reports aus der Datenbank

Dieser Einzeiler generiert einen *HTML Report* aus der Datenbank. 

```
#!/bin/bash
goaccess \
  --log-format=COMBINED \
  --agent-list \
  --keep-db-file --load-from-disk --db-path=$HOME/goaccess.db/ 
  --output  ~/html/index.html
```

### Verwendete Optionen mit Datenbank Bezug

- `--process-and-exit` 
- `--keep-db-file` 
- `--load-from-disk`
- `--db-path=$HOME/goaccess.db/`

#### Tokyo Cabinet Options in goaccess.conf

```
keep-db-files true
load-from-disk false
db-path /tmp/
```



# Die Cronjobs anlegen

```
5 4 * * * goaccessParseYesterdaysLog
10 4 * * * goaccess2html
```

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
[^u7logs]: https://manual.uberspace.de/web-logs.html

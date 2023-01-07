---
title: Neue Option für drush sql-dump
layout: post
last_modified_at: 2022-09-27
tags:
- drush
- Drupal
- Linux
- '<?php ?>'
- Datenbank
- SQL
- Datensicherung
- cron
---
Die Drush-Erweiterung [drush_sql_dump_hold](https://www.drupal.org/project/drush_sql_dump_hold) 
erweitert das Drush-Kommando sql-dump, um eine weitere Option erweitert: hold.

Diese Option wurde für die häufige, wenn nicht sogar periodische Ausführung von `drush sql-dump`
geschrieben und sorgt dafür, dass im via Option result-file (Mandatory) spezifizierten Verzeichnis,
nur die durch *hold Option* angegebene Anzahl von SQL-Dumps aufbewahrt wird.<!--break-->

Hier das Beispiel einer manuellen Ausführung über die Shell innerhalb einer Drupal-Instanz:

- Aus der Angabe in der Option result-file wird versucht, den Pfad zu extrahieren, 
ansonsten wird das aktuelle Verzeichnis genommen.
- Durch den Befehl date bekommt der Dump seinen eindeutigen Namen, 
welcher sich aus JahrMonatTag-StundeMinuteSekunde + Erweiterung sql zusammensetzt und somit sortierbar ist.
- Die Validierung dieser Option wird durch das sql-dump Kommando gewährleistet
- Zu guter letzt sorgt die Option `--hold=30` dafür, dass die die neusten 30 SQL-Dumps behalten werden

```
drush  sql-dump --result-file=/path/to/dumps/`date +%Y%M%d-%H%m%S`.sql --hold=30
```

Dieser Aufruf erzeugt folgende Ausgabe, bei z.B. 33 Dumps und einem hold-Wert von 30:

```
Database dump saved to /path/to/dumps/20121109-113000.sql                                                           [success]
Do you really want to purge the following dumps:
/path/to/dumps/20111213-202504.sql
/path/to/dumps/20111214-202504.sql
/path/to/dumps/20111214-202504.sql
/path/to/dumps/20111216-202504.sql (y/n): 
```

Beispielhafte Drush-Alias-Konfiguration für drush sql-dump in Kombination mit hold-Option.

```
<?php
$aliases['mysite'] = array(
  'uri' => 'default',
  'root' =>  '/path/to/drupal'),
  'command-specific' => array (
    'sql-dump' => array(
      'result-file' => TRUE,
      'result-file' => '/path/to/dump-dir/@DATABASE_@DATE.sql',
      'gzip' => TRUE,
      'hold' => 30,
      'yes' => TRUE,
    ),
  ),
);
```

Ein Cronjob für die periodische Ausführung von drush sql-dump einrichten.

```
crontab -e
```

```
# m h  dom mon dow   command
45  4  *   *   *     /path/to/drush @mysite sql-dump
```

Mehr unter

- [drush_sql_dump_hold](https://www.drupal.org/project/drush_sql_dump_hold)
- [example.aliases.drushrc.php](
https://git.drupalcode.org/project/drush_sql_dump_hold/-/blob/master/example.aliases.drushrc.php)




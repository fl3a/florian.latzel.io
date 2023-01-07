---
tags:
- ubuntu
- drush
- Debian
- Linux
- config
- "#!/bin/bash"
nid: 1618
layout: post
title: Autocompletition für Drush aktivieren
created: 1366536302
---
Ja, Drush auch kann Autocompletition, zu deutsch "Autovervollständigung"
und das anscheinenend nicht erst seit gestern, obwohl erst gestern entdeckt...

<h2>Tab-Vervollständigung</h2>
Ganz genau genommen, spricht man in diesem Fall der Autovervollständigung von einer Befehlszeilenergänzung bzw. Tab-Vervollständigung.
Es besteht auch im Drush-Kontext die Möglichkeit Drush-Befehle, globale Drush-Optionen und den spezifischen Optionen zu einem Drush-Befehlen 
durch "tabben" (dem ein- oder zweimaligen Drücken der Tabulator Taste) in der Shell zu vervollständigen.

<h2>Beispiele</h2>

Tab-Vervollständigung von globalen Drush-Optionen:

```
florian@box:/var/www/example.com/drupal$ drush @git --<tab><tab>
```

```
--alias-path           --backend  
--backup-location      --cache-class-<bin> 
--cache-default-class  --choice 
--command-specific     --complete-debug 
--config               --confirm-rollback 
[...]
```

Tab-Vervollständigung von Drush-Befehlen, die mit ```sql-``` beginnen:

```
florian@box:/var/www/example.com/drupal$ drush @git sql-<tab><tab>
sql-cli   sql-conf   sql-connect    sql-create sql-drop
sql-dump  sql-query  sql-sanitize   sql-sync
```

Vervollständigung der Optionen, die mit dem Befehl ```sql-dump``` nutzbar sind:
```
florian@box:/var/www/example.com/drupal$ drush @git sql-dump --<tab><tab>
--create-db    --data-only   --gzip    --result-file   --structure-tables-key   
--tables-list   --database   --db-url  --ordered-dump  --skip-tables-key        
--tables-key 
```
<!--break-->
<h2>Einrichtung</h2>

In der ersten ebene des Drush Verzeichnisses befindet sich die Datei ```drush.complete.sh```,
diese muss in meinem Fall von meiner benutzten <em>Shell</em>, der <em>Bash</em> ausgewertet werden.

Dazu inkludieren wir global, also für alle User verwendbar unter Debian oder Ubuntu diese Datei im Verzeichnis ```/etc/bash_completion.d``` durch einen symbolischen Link:

```
cd /etc/bash_completion.d
sudo ln -s /path/to/drush/drush.complete.sh
```

Um die Wirkung zu testen muss ein neue Shell gestartet werden damit die Konfigurations-Dateien und -Verzeichnisse erneut augewertet werden:
```
bash --login
```

Auf noch effizienteres Arbeiten mit Drush!

<h2>Siehe auch</h2>
<ul>
 <li><a href="http://de.wikipedia.org/wiki/Autovervollst%C3%A4ndigung">Autovervollständigung</a></li>
 <li><a href="http://de.wikipedia.org/wiki/Befehlszeilenerg%C3%A4nzung">Befehlszeilenergänzung</a></li>
 <li><a href="http://drupalcode.org/project/drush.git/history/HEAD:/drush.complete.sh">Git history: drush.complete.sh </a></li>
 <li><a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=705870">Debian drush/5.8.1(unstable), #705870</a></li>
 <li><a href="/node/1608">Drupal-Projekte in Git</a></li>
</ul>

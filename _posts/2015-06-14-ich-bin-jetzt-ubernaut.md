---
title: Ich bin jetzt Ubernaut
tags:
- uberspace
- howto
- netzaffe
- Linux
- ssh
- hosting
- Drupal
- drush
- <?php ?>
layout: post
last_modified_at: 2019-04-04
---
Nach fast einer Dekade mit eigenen Linux-Root-Servern, bin ich mit meinen Domains nach uberspace[^uberspace] umgezogen 
und überlasse das Root-Sein jetzt anderen und zwar Jonas Pasche[^pasche] und seinem Team.

Ich habe noch Zugriff auf eine Shell und jede Menge Software zu Verfügung, 
so dass ich auch nicht wirklich was vermisse (Bis vielleicht manchmal die Allmacht[^sudo]... xD).

Uberspace? Uberspace beschreibt sich auf seiner Seite selbst so:

> Uberspace.de ist eine Plattform von Technikern für Techniker und alle, die es werden wollen. 
> Wir machen Hosting für Kommandozeilenliebhaber, Datenschützer, Kontrollebehalter, 
> Unixfreunde, Selbermacher, Waszusagenhaber. 
> Und wenn es mal klemmt, stehen dir erfahrene Linux-Admins zur Seite.

Dem ist meiner Meinung nach eigentlich nur noch das flexible Preismodell[^preis] hinzuzufügen,
bei dem Du den Preis selbst wählen und anpassen kannst.

Hier beschreibe ich, wie meine Drupal6-Site netzaffe.de ein neues Zuhause bezieht 
(lässt sich wahrscheinlich ohne viel Anpassung auch auf Drupal 7 anwenden)
und Mail- und Webserver für die gleichnamige Domain aufgeschaltet werden.<!--break-->

## Vorbereitungen

Die Dateien habe ich bereits via *scp* in mein neues Zuhause übertragen...

- Entpacken des netzaffen, einer Drupal 6 Seite nach `/var/www/virtual/fl3a`
- Das entstandene Verzeichnis nach *netzaffe.de*, der späteren Domain umbenennen, 
  also `/var/www/virtual/fl3a/netzaffe.de`
- den Symlink html umbiegen: löschen `unlink html`, neu setzen: `ln -s netzaffe.de html`
- DB-Credential in *settings.php* setzen, der Datenbank-User entspricht deinem Username, 
  das Passwort ist in `~/.my.cnf` hinterlegt.
- Den MySQL-Dump einlesen: `gunzip -c /pfad/zum/dump.sql.gz | mysql` 

## PHP Anpassungen

Da Drupal in seinem Status-Bericht den *Unicode library Error*,

```
Multibyte string input conversion in PHP is active and must be disabled. 
Check the php.ini mbstring.http_input setting. 
Please refer to the PHP mbstring documentation for more information.
``` 
anmeckert, brauchen wir eine eigene php.ini[^php] in der wir unsere Anpassungen vornehmen können.

Die legen wir wie folgt an:
```
test -f ~/etc/php.ini || cp -a /package/host/localhost/php-$PHPVERSION/lib/php.ini ~/etc/
```

In *~/etc/php.ini*:
```
mbstring.http_input = pass ;
mbstring.http_output = pass ;
```

Mit `killall php-cgi` werden die Änderungen wirksam.

## error_logs

Wir möchten auch an die Logs kommen, in dem der Webserver Fehler, wie von z.B. PHP-Scripts protokoliert.
Das musste früher via Mail angefragt werden, geht jetzt auch via Skript:
```
uberspace-configure-webserver enable error_log
```

## Drush auf uberspace installieren

Nichts geht ohne Drush!

Installation von composer
```
curl -sS https://getcomposer.org/installer | php
mv composer.phar ~/bin/composer
```

Installation von Drush via Composer.
```
composer global require drush/drush:6.*
```

Zum Schluss das das bestehende PATH-Statement 
```
export PATH="$HOME/.composer/vendor/bin:$PATH"
```
Statement in *.bash_profile* erweitern
und die Datei neu mit `source ~/.bash_profile` einlesen.

Test, ein `drush --version` sollte jetzt eine Versionsnummer statt einem Fehler bringen.

## Drush Cronjob einrichten

Den Befehl *crontab* mit e-Option aufrufen und es öffnet sich der Editor vim...

```
PATH=/package/host/localhost/php-5.6/bin:/bin:/usr/bin
42 4 * * *  ~/.composer/vendor/bin/drush -r ~/html cron 
```

wenns geht, also wenn ihr morgen Post von uberspace mit der Ausgabe eures Jobs bekommt 
dann wollt ihr vielleicht die Umleitung nach */dev/null* dazunehmen:

```
42 4 * * *  ~/.composer/vendor/bin/drush -r ~/html cron &> /dev/null
```

## FollowSymLinks: Sie haben Post

Wahrscheinlich hast Du auch ein oder meherer Mails bekommen:

```
[warning] Deine »/var/www/virtual/USER/netzaffe.de/files/.htaccess« beinhaltet eine nicht gültige Option: FollowSymLinks
```

Von der Datei .htaccess in der Drupal-Root und ggf. auch tiefer verschachtet 
wurde ein Backup angelegt und die obige Direktive 
durch ein Skript durch `Options +SymLinksIfOwnerMatch`[^sym] ersetzt.

## 500er Internal Server Error

Oh, WSOD, WTF?!

Nochmal in Drupals .htaccess und bei `RewriteBase /`[^rewritebase] den Zeilenkommentar entfernen. 


## Mail und Web aufschalten

Mit `uberspace-add-domain`[^domain] kannst Du deine Domains mit Uberspace, 
sprich Web und Mail verbinden. 

Mit der Option `-w` trägst Du Deine hinter der *d-Option* gefolgten Domain in die Webserver-, 
mit der Option `-m` in die Mailsserver-Konfiguration ein. 

Die Option `-e` dient zur Zuordnung eines Namensraumes[^mail] für eine Domain, hier *netzaffe*.
Das macht bei mehreren Domains pro Account Sinn.

```
uberspace-add-domain -d netzaffe.de -w -m -e netzaffe 
```

Hier die Ausgabe für den Befehl:
```
The webserver's configuration is adapted; it will get active within at most 5 minutes.
Now you can use the following records for your dns:
  A -> 185.26.156.35
  AAAA -> 2a00:d0c0:200:0:b9:1a:9c23:17a
The mailserver's configuration is now adapted; it is now active.
Now you can use the following record for your dns:
  MX -> bellatrix.uberspace.de

If you want to use our automx service, you'll also need:
  A autoconfig.netzaffe.de -> 185.26.156.35
  AAAA autoconfig.netzaffe.de -> 2a00:d0c0:200:0:b9:1a:9c23:17a
  A autodiscover.netzaffe.de -> 185.26.156.35
  AAAA autodiscover.netzaffe.de -> 2a00:d0c0:200:0:b9:1a:9c23:17
```

Anlegen des Mailaccounts[^mail2] *floh im Namensraum netzaffe*, also für die EMail-Adresse *floh@netzaffe.de*.
```
vadduser netzaffe-floh 
```

Last but not least: *A und MX Eintrag* beim Provider ändern.

* * *
[^uberspace]: [Uberspace](https://uberspace.de)
[^pasche]: [Jonas Pasche](https://jonaspasche.com/)
[^sudo]: [sudo](https://xkcd.com/149/)
[^preis]: [Das Uberspace Preismodell](https://uberspace.de/prices)
[^php]: [Uberspace Wiki: php](https://wiki.uberspace.de/development:php)
[^sym]: [Uberspace Wiki: FollowSymLinks](https://wiki.uberspace.de/webserver:htaccess#followsymlinks)
[^rewritebase]: [Uberspace Wiki: RewriteBase](https://wiki.uberspace.de/webserver:htaccess?s[]=rewrite#rewritebase)
[^domain]: [Uberspace Wiki: Domain verwalten](https://wiki.uberspace.de/domain:verwalten#tldr)
[^mail]: [Uberspace Wiki: Mailserver](https://wiki.uberspace.de/domain:mail)
[^mail2]: [Uberspace Wiki: E-Mail-Account anlegen](https://wiki.uberspace.de/mail:vmailmgr#e-mail-account_anlegen)

*[WSOD]: White screen of death

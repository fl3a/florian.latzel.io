---
title: Drupal 6 Multisiteumgebung mit PostgreSQL unter Debian 4
layout: post
permalink: /drupal-6-multisiteumgebung-mit-postgresql-unter-debian-4.html
date: 2008-09-30 08:36
toc: true
tags:
- Drupal 
- Multisite 
- howto 
- Open Source 
- "<?php ?>"
- PostgreSQL
# Redirect /book/export/html/520
---
Installation und Einrichtung von 
<ul>
<li>Drupal6</li>
<li>PHP5</li>
<li>PostgreSQL</li>
<li>Apache2</li>
<li>phppgadmin</li>
<li>Suchmaschinenfreundlichen URL's</li>
<li>deutscher Lokalisierung</li>
</ul>
in einer Multisiteumgebung auf einem lokalen Rechner  unter Debian 4(etch).
Verwendet wurden die Pakete PHP5 in der Version 5.2.0-8+etch11 
und apache2 in der Version 2.2.3-4+etch5, 
drupal in der Version 6.4 in deutsch von <a href="http://www.drupalcenter.de">drupalcenter.de</a> 
und PostgreSQL in der Version 8.1.11.
<!--break--> 
s="book-heading">Installation der benötigten Pakete
  <p>
Die folgenden Pakete werden ben&#246;tigt:
</p>
<ul>
<li>apache2 - Der Apache Webserver in der Version 2</li>
<li>libapache2-mod-php5 - Das Apache-Modul f&#252;r PHP5</li>
<li>php5 und php5-common - Den PHP-Interpreter</li>
<li>php5-gd - Die GD Grafikbibliothek f&#252;r PHP5</li>
<li>php5-pgsql - Das PHP-Modul f&#252;r den Zugriff auf die PostgreSQL Datenbank</li>
<li>php5-<acronym title="Command-Line Interpreter">cli</acronym> - PHP für die Kommandozeile, benötigt von <acronym title="Drupal Shell"><a href="/tags/drush.html">drush</a></acronym></li>
<li>postgresql-8.1 - Der PostgreSQL Datenbankserver</li>
<li>phppgadmin - Webbasiertes Administrationswerkzeug für PostgreSQL(ähnlich phpmyadmin für mysql)</li>
</ul>
<p>Die eigentliche Installation:</p>

```
aptitude install apache2 libapache2-mod-php5 php5 php5-common php5-pgsql php5-gd php5-cli postgresql-8.1 phppgadmin
```


## Konfiguration

### Grundlegende Konfiguration

<p>Installation und Konfiguration der von Drupal benötigten PHP-Module, die nötigen Schritte um Suchmaschinenfreundlichen URL's nutzen zu können und das Hochsetzen der memory_limit-Direktive.</p>
<p>Die folgenden Schritte sind unter der ID von root auszuführen.</p>

```su``` oder mit ```sudo <BEFEHL>```

<p>falls sudo konfiguriert ist.</p>


 
### php memory_limit hochsetzen

<p>Um einem "White-Screen" vorzubeugen wenn zu viele Drupal-Module installiert sind,<br />
setzen wir die memory_limit  in <i>/etc/php5/apache2/php.ini</i> höher.</p>

```memory_limit = 64M ; Maximum amount of memory a script may consume (16MB)```




  

### Installation der clean-urls
  <p>Um das Feature der Suchmaschinenfreundlichen URL's(clean-url's) nutzen zu k&#246;nnen, mu&#223; noch das mod_rewrite-Modul aktiviert werden. Hier werden die symbolischen Links von /etc/apache2/mods-available nach /etc/apache2/mods-enabled gesetzt f&#252;r die entsprechenden Module gesetzt:</p>

```a2enmod rewrite```

### Neustart von Apache2

 <p>Damit die voherigen Änderungen wirksam werden, starten wir Apache erneut.</p>

```/etc/init.d/apache2 force-reload```





## Testen der Installation

<p>Zum testen der Apache-Installation geben wir den <acronym title="Fully Qualified Domain Name">FQDN</acronym> oder die IP-Adrese in Browser ein<br />
und sehen ein <strong>It works!</strong></p>
<p>Um zu testen, ob php l&auml;uft und alle ben&ouml;tigten Module enth&auml;lt legen wir eine Datei mit dem Namen index.php im Ordner /var/www an.</p>

```echo -e "<php\n  phpinfo();\n?>" >  /var/www/index.php```

<p>Anschlie&szlig;end rufen Datei index.php mit der <acronym title="Uniform Resource Locator">URL</acronym> unseres Webservers über Browser auf<br />
und sehen in der Sektion apache2handler im Unterpunkt Loaded Modules, mod_rewrite und weiter unten die von Drupal ben&ouml;tigten PHP-Erweiterungen gd und pgsql.</p>

## Einrichtung der Datenbank

Damit der Benutzerwechsel funktioniert, machen wir uns zu root. ```su```

Um die folgenden Befehle auszuführen starten wir eine Shell unter der Identität von postgres

```su postgres```


Anlegen des zukünftigen Datenbankbenutzer mit den Optionen:
- -P oder --pwprompt für Passwortauthentifizierung
- -S oder --no-superuser, Default, deshalb optional
- -D oder --no-createdb
- -R oder --no-createrole, Benutzer darf keine Rollen anlegen
- -E oder --encrypted, Verschlüsselung der Passwörter in der Datenbank

```createuser -P -S -R -E datenbankbenutzer```

<p>Anlegen der Datenbank mit UTF-8 Kodierung,-E oder --encoding- für den durch -O oder --owner spezifizierten Benutzer.</p>

```createdb -E UNICODE -O datenbankbenutzer datenbankname```

Anschließend ```exit``` um die Shell von postgres zu beenden, 

```exit``` um auch die Rootshell wieder zu verlassen, damit wir die nächsten Schritte als normaler Benutzer auszuführen.

## Drupal installieren

Damit wir uns definitiv in unserem Home-Directory befinden: ```cd```

<p>Anlegen des Verzeichnisses welches später unser Drupal-Instanzen enthält,</p>

```mkdir drupal```

<p>Verzeichniswechsel nach drupal,</p>

```cd drupal```

<p>runterladen der deutschen 6er Version von <a href="http://www.drupalcenter.de">drupalcenter.de</a>,<br />
(natürlich ist 6.4 durch die momentan aktuelleste Version von Drupal zu ersetzten)</p>

```wget http://www.drupalcenter.de/files/drupal-6.4-DE.tar.gz```

<p>entpacken.</p>

```tar -xzvf drupal-6.4-DE.tar.gz```

## Die Drupal Multisite-Umgebung

<p>So soll die Multisiteumgebung später mal aussehen:</p>

```
drupal/
|-- 6.x -> drupal-6.4
|-- 6.x_modules
|-- 6.x_sites
|   |-- example.com -> example.com.localhost
|   |  |-- files
|   |  |-- modules
|   |  `-- themes
|   `-- example.com.localhost
|      |-- files
|      |-- modules
|      `-- themes
|-- 6.x_themes
`-- drupal-6.4
    |-- backup
    |-- includes
    |-- misc
    |-- modules
    |-- profiles
    |-- scripts
    `-- sites
        |-- all
        |    |-- modules -> ../../../6.x_modules
        |    |-- themes -> ../../../6.x_themes
        |-- example.com -> ../../6.x_sites/example.com
        `-- example.com.localhost -> ../../6.x_sites/example.com.localhost
```
### Anmerkungen

<p><strike>Der Ordner <strong>6.x_backup</strong> beziehungsweise der symbolische Link <strong>backup</strong> in der<br />
Wurzel der Drupal-Installation ist <acronym title="Drupal Shell">drush</acronym>-spezifisch.</strike><br />
Seit <a href="http://drupalcode.org/project/drush.git/commit/16a4e2b3cf0420a7dce7d3ed79f6701bdd97e095">Commit 16a4e2b3cf0420a7dce7d3ed79f6701bdd97e095</a> auf Drush nicht mehr möglich:
</p>

> Force to use a location for backups outside the drupal root.

<p>Der Ordner 6.x_sites  beziehungsweise der symbolische Link sites beinhaltet die einzelnen Sites und deren Daten.</p>
<p>Seit dem Fix von <a href="http://drupal.org/node/694708">Issue #694708</a> auf drush_multi, behandle ich <em>profiles</em> analog zu <em>sites</em>.</p>

### Mulisiteumgebung vorbereiten
 
<p>Erstellung des symbolische Links auf die Wurzel der Drupal-Installation, welche später in unserem VirtualHost die DokumentRoot darstellt .</p>

```ln -s drupal-6.4-DE 6.x´´´

<p>Erstellung der Verzeichnisse <i>6.x_sites</i>, welche später unser die Subsites, Module, und Themes enthalten wird und <i>6.x_backup</i>, in welchem Sicherheitskopien von Modulen und Themes, welche durch <acronym title="Drupal Shell">drush</acronym> aktualisiert worden sind abgelegt werden.</p>

```mkdir  6.x_sites 6.x_backups```

<p>Verschieben der Ordner <i>drupal-6.4-DE/sites/all</i> und <i>drupal-6.4-DE/sites/default</i> nach <i>6.x_sites</i>.		</p>

```mv drupal-6.4-DE/sites/* 6.x_sites```
</div>
<p>Ersetzen des Verzeichnisses <i>sites</i> unterhalb von <i>drupal-6.4-DE</i> durch einen symbolischen Link mit <strong>relativer Pfadangabe</strong> welcher auf <i>6.x_sites</i> zeigt uns setzen des symbolischen Links für <i>backup</i>.</p>

```
rmdir drupal-6.4-DE/sites```
cd drupal-6.4-DE
ln -s ../6.x_sites sites
ln -s ../6.x_backup backup
cd ..
```
<p>Erstellung der Verzeichnisse <i>modules</i> und <i>themes</i>, hier sollten seit Drupal 5.x angepasste und runtergeladene Module und Themes abgelegt werden. Diese sind somit auch für die Subsites verfügbar.(Siehe auch <i>README.txt</i> in <i>sites/</i>)</p>

```mkdir 6.x_sites/all/modules 6.x_sites/all/themes```


## Eintrag in /etc/hosts
  <p>Damit unsere zukünfige Seite über einen <acronym title="Fully Qualified Domain Name">FQDN</acronym> erreichbar ist, erweitern wir die Datei /etc/hosts um die folgende Zeile:</p>

```127.0.0.1 example.com.localhost```

## Konfiguration von Apache

Einrichtung der Virtual-Hosts und Absichern der Installation.
<p>Um die Apache-Direktiven und den Virtual-Host anzulegen benötigen wir wieder erhöhte Privilegien.</p>

<code>sudo su</code> oder <code>su</code>


### Drupal und .htaccess

<p>Damit die von Drupal benutzte .htaccess funktioniert legen wir die Datei <i>/etc/apache2/conf.d/drupal.conf</i> mit folgendem Inhalt an:</p>

```
<Directory /home/foobar/drupal/>
  Options +FollowSymLinks Indexes
  AllowOverride All
  order allow,deny
  allow from all
</Directory>
```

## Drupals cron.php absichern


<p>Um Drupals <i>cron.php</i> vor unberechtigtem Zugriff zu schützen, tragen wir in <i>/etc/apache2/conf.d/drupal.conf</i> noch die folgende Passage ein:<br />
</p>

```
<Files cron.php>
Order deny,allow
Deny from all
Allow from 10.10.10.0/24
Allow from 127.0.0.1
Allow from 1.2.3.4
</Files>
```

<p>In der ersten Allow-Direktive wird per <acronym title="Classless Inter-Domain Routing">CIDR</acronym>-Notation der Zugriff vom kompletten <acronym title="Virtual Private Network">VPN</acronym> gewährt.<br />
In der zweiten wird der Zugriff von localhost aus erlaubt.<br />
Entscheidend ist aber, daß die IP-Adresse des Server(die 3.te Direktive) gelistet ist, von hier wird <i>cron.php</i> per Cronjob aufgerufen,</p>
<p>Damit unsere <i>/etc/apache2/conf.d/drupal.conf</i> wirksam wird, muß der Webserver auch hier die Konfiguration neu einlesen:<br />
</p>

```/etc/init.d/apache2 reload```

### Drupals CHANGELOG.txt absichern

*Security by obscurity*: <p>Mein erster Gedanke war, die <i>CHANGLOG.txt</i> mit in Direktive für die <a href="/node/689">Absicherung von Drupals <i>cron.php</i></a> zu nehmen um diese Datei ebenso vor fremden Blicken zu schützen...</p>

```
<Files cron.php,CHANGELOG.txt>
Order deny,allow
Deny from all
# Zugriff aus dem VPN erlauben
Allow from 10.10.10.0/24
Allow from 127.0.0.1
Allow from 81.169.175.14
</Files>
```
<p>Aber nach überprüfen der Konfiguration mit</p>

```sudo apache2ctl configtest```

<p>kam der folgende Fehler:</p>

> Syntax error on line 6 of /etc/apache2/conf.d/drupal.conf:
> Multiple &lt;Files&gt; arguments not (yet) supported.

<p>Zu praktisch gedacht, doch ein eigenes Statement:</p>

```
<Files CHANGELOG.txt>
Order deny,allow
Deny from all
</Files>
```

<p>Nachdem der Configtest durchgelaufen ist muss der Webserver neu gestartet werden. </p>

```/etc/init.d/apache2 restart```

### Virtual Host einrichten

<p>Anlegen der Datei <i>/etc/apache2/sites-available/example.com.localhost.conf</i>,<br /> auch hier ist <i>foobar</i> wieder durch den eigenen Benutzernamen zu ersetzten,  DocumentRoot zeigt auf den symbolischen Link, welcher wiederum auf die Wurzel der Drupal-Installation zeigt.</p>

```
<VirtualHost *>
ServerName example.com.localhost
ServerAlias www.example.com.localhost
ServerAdmin foobar@example.com.localhost
DocumentRoot /home/foobar/drupal/6.x
ErrorLog /var/log/apache2/example.com.localhost-error.log
CustomLog /var/log/apache2/example.com.localhost-access.log combined
</VirtualHost>
```
<p>Analog zur Aktivierung des rewrite-Moduls, werden auch hier wieder symbolische Links gesetzt und zwar von <i>/etc/apache2/sites-available</i> nach <i>/etc/apache2/sites-enabled</i>.</p>

```a2ensite example.com.localhost.conf```


<p>Nach den letzten Schritten müssen wir den den <a href="http://netzaffe.de/2008/09/30/drupal-6-multisiteumgebung-mit-postgresql-unter-debian-4/konfiguration/neustart-von-apach">Webserver neu starten</a>, damit er seine Konfiguration erneut einließt und die angelegten Direktiven wirksam werden.</p>

## Einrichtung einer Site

Um als wieder Benutzer weiterzumachen: ```exit```

<p>Wechsel in das 6.x_sites Verzeichnis:</p>

```
cd
cd drupal/6.x_sites/
```

<p>Anlegen eines Verzeichnisses für die erste Site,</p>

```mkdir -p example.com.localhost/files```

<p>Das Verzeichnis <i>files</i> für den Webserver schreibbar machen:</p>

```chmod 775 example.com.localhost/files```

An dieser Stelle explizit kein <i>su -</i> um auch in diesem Verzeichnis zu bleiben. ```su```

```
chgrp www-data example.com.localhost/files
exit
```

<p>Gesetz dem Fall, daß example.com irgendwann in den Produktiveinsatz<br />
geht, geben wir diesen bei der Installationsroutine von Drupal den zukünftigen Speicherort für unsere Dateien an(<i>sites/example.com/files</i>)<br />
und setzen hierfür noch einen Symlink</p>

```ln -s example.com.localhost example.com```

<p>Für Module und Themes, die <strong>nur</strong> für unsere Subsite verfügbar sein sollen legen wir noch die folgenden 2 Verzeichnisse an:</p>

```mkdir example.com.localhost/themes example.com.localhost/modules```
</div>
<p>Jetzt brauchen wir noch die settings.php, welche die Einstellungen für unser Site enthalten wird. </p>

```cp default/default.settings.php example.com.localhost/settings.php```
</div>
<p>Jetzt können wir mit unsere Browser unter example.com.localhost aufrufen und kommen zur Installationsroutine von Drupal.</p>



## Updates der Multisite-Umgebung

### Drupal Update in 8 Schritten

  <p>Bei einem <a href="/drupal-6-multisiteumgebung-mit-postgresql-unter-debian-4/die-drupal-multisite-umgebung.html">Drupal Setup</a> wie <a href="/drupal-6-multisiteumgebung-mit-postgresql-unter-debian-4/die-drupal-multisite-umgebung.html">hier</a> beschrieben, sind nur 8 Schritte für ein Update innerhalb eines Drupal-Zweiges nötig.
</p>
<p>Hier wird exemplarisch das Update von Drupal-6.9 auf Drupal-6.10, welches am 27. Februar durchgeführt wurde beschrieben.</p>
<p>
Es wird empfohlen die zu aktualisierende Seite in den  Wartungsarbeiten-Modus zu versetzen und die Dateien sowie Datenbank im Vorfeld sichern.</p>

##### 1) Runterloaden der neuen Drupal-Version

<p>Download der neuen Drupal-Version in das Verzeichnis in dem sich die auch die alte Drupal-Version befindet.</p>

```wget <a href="http://ftp.osuosl.org/pub/drupal/files/projects/drupal-6.10.tar.gz```

##### 2) Entpacken des Drupal-Tarballs

```tar xfz drupal-6.10.tar.gz```

##### 3) sites Ordner löschen

```
cd drupal-6.10
rm -r sites
```

##### 4) Symlink auf 6.x_sites Ordner mit relativem Pfad

```
ln -s ../6.x_sites sites
```

```
ls -l
```
```
lrwxrwxrwx 1 florian server  12 2009-02-27 10:13 sites -> ../6.x_sites
```

##### 5) Symlink auf 6.x_backups Ordner mit relativem Pfad

```
ln -s ../6.x_backup backups
```
```
ls -l
```
```
rwxrwxrwx 1 florian server  13 2009-02-27 10:19 backups -> ../6.x_backup
```


##### 6) Symlink auf alte Drupal-Version entfernen

```
cd ..
unlink 6.x
```

##### 7) Symlink auf die neue Drupal-Version

```
ln -s drupal-6.10 6.x
```


```
ls -l
```
```
lrwxrwxrwx 1 florian server   11 2009-02-27 10:22 6.x -> drupal-6.10
```
##### 8) update.php als User 1 aufrufen

<p>Falls aktiviert, den Maintanance-Modus abschalten und Voila!</p>

 
### drush_multi: Drupal Multisite Updates mit nur einem Befehl

<p><a href="https://www.drupal.org/project/drush_multi">Drush Multi</a> ist eine Erweiterung für die <a href="/tags/drush.html">Drupal Shell aka drush</a>. Die eigentliche Kernkomponente, welche aus einem Shellskript hervorgegangen ist behandelt Drupal-Updates von Drupal-Multisite-Umgebungen.</p>

#### drush multi-drupalupdate

<p>Aktualisiert die Installation falls es (Minor-)Updates auf den Drupal-Core gibt.</p>
<p>Einfaches <em>multi-drupalupdate</em>...</p>
<p><span class="geshifilter"><code class="text geshifilter-text">drush -r /path/to/drupal multi-drupalupdate </code></span></p>
<p><em>multi-drupalupdate</em> mit ein paar zusätzlichen Optionen...</p>
<p><span class="geshifilter"><code class="text geshifilter-text">drush -r /path/to/drupal multi-drupalupdate --sql-dump --comment='Vor Aktualisierung auf Drupal 7.12' --updatedb </code></span></p>
<p>Führt ein <em>multi-drupalupdate</em> auf <em>/path/to/drupal</em> aus</p>
<ol>
<li>Sichert die Datenbanken aller Sites, mit einem optionalem Kommentar im Dateinamen, über --sql-dump und --comment Option</li>
<li>Versetzt alle Sites in den Wartungsmodus, über --updatedb Option</li>
<li>Download des Drupal-Cores</li>
<li>Ersetzung der Drupal-Verzeichnisse und Dateien durch symbolische Links, die in der aktuellen Installation gefunden wurden, wie z.B. sites, profiles, .htaccess, etc</li>
<li>Umbiegen des symbolischen Links auf die neue Drupal-Root</li>
<li>Ausführung von ggf. anstehenden Drupal-Datenbank-Updates</li>
<li>Beenden des Wartungsmodus</li>
</ol>
#### Besonderheiten
<ul>
<li>Die hier beschriebene <a href="/drupal-6-multisiteumgebung-mit-postgresql-unter-debian-4/die-drupal-multisite-umgebung.html">Struktur der Drupal-Multisite-Umgebung</a> muss berücksichtigt werden und Drupal-Root muß ein symbolischer Link sein</li>
<li><a href="http://is-loesungen.de/docu/drush_multi/group__symlinks.html">Automatische Erkennung und Beibehaltung von symbolischen Links</a> über relativen Pfad, analog zu <em>sites</em> und <em>profiles</em></li>
<li>Drush Multi benötigt drush v. 4</li>
</ul>
#### Weitere Befehle in drush_multi
<p>Während der ArByte an dem eigentlichen Kernstück <em>multi-drupalupdate</em> sind noch andere Dinge entstanden...</p>
- drush multi-status
  - Ein erweiterter drush core Status
- drush multi-site
  - Legt eine Site innerhalb der Multisite-Installation an
- drush multi-create
  - Erzeugt eine Drupal-Multisite-Installation nach dem beschriebenem Schema, unterstützt zudem die Benutzung von <a href="http://drupal.org/project/drush_make">drush_make</a> makefiles
- drush multi-exec
  - <strike>Führt ein Kommando auf alle Site innerhalb einer Installation aus. (batch mode).</strike> Diese Funktionalität ist mittlerweile in Drush (<span class="geshifilter"><code class="text geshifilter-text">drush -r /path/to/drupal/ @sites COMMAND</code></span>), @see <a href="http://drupal.org/node/652778">#652778: Similar functionality is in drush core 3.x</a>
- drush multi-sql-dump
  - Ein erweiterter sql dump, welcher z.B. die Datenbank auch tabelleweise sichert, bzip2-Kompremierung ermöglicht (Recheninternsiver aber besser Kompremierung).
- drush multi-nagios
  - <strike>Zur Benutzung als Nagios/Icinga plugin um Drupal-Sites und Drupal-Installations zu überwachen</strike>  
  Nach <a href="http://drupal.org/project/drush_nagios">drush_nagios </a> ausgelagert

#### Dokumentation
<ul>
<li>Jedes Kommando besitzt eine Hilfe, z.B. <span class="geshifilter"><code class="text geshifilter-text">drush help multi-drupalupdate</code></span></li>
<li>zudem gibt es eine <a href="http://is-loesungen.de/docu/drush_multi/index.html" rel="nofollow">drush_multi Doxygen Dokumentation</a>..</li>
<li><a href="http://de.slideshare.net/fl3a/ddd-drush-multi">Slides zu drush_multi</a> von den drupaldevDays 2010 in München.</li>
<li><a href="http://de.slideshare.net/fl3a/drush-und-multisite-drushmulti?related=1">Slides zu "Drush und Multisite: drush_multi"</a>, DrupalCamp Vienna 2009</li>
</ul>
  
## Drush in einer Multisite-Umgebung

  <p>Um <acronym title="Drupal Shell">drush</acronym> in einer Multisiteumgebung zu arbeiten, haben sich folgende Mechanismen als nützlich erwiesen:</p>

### Drush-Alias für Multisite

<p>An dieser Stelle werden Aliase auf die jeweiligen drush-Version(Symlink) und der auf <i>-r</i> bzw. <i>--root</i> folgenden Wurzel der Drupal-Installation gesetzt.</p>
<p>Alternativ zu Aliasen auf die Drupal-Wurzel, kann dies auch über<br />
<a href="/drush-die-drupal-shell/drushrc-php.html">drushrc.php, die Konfigurationsdatei für drush</a> erfolgen.</p>
<p>
Drush ist in nach <i>/usr/local/share/</i> installiert worden und das Wrapper-Skript <i>/usr/local/share/drush/drush</i> ist ein Softlink nach <i>/usr/local/bin/drush</i>.
</p>

```
alias drush5_='/usr/local/bin/drush/drush -r /home/drupal/5.x '
alias drush6_='/usr/local/bin/drush/drush -r /home/drupal/6.x '
``` 


### Verwendung von drush in der Multisiteumgebung

<p>Der Aufruf von drush erfolgt über den angelegten Alias + die Spezifizierung der Subsite,<br />mittels <i>-l</i> oder <i>--uri=""</i>.</p>
<p>
Im folgenden Beispiel werden die Informationen über den Status der Seite aktualisiert.</p>

```drush6_ -l example.com pm-refresh```

<p>Für 5.x ist das Modul <a href="http://drupal.org/project/update_status">Update Status</a> Voraussetzung für die Aktionen <i>pm-refresh (rf)</i> und <i>pm-update (up)</i>.</p>

### sites/all/modules &amp; sites/example.com/modules

<p>Wenn <i>sites/all/modules</i> und <i>sites/example.com/modules</i> parallel existieren, installiert drush Module nach <i>sites/all/modules<i>.</i></i></p>
<p>Im Falle, das <i>sites/all/modules<i>  nicht existiert, dafür aber <i>sites/example.com/modules</i> wird <i>sites/all/modules<i> erstellt und benutzt.
</i></i></i></i></p>
<p>Um trotzdem <i>sites/example.com/modules</i> verwenden zu können existiert in <i>sites/all</i> kein <i>modules</i> Verzeichnis und <i>sites/all</i> ist schreibgeschütz.</p>
    


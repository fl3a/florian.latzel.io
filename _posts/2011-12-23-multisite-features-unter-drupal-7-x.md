---
tags:
- snippet
- Multisite
- Entwicklung
- drush
- drupal-7.x
- Drupal
- deployment
- config
nid: 1591
permalink: "/multisite-features-unter-drupal-7-x.html"
layout: post
title: Multisite-Features unter Drupal 7.x
created: 1324637559
---
<p>Rudimente für ein Drupal-Deployment mit</p>
<ul>
	<li>Lokaler Entwicklungumgebung</li>
	<li>Stage-Umgebung</li>
	<li>Live / Produktionsumgebung</li>
</ul>
<p>unter Verwendung, der in Drupal-7 neu eingeführten Multisite-Features in der Datei <strong>sites.php</strong>, <strong>Drush-Aliases</strong> und einer speziellen <strong>settings.php</strong>.</p>
<strong>sites.php -- Verzeichnis Aliase in Drupal 7.x</strong>
<p>Die in Drupal 7.x neu eingeführte Datei <code>sites.php</code> stellt erstmalig Verzeichnis-Aliase für Drupal-Multisites zur Verfügung. So ist es jetzt möglich mit verschiedenen Domains bzw. VirtualHosts ein bestimmtes Verzeichnis innerhalb von sites anzusprechen, ohne über z.B. Symbolische Links zu gehen, was in vorgigen Drupal-Versionen zur Folge haben konnte, daß Datei- oder Modulpfade beim "umbiegen" von der Dev-Site example.mydomain.de auf die Live-Site example.com divergent sind.</p>

``` 
<?php
// sites/sites.php 

// (LOCAL) DEV SITE 
$sites['example.localhost'] = 'example.com'; 

// STAGE SITES 
$sites['stage-example.mydomain.de'] = 'example.com';
$sites['stage.example.com'] = 'example.com'; 

// LIVE SITE 
$sites['example.com'] = 'example.com'; 
``` 
``` 
@see /path/to/drupal7/sites/example.sites.php 
``` 
<!--break--> 
<strong>settings.php für DEV, STAGE und LIVE</strong>
<p>Im folgenden Ausschnitt der <code>settings.php</code> werden für</p>
<ul>
	<li>DEV SITE</li>
	<li>STAGE SITE</li>
	<li>LIVE SITE</li>
</ul>
unterschiedliche Datenbanken und Vorbelegungen von Variablen definiert. 
Die verschiedenen Umgebungen sind von einem Switch auf `$_SERVER['HTTP_HOST']` eingeschlossen, 
und es werden über den Host-Header des aktuellen Requests die entsprechenden Einstellungen genommen. 
Die Verwendung des Contributed-Modules "Environment Indicator" weist optisch zusätzlich darauf hin, 
auf welcher Umgebung man sich gerade befindet, hierzu hat mich besonders Dirk Rüdigers Artikel zu Drush site-alias motiviert(s.u.). 


``` 
<?php
// sites/default/settings.php
switch ($_SERVER['HTTP_HOST']) {
  case 'stage.example.com':
  case 'stage-example.mydomain,de':

    $conf['environment_indicator_text'] = 'STAGE SITE';
    $conf['environment_indicator_color'] = 'salmon';

    $databases = array (
      'default' =>
      array (
        'default' =>
        array (
          'database' => 'stage_db',
          'username' => 'stage_db_user',
          'password' => 'stage_db_passwd',
          'host' => 'localhost',
          'port' => '',
          'driver' => 'mysql',
          'prefix' => '',
        ),
      ),
    );
    break;

  case 'example.com':

    $conf['environment_indicator_text'] = 'LIVE SITE';
    $conf['environment_indicator_color'] = 'red';

    $databases = array (
      'default' =>
      array (
        'default' =>
        array (
          'database' => 'live_db',
          'username' => 'live_db_user',
          'password' => 'live_db_passwd',
          'host' => 'localhost',
          'port' => '',
          'driver' => 'mysql',
          'prefix' => '',
        ),
      ),
    );
    break;

  default:
    $conf['environment_indicator_text'] = 'LOCAL DEV SITE';
    $conf['environment_indicator_color'] = 'green';

    $databases = array (
      'default' =>
      array (
        'default' =>
        array (
          'database' => 'local_dev',
          'username' => 'local_dev_user',
          'password' => 'local_dev_passwd',
          'host' => 'localhost',
          'port' => '',
          'driver' => 'mysql',
          'prefix' => '',
        ),
      ),
    );
}
```
```
@see /path/to/drupal7/sites/default/default.settings.php</code></p>
```
<strong>Drush-Aliases</strong>
<p>In drush V. 3. wurden Site-Aliase eingeführt, dies ermöglicht, ähnlich wie bei Aliasen auf der Shell eine kurze Schreibweise für eine längere Befehlangabe. Um explizit eine Drupal-Site und deren spezifische Einstellungen in einer Drupal-Multisite-Umgebung anzusprechen, sind die Angabe der Drupal-Wurzel (<code>--root=/path/to/drupal</code>) und der Name der Site bzw. dem Namen des Verzeichnisse in dem die jeweilige Site liegt (<code>--uri=example.com</code>) nötig. Durch das folgende Snippet lassen sich die Instanzen über die Aliase</p>
<ul>
	<li>@dev</li>
	<li>@stage</li>
	<li>@stage2</li>
	<li>@live</li>
</ul>
ansprechen und die Optionen 
`--uri=example.com` bzw. der kurzen Schreibweise `-l example.com` werden `$_SERVER['HTTP_HOST']`durch drush gesetzt. 

```
<?php
// /etc/drush/aliases.drushrc.php
$aliases['dev'] = array(
  'uri' => 'example.localhost',
  'root' => '/multi/drupal/7.x',
);

$aliases['stage'] = array(
  'uri' => 'stage-example.mydomain.de',
  'root' => '/multi/drupal/7.x',
);

$aliases['stage2'] = array(
  'parent' => '@stage',
  'uri' => 'stage.example.com',
);

$aliases['live'] = array(
  'uri' => 'example.com',
  'root' => '/multi/drupal/7.x',
);
```

Analog zum Host-Header des aktuellen Requests einer Web-Anfrage
wird in der obigen settings.php nun hierüber verzweigt.

```
@see /path/to/drush/examples/example.aliases.drushrc.php
```
<strong>Weiterführendes</strong>
<ul>
	<li><a href="http://mearra.com/blogs/sampo-turve/drupal-7-sites-php">Drupal 7 and sites.php</a></li>
	<li><a href="http://www.partmaster.de/blog/drush-site-alias-ein-sicherheitsnetz-fuer-die-drupal-website-entwicklung">Drush site-alias - ein Sicherheitsnetz für die Drupal-Website-Entwicklung</a></li>
	<li><a href="http://www.lullabot.com/articles/new-features-drush-3">New features in Drush 3</a></li>
	<li><a href="http://drupalcode.org/project/drush.git/blob/HEAD:/examples/example.aliases.drushrc.php">example.aliases.drushrc.php</a></li>
	<li><a href="http://www.drupalcoder.com/blog/drupal-7-multisite-improvement-multi-site-directory-aliasing">Drupal 7 multisite improvement : multi-site directory aliasing</a></li>
	<li><a href="http://api.drupal.org/api/drupal/sites--example.sites.php/7">example.sites.php</a></li>
	<li><a href="http://groups.drupal.org/node/47336">Development style - settings.php file and Drush</a></li>
</ul>

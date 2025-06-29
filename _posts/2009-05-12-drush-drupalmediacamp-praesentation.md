---
tags:
- Session
- Schweiz
- drush
- Drupalcamp
- php-cli
- Drupal
- "<?php ?>"
- "#!/bin/bash"
nid: 762
layout: post
title: Drush - DrupalMediaCamp Präsentation
created: 1242111888
last_modified_at: 2024-02-18
---
<p>Drush – Das Sackmesser für die Kommandozeile. Mein Vortrag über <a href="http://drupal.org/project/drush">drush</a> auf dem <a href="http://drupalmediacamp.ch">DrupalMediaCamp 2009</a> in Aarau, Schweiz. <img src="/assets/imgs/drupal-drush-drupalmediacamp-2009.jpg"> <small>Foto von <a href="http://brocke.de">Jürgen Brocke</a></small> <!--break--></p>
<p>Drush steht für Drupal Shell und ist die Schnittstelle für Drupal auf der Kommandozeile.</p>
<p>Mittlerweile ist Drush kein Modul mehr, daß heißt Drush benötigt auch nicht mehr zwangsweise eine Drupal-Installation und läuft wenn unabhängig von der Drupal-Version(5.x, 6.x, 7.x).</p>
<p>Mit Drush kann man alles machen, was aus Drupal heraus auch möglich ist.</p>
<p>Wer die Kommandozeile mag, wird Drush lieben.</p>
<h2>Themen</h2>
<ol>
	<li>whatis drush.php<br>
		Über drush</li>
	<li>man drush.php<br>
		Die drush-Hilfe</li>
	<li>define('DRUSH_BOOTSTRAP_DRUSH', 0);<br>
		Drush ohne Drupal
		<ul>
			<li>Drush-Optionen</li>
			<li>Drush-Kommandos</li>
		</ul>
	</li>
	<li>define('DRUSH_BOOTSTRAP_DRUPAL_ROOT', 1);<br>
		Drush mit einer Drupal-Installation</li>
	<li>define('DRUSH_BOOTSTRAP_DRUPAL_SITE', 2);<br>
		Drush mit einer Drupal-Site
		<ul>
			<li>Drupal-Kommandos</li>
			<li>Paketmanagement und Updates</li>
		</ul>
	</li>
	<li>define('DRUSH_BOOTSTRAP_DRUPAL_CONFIGURATION', 3);<br>
		Drush mit Zugriff auf eine settings.php
		<ul>
			<li>SQL-Kommandos</li>
		</ul>
	</li>
	<li>~/.drushrc.php<br>
		Die Konfigurtionsdatei von drush</li>
	<li>~/.drush<br>
		Eigene drush-Skripte</li>
</ol>
Zu den Slides: [drush–das-sackmesser-fuer-die-kommandozeile-drupalmediacamp-2009.pdf](
{% link /assets/pdfs/drush–das-sackmesser-fuer-die-kommandozeile-drupalmediacamp-2009.pdf %})

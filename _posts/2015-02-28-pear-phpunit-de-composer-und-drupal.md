---
tags:
- Continious Integration
- deployment
- Jenkins
- Gut zu wissen
- drush
- Drupal
- composer
- "<?php ?>"
nid: 1634
layout: post
title: pear.phpunit.de, Composer und Drupal
created: 1425132102
---
**PHUnit und PEAR**

Während der Installation von der benötigten Pakate für das PHING-Drupal-Template<fn>https://github.com/reinblau/phing-drupal-build</fn>, einer XML-Build-Datei für ein <a href="https://github.com/reinblau/phing-drupal-build"> Phing-Build-System für Drupal-Projekte</a> als zentraler Bestandteil eines PHING-Drupal-Jobs<fn>http://reload.github.io/jenkins-drupal-template/</fn> für den Continous Integration<fn>http://de.wikipedia.org/wiki/Kontinuierliche_Integration</fn> Server Jenkins<fn>http://jenkins-ci.org/</fn> lief ich in einer längere Fehlersuche. Zwei Pakete die durch pear.phpunit.de bereitgestellt werden, phpcpd<fn>https://github.com/sebastianbergmann/phpcpd</fn>, ein PHP Copy n Paste Detector und phploc<fn>https://github.com/sebastianbergmann/phploc</fn>, ein Tool für Code-Metriken sollen laut den Anforderungen<fn>http://reload.github.io/phing-drupal-template/</fn> via PEAR installiert werden. 

```
pear channel-discover pear.phpunit.de 
``` 

Aber schon die sog. "Channel discovery", vergleichbar mit einem `apt-get update` nach einer Erweiterung der Repositories schlägt fehl... 

```
Error: No version number found in <channel> tag Discovering channel pear.phpunit.de over http:// failed with message: channel-add: invalid channel.xml file 
Trying to discover channel pear.phpunit.de over https:// instead Error: No version number found in <channel> tag
Discovery of channel "pear.phpunit.de" failed (channel-add: invalid channel.xml file) </channel></channel>
```
<!--break-->

Lange Suche und Versuche, kurzer Sinn, hat doch im Dezember noch alles funktioniert?! Als letztes stiess ich dann endlich auf "End of Life for PEAR Installation Method"<fn>https://github.com/sebastianbergmann/phpunit/wiki/End-of-Life-for-PEAR-Installation-Method</fn>... ...OK, pear.phpuntit.de wurde zum Jahreswechsel 2014/2015 abgeschaltet...<a href="/tags/gut-zu-wissen.html">Gut zu wissen</a>...
<strong>Composer</strong>

Ok, was ist denn Composer?!

<blockquote>Composer is a tool for dependency management in PHP. It allows you to declare the dependent libraries your project needs and it will install them in your project for you.</blockquote>

Drush setzt mittlerweile bei der Installationsmethode auf Composer<fn>http://drush.org/en/master/install/</fn>, während früher die empfohlene Installationsmethode auch PEAR war (pear.drush.org ist aber noch erreichbar wird aber nicht mehr für die Installation auf drush.org erwähnt). Bei den 2 benötigten Pakaten für das <a href="https://github.com/reinblau/phing-drupal-build">Phing Drupal Template</a>, wird neben PHAR, die Installation via Composer angeboten( 

```
composer global require 'phploc/phploc=*' 
composer global require 'sebastian/phpcpd=*' 
``` 

), jetzt geht es, somit der Patch auf das Phing Drupal Template:<fn>https://github.com/reinblau/phing-drupal-build/commit/06bf887a5a25ee8944bd95a3c9293da269690546</fn>.

<strong>Drupal und Composer</strong>

Aufmerksam wurde ich auf die Drupal und Composer Thematik durch die Slides von Florian Weber bei der DUB  <fn>http://www.drupalberlin.de/sites/default/files/pdf/Drupal%20und%20Composer.pdf</fn>, hier wurde Composer nicht nur als Dependency-Management sondern als Package-Management und Drush-Make-Ersatz gehandelt. 

Drush-Make<fn>https://www.drupal.org/project/drush_make</fn> ist in Drupal das De-Facto Standard Werkzeug um z.B. Drupal-Distributionen mit seinen Anhängigkeiten, Drupal-Core inklusive  Module, festgepinnt auf Versionsnummern oder gar auf einen SHA1-Commit, inklusive seiner der in vielen Fällen noch benötigten Patches auf Module und ggf. auch Core und der benötigten Bibliotheken zu bauen. Diese "Rezepte" werden in sog. Makefiles hinterlegt, hier das drupal-org.make<fn>http://cgit.drupalcode.org/bassets/tree/drupal-org.make</fn> von <a href="https://www.drupal.org/project/bassets">Bassets</a><fn>https://www.drupal.org/project/bassets</fn> als Beispiel.  
Im Optimalfall besteht ein Drupal-Projekt dann auch nur noch aus einem Makefile und seinem Custom-Code, also Modulen, Features, Theme und Template-Dateien, die anderen Abhängigkeiten werden über das Makefile erfasst und in der Regel dann über eine Continious Integration Umgebung zusammengebaut. 
Ade Patches.txt auf Root-Ebene, hallo Patchmanagement inkl. Fehlererkennung und Feedback! 
Jetzt hat sich in der PHP-Welt auch einiges getan und es heisst runter von der Insel<fn>https://www.acquia.com/blog/using-composer-manager-get-island-now</fn>!

<blockquote>
Meanwhile the PHP Community has gathered around another dependency manager, Composer. It is even used for managing dependencies for Drupal 8 Core.<fn>https://github.com/drupal-composer/drupal-project</fn>
</blockquote>.

Der in den Slides beschrieben Helige Gral (oder das runter von der Insel), das Drush-Make-Replacement: 
Seit einiger Zeit ist die Composer Gruppe auf g.d.o<fn>https://groups.drupal.org/composer</fn>&nbsp;neben viel Beteiligung der Deutschen Drupal-Community wie von Florian Weber (webflo), Johannes&nbsp;Haseitl (derhasi) und Tobias Stöckler recht aktiv und es wird einiges <fn>https://github.com/drupal-composer</fn> <fn>http://packagist.drupal-composer.org/</fn> vorangetrieben 
und erfährt erstaunlich viel Beachtung und Akzeptanz.

Schaut mal rein, ich finde diese Entwicklung spannend!

---
tags:
- snippet
- php-cli
- drush
- Drupal
- "<?php ?>"
- "#!/bin/bash"
nid: 971
layout: post
title: drush 6.x-2.1 Release
created: 1256636889
---
Gestern wurde <acronym title="Drupal Shell">drush</acronym> in der <a href="http://drupal.org/node/614830" title="Version 2.1 Release Node">Version 2.1</a> herausgegeben.

Neben zahlreichen Bug Fixes gibt es zwei signifikante Änderungen, die ich hier beschreiben möchte.
<ol>
<li>Die Entfernung des Shebang's in drush.php.</li>
<li>Die Einführung von Aliases. </li>
</ol>
<!--break-->
<ol>
<li>Aus der Datei <i>drush.php</i> wurde das <a href="http://de.wikipedia.org/wiki/Shebang">Shebang</a>, (<code>#!/usr/bin/env php</code>), auch als Hash-Bang oder Interpreterdeklaration bezeichnet entfernt. <p>Dies hat zur Folge, dass <i>drush.php</i> nicht mehr als solches aufrufbar ist, es sei denn, man stellt <i>drush.php</i> ein <i>php</i> voran (<code>php drush.php</code>).</p><p>Stattdessen soll der Aufruf über das Shell-Skript <i>drush</i> erfolgen.</p><p>Siehe <a href="http://drupal.org/node/586466" title="Issue #586466">#586466</a> <blockquote>Remove shebang from drush.php. You should use the drush scell script, or call 'php drush.php' instead.</blockquote>.
<p>Durch diese Änderung, habe ich die Installation von <acronym title="Drupal Shell">drush</acronym>  überdacht, diese sieht bei mir jetzt so aus: </p>
<ol>
<li>Den drush-Ordner habe ich nach <i>/usr/local/share</i> verschoben.</li>
<li>In <i>/usr/local/bin</i> liegt Symbolische Link <i>drush</i>, welcher auf das Shell-Skript <i>/usr/local/share/drush/drush</i> zeigt.
<code>lrwxrwxrwx 1 root root 26 2009-10-25 00:03 drush -> /usr/local/src/drush/drush</code>
</li>
</ol>
<li>Die zweite signifikante Änderung, ist die Einführung von Aliases, siehe auch <a href="http://drupal.org/node/549494" title="Issue #549494">Issue #549494</a>. So wurde z.B. aus <i>dl</i>, <i>download</i> mit <i>dl</i> als Alias und unter anderem ist <i>cache clear</i> ist nun über <i>cc</i> aufrufbar.  
<p>Für Entwickler gestaltet sich das definieren von Aliases wie folgt:</p><p>In <i>hook_drush_command</i> ist der Array Items um den Index <i>aliases</i> erweitert worden, diesem kann man einen Array mit Aliases hinzufügen, wie hier am Beispiel der Erweiterung von <i>example.drush.inc</i> zu sehen ist.</p>

{% highlight php %}
function example_drush_command() {
  $items = array();
  $items['example'] = array(
    'callback' => 'example_callback',
    'description' => "Drush example command. It doesn't do a lot",
    'aliases' => array('ex'),
  );
}
{% endhighlight %}

Durch die Einführung der Aliase lässt sich diese Aussage nochmals untermauern:
<blockquote>
<a href="https://vimeo.com/5207683">Drush: More Beer, Less Effort</a>
</blockquote>
</li>

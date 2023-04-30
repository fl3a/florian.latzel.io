---
tags:
- Entwicklung
- SQL
- Gut zu wissen
- howto
- snippet
- Drupal
- API
- "<?php ?>"
- drupal-7.x
nid: 1612
layout: post
title: 'Ähnlichkeiten in SQL: Drupal + db_query + LIKE'
created: 1350412870
---
<p>Den Fallstrick und die Suche möchte ich euch ersparen...</p>
<blockquote>db_like is the way to go</blockquote>

```
<?php
$result = db_query( 
  'SELECT * FROM person WHERE name LIKE :pattern', 
   array(':pattern' => db_like($prefix) . '%') 
); 
```
<ul>
	<li><a href="http://api.drupal.org/api/drupal/includes%21database%21database.inc/function/db_query/7#comment-33348">db_like is the way to go</a></li>
	<li><a href="http://api.drupal.org/api/drupal/includes%21database%21database.inc/function/db_like/7">7 database.inc db_like($string)</a></li>
	<li><a href="http://de.wikibooks.org/wiki/Einf%C3%BChrung_in_SQL:_WHERE-Klausel_im_Detail#LIKE_.E2.80.93_.C3.84hnlichkeiten_.281.29">SQL LIKE – Ähnlichkeiten</a></li>
</ul>
<!--break-->

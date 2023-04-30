---
tags:
- Gut zu wissen
- howto
- snippets
- Drupal
- API
- "<?php ?>"
- Entwicklung
nid: 1617
permalink: "/drupal-7-hook-menu-mit-wildcards.html"
layout: post
title: 'Drupal 7: hook_menu mit Wildcards'
created: 1358245041
---
In Zeile 6, registriere ich hier einen Menü-Pfad mit einer sog. <em>Wildcard</em>, also einem Platzhalter.

Das bedeutet in diesem Fall, dass während der Pfad-Anteil <em>example/</em> fix ist, dass der zweite Pfad-Anteil <em>%node_type_nid</em>, wie hoffentlich schon durch seine Benennung deutlich wird, Node-ID's (nids) von Node-Typ example enthalten soll.

```
<?php
/**
 * Implements hook_menu().
 */
function example_menu() {
  $items = array();
  $items['example/%node_type_example_nid'] = array(
    'title' => 'Example page title',
    'description' => 'Example page description',
    'page callback' => 'drupal_get_form',
    'page arguments' => array('example_form', 1),
    'access callback' => TRUE,
  );
  return $items;
}
```
<ul>
 <li>404 bei Aufruf von <em>example/123</em>?</li>
 <li>Wie bekomme ich es hin, dass der Pfad nur in Verbindung von Node-ID's vom Typ example valide ist?</li>
 <li>...vielleicht noch zusätzliche Validierungen?</li>
</ul>
<!--break-->
<strong>Auto-Loader Wildcards</strong>
<blockquote>
Registered paths may also contain special "auto-loader" wildcard components in the form of '%mymodule_abc', where the '%' part means that this path component is a wildcard, and the 'mymodule_abc' part defines the prefix for a load function, which here would be named mymodule_abc_load().<fn>http://api.drupal.org/api/drupal/modules%21system%21system.api.php/function/hook_menu/7</fn>
</blockquote>

Hier die <em>special auto-loader Funktion</em>, benannt nach dem Namen der Wildcard als Prefix, <em>node_type_example_nid</em> + <em>_load</em>.

```
<?php
function node_type_example_nid_load($nid) {
  $node = node_load($nid);
  if ($node) {
    if ($node->type == 'example_node_type') {
      global $user;
      // Only node author/owner might access.
      if ($user->uid == $node->uid) {
        return $nid;
      }
      else {
        return FALSE;
      }
    }
    else {
      return FALSE;
    }
  }
  else {
    return FALSE;
  }
}
```



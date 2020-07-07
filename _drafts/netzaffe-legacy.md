---
title: Migration von Drupal6 nach Jekyll
layout: post
toc: true
---

Drupal 6 nach Jekyll
<!--break-->

## Vorbereitungen

### Image node type

Ich verwendete noch das *gute, alte Image Modul[^img], das war bis CCK auch _State of the Art_ war.
So ziehe ich mir die Liste von _Image Nodes_, die ich auf der Startseite beworben habe und mit umziehen möchte. <!--more-->

```
mysql> select title,nid from node where type='image' and promote=1; 

```

Da die Anzahl der Image Nodes überschaubar war, bin ich diese Liste bin ich per Hand durchgegangen,
habe das jeweilige Orginalbild in Node-Body via Image_Tag eingebunden und habe den Typ nach _blog_ konvertiert.

### Books nodes

Ich habe einige [Howtos](/tags/howto/) mit *Drupals Book Module*
Liste der Book-Nodes der veröffentlichten Büchern auf meiner Seite:

```
SELECT distinct n.title, n.type,n.nid, b.bid, b.mlid, 
 concat('book/export/html/', n.nid) AS export 
  FROM node n, book b 
 WHERE n.nid=b.nid 
    AND n.type='book' 
    AND n.status=1 
    AND n.nid=b.bid;
```

Liste der dazugehörigen Unterseiten:

```
SELECT n.title,n.nid, b.bid, b.mlid 
  FROM node n, book b 
 WHERE 
    n.nid=b.nid 
    AND n.type='book' 
    AND n.status=1 
    AND b.bid 
    IN (
      SELECT n.nid 
        FROM node n, book b 
       WHERE n.nid=b.nid 
          AND n.type='book' 
          AND n.status=1 
          AND n.nid=b.bid
    ) 
 ORDER BY b.bid;
```

### Bilder in Nodes 

Bilder die im Node Body eingebunden sind:

**Liste der Bilder**


```
var=`echo 'SELECT r.body FROM node_revisions r, node n WHERE n.nid = r.nid AND n.promote=1;' | mysql`              
```

```
echo -e $var | sed -n 's/.*src="\([^"]*\).*/\1/p'| uniq 
```

**Anpassung der img src**

Der neue Pfad für die Bilder soll sich unter _assets/imgs_ befinden.

Die Anpassung der _img src_ mache ich direkt in der Datenbank mit SQL REPLACE[^] neue Img src:

```
UPDATE `node_revisions` SET `body` = REPLACE(`body`, 'src="/sites/netzaffe.de/files/"', 'src="/assets/imgs'); 
```

## jekyll-import

Der Jekyll-Importer[^], der die Inhalte von Drupal6 nach Jekyll migrieren soll, hatte einige Abhängigkeiten.
Laut meiner history hat es so funktioniert das _jekyll-import_ Gem lauffähig zu installieren:

```
sudo apt-get install zlib1g-dev
gem install jekyll-import
gem install sequel
apt-get install libmysqlclient-dev'
sudo apt-get install libmysqlclient-dev
gem install mysql2
sudo apt-get install libpq-dev
gem install pg
```


Unser Augenmerk liegt hier auf dem  **Drupal 6 Importer** [^], dieser braucht mindestens die Daten für den Datenbankzugriff,
optional die Inhaltstypen, die migriert werden sollten.

```
ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Drupal6.run({
      "dbname"   => "netzaffe",
      "user"     => "florian",
      "password" => "mypassword",
      "host"     => "localhost",
      "types"    => ["blog", "book", "page"]
    })'
```

### Anpassung des Importers

Ich habe den **Jekyll-Importer für Drupal 6** ein wenig auf meine Bedürftnisse angepasst.
Hierzu habe ich jekyll-ímport geforked[^]

#### permalink

Der eigentliche Grund, warum ich den Importer geforked habe war, dass ich meine url_aliase behalten 
und sie als _permalink Statenment_ im _Front Matter_ nutzen möchte.

Hierzu habe ich die SQL Abfrage so erweitert, dass auf _alias_ (dst aus der url_alias Tabelle) zugegriffen werden kann
um es später _excerpt_ zuordnen zu können.

Die Änderungen hierfür bedinden sich im Master-Branch meines Forks.


#### summary

Ich möchte meinen _Teaser_ nicht in _Front Matter_ stehen haben, denn das bläst meiner Meinung nach
die Metadaten im _Front Matter_ und somit die Markdown-Datei zu sehr auf.

Jekyll soll wie Drupal auch den Teaser (entspricht _excerpt_ in Jekyll) aus die Body ziehen, 
hierzu möchte ich weiterhin das _Pseudotag_ `<!--break-->` als Begrenzer nutzen.

Das zweite Statement ist nötig, aber unter Umständen spezifisch für das _Minima Theme_.

1. Hierzu ist eine Einstellung in Jekyll´s __config_ nötig
  ```
show_excerpts : true
excerpt_separator   : "<!--break-->"
  ```
2. Im Importer habe ich das Statenment entfernt, indem _excerpt_ befüllt wird.

#### Tags

Die Tags aus Drupal werden auf _categories_ im _Front Matter_ gemappt, vorher werden sie in Kleinbuchstaben umgewandelt.

Im meiner Anpassung habe ich das `.downcase` entfernet und das Mapping findet im _Front Matter_ auf _tags_ statt.

#### Redirects 

Jekyll generiert per dafault Dateien mit Forwarding von der alten (Drupal) URL zur 

> In den meisten Fällen ist es allerdings vorteilhafter, eine „echte“ Weiterleitung mit HTTP-Status-Codes zu benutzen. 
> Dies ist allerdings nur mit serverseitigen Techniken möglich, siehe etwa das Apache-Modul mod_alias. [^]


> Use meta-refresh only if you your current hosting provider doesn't allow a 301, 
> primarily because the W3C's Web Content Accessibility Guidelines (7.4) 
> discourage the creation of auto-refreshing pages, 
> since most web browsers do not allow the user to disable or control the refresh rate 
> and secondly Spammers use a meta-refresh to refresh the page after every 5 seconds 
> to save themselves from any type of ranking punishment. [^]

#### Layouts

### Nacharbeiten

Die Inhalte vom Typ *blog* ins  *post Layout* umwandeln:


```
for file in `grep 'layout: blog' *| cut -d ':' -f1`
do
  sed -i -e s/layout:\ blog/layout:\ post/ $file
  sed -i -e 's/sites\/netzaffe\.de\/files/assets\/imgs/g' $file
  sed -i -e 's/width="510px"//g' $file
done
```

#### Footnotes


#### Code

#### Markdown

#### CR+LF

`^M`

-> dos2unix

#### Kommentare

#### Permalinks


Präfix /blog/
```
sed -i '/^permalink:\ "\/blog\/.*"$/d' _posts/* 
```
* * *


[^]: [Drupal 6 -- jekyll-import](https://import.jekyllrb.com/docs/drupal6/)
[^]: [Drupal 6 &mdash; jekyll-import](https://import.jekyllrb.com/docs/drupal6/)
[^]: [jekyll-import](https://github.com/jekyll/jekyll-import)
[^]: [fl3a/jekyll-import](https://github.com/fl3a/jekyll-import)
[^]: [SELFHTML: HTML/Kopfdaten/meta](https://wiki.selfhtml.org/wiki/HTML/Kopfdaten/meta)
[^]: [The SEO war of redirects: 301 vs 302 vs meta-refresh tag](https://www.redalkemi.com/blog/post/the-seo-war-of-redirects-301-vs-302-vs-meta-refresh-tag)
[^img]: [Image Module](https://www.drupal.org/project/image)
[^boomba]: [boombatower: Ported Drupal blog to Jekyll](https://blog.boombatower.com/2020/04/13/ported-drupal-blog-to-jekyll)

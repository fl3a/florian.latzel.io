---
title: Jekyll Deployment via Bare Repository und post-receive Hook
tags: 
- Jekyll
- howto
- "#!/bin/bash"
- deployment
- uberspace
- git
- snippet
layout: post
toc: true
permalink: /jekyll-deployment-via-bare-repository-und-post-receive-hook.html 
image: /assets/imgs/gears-of-industry.jpg
last_modified_at: 2021-04-02
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
(CC BY-NC-ND 2.0), House Photography' %}

Deployment einer [Jekyll-Site](/tags/jekyll) via *Git Bare Repository*[^bare] 
und *post-receive Hook*[^hooks] auf einen Webserver.

Zielstellung ist, dass ein `git push` auf das *Remote Repository*[^remote] 
das weiter unten beschriebene Skript triggert.
Dieses generiert aus dem Repository mit all seinen Änderungen, 
wie z.B. Markdown, Config,  Layout,  Include 
und den Abhängigkeiten im Gemfile[^bundler]
das entsprechende HTML, 
dass dann der Welt 
in der *DocumentRoot*[^docroot] deines *Webservers*, 
in meinem Fall einem [Uberspace](http://uberspace.de) ausgeliefert wird.<!--break-->

## Vorbereitungen auf dem Zielserver

Wir starten nach erfolgreichem SSH-Login auf unserem Uberspace-Host 
in unserem Home-Verzeichnis und legen Ordner für unser Repository an,

```
mkdir repos
```

wechseln dort hinein
```
cd repos
```

und erstellen den Ordner für das Repository auf das wir später *pushen* wollen.
In diesem Fall entspricht der Ordnername der Domain.
Ab hier solltest du das exemplarische *netzaffe.de* durch deine Domain ersetzen.
```
mkdir netzaffe.de
```

und wechseln hinein.
```
cd netzaffe.de
```

Jetzt initialisieren wir den Ordner als **Bare Repository**[^bare].
```
git init --bare
```

### [DEPRECATED] The --path flag is deprecated ...

Vor einiger Zeit tauchte die folgende Meldung beim Deployment auf:

> [DEPRECATED] The `--path` flag is deprecated 
> because it relies on being remembered across bundler invocations, 
> which bundler will no longer do in future versions. 
> Instead please use `bundle config set --local path '~/.gem'`, and stop using this flag 

Ich habe das `--path` aus dem Skript entfernt und statt dem Vorschlag 
folgendes gemacht:

```
bundle config set --global path '~/.gem'
```

> Your application has set path to "~/.gem".
> This will override the global value you are currently setting

Statt einer lokalen `.bundle/config` mit nur einer Zeile
geht hierdurch die folgende Zeile nach `~/.bundle/config`:
```
BUNDLE_PATH: "~/.gem"
```

## Das Deployment Skript

Wenn der komplette Prozess der Übertragung (Push) abgeschlossen ist, 
greift serverseitig der sogenannte **post-receive Hook**[^hooks]
und führt das gleichnamige Skript (sofern vorhanden) aus.

Das [Jekyll uberspace deployment Skript](https://github.com/fl3a/jekyll_deployment)
welches wir als *post-receive Hook*[^hooks] nutzen 
findest du [hier](https://github.com/fl3a/jekyll_deployment) auf github.  
Hier der Stand vom 30. März 2021:

```shell
#!/bin/bash

# Deployment of Jekyll-Sites  
# via Git Bare Repository and post-receive hook.
#
# See https://netzaffe.de/jekyll-deployment-via-bare-repository-und-post-receive-hook.html
# for requirements and more detailed description (german)
# set -x

# Get pushed branch

read oldrev newrev ref 
pushed_branch=${ref#refs/heads/} 

## Source configuration from repository

config=$(mktemp)
git-show HEAD:deploy.conf > $config || exit 
source $config

## Do the magic

[ "$pushed_branch" != "$build_branch" ] && exit 1
tmp=$(mktemp -d)
git clone $git_repo $tmp
cd $tmp
bundle install || bundle install --redownload
bundle exec jekyll build --source $tmp --destination $www
rm -rf $tmp $config
```

### Beschreibung des Skripts 

1. Einlesen des gepushten Branches 
um ihn später vergleichen zu könnnen  (Zeile 12 & 13)
2. Umleiten des Inhalts der Datei `deploy.conf` 
aus den Repository in eine temporäre Datei und Einlesen dieser(Zeile 17 bis 19)
3. Prüfung ob der in 1. übertragene Branch
mit der via Variable `build_branch`übereinstimmt, 
ansonsten Abbruch (Zeile 23). 
4. Anlegen eines temporären Verzeichnisses
5. Klonen des Bare-Repos[^bare] in ein temporäres Verzeichnis (Zeile 25).
6. Verzeichniswechsel in das temporäres Verzeichnis.
7. Installation der im Gemfile spezifizierten Abhängigkeiten via `bundle install`[^bundler].
Falls `bundle install` fehlschlägt, 
wird das nochmal mit der Option `--redownload`[^reinstall] versucht.
8. Generierung des HTML aus *tmp* in die mit `www` spezifizierte *Document Root* 
via `jekyll build` 
5. Löschung temporäres Verzeichniss und Datei. Dat wor et!

### post-receive Hook

Als Erstes entfernen wir den *Default post-receive Hook* aus dem Bare-Repository
um ihn später durch einen Link auf unser Skript zu ersetzen.

```
rm ~/repos/netzaffe.de/hooks/post-receive
```

Dann clonen wir das [Jekyll Deployment Skript](https://github.com/fl3a/jekyll_deployment), 
dort passiert später die ganze Magie.

```
git clone https://github.com/fl3a/jekyll_deployment.git ~/repos 
```

Jetzt legen wir einen Symlink namens *post-receive* im *Bare-Repo* an, 
der auf das gleichnamige *Deployment Skript* verweist:

```
ln -s ~/repos/jekyll_deployment/post-receive ~/repos/netzaffe.de/hooks/post-receive
```

Last but not least, muss das Skript noch ausführbar gemacht werden:

```
chmod +x ~/repos/jekyll_deployment/post-receive
```

### deploy.conf - Anpassung der Variablen

Mit dieser Konfiguration für das *post-receive* Skript verfährst du wie folgt:
1. Kopiere hierzu *deploy.conf* in die Hauptebene deines lokalen *Jekyll Repositories* 
2. Passe die Variablen auf die Bedürfnisse deines Zielsystems hin an
3. *Committe* diese Datei anschließend

Sofern du alles wie oben beschrieben umgesetzt hast 
und du auch auf [uberspace](https://uberspace.de) bist😙,
sind nur `subdomain` und `domain` anzupassen.
Alle anderen Variablen sind vorbelegt, werden zusammengesetzt oder sind optional.

- `build_branch`, Der Branch der gebaut werden soll z.B. `master`.
- `subdomain`, optional. z.B. `sub.` oder leer. Falls gesetzt, achte auf den `.` am Ende!
- `domain` Name der Domain, z.B. 'netzaffe.de'.
- `git_repo` Pfad zu Jekyll Bare Repo auf dem Server z.B. `${HOME}/repos/${domain}` 
-  `www` Pfad zur *Document root* auf dem Server, 
wo das generierte HTML ausgeliefert wird,  
z.B `www=/var/www/virtual/${USER}/${subdomain}${domain}`. 
Dieses Pfadschema ist *uberspace spezifisch*, aber natürlich anpassbar.

### Bonus Smash: jekyll_deployment.sh

Die Datei `jekyll_deployment.sh` ist für die direkte Ausführung auf dem Zielsystem
und manchmal ganz nützlich um das Deployment ohne einen Push 
anzustoßen, wenn z.B. *bundler*[^bundler] mal wieder zickt.

Es sind die gleichnamigen Variablen wie vorigen Abschnitt im Skript selbst anzupassen
und die Datei oder ein Link sollten sich im Suchpfad befinden.

## Nötige Schritte im lokalen Git-Repository

Das waren die Schritte auf deinem Uberspace, 
weiter gehts in deinen lokalen Git Repository.
Das oben erstellte Bare-Repository fügst du deinem lokalen Repository
so als sog. Remote-Repository[^remote] namens *uberspace* hinzu:

```
git remote add uberspace fl3a@bellatrix.uberspace.de:repos/netzaffe.de
```

Fertig, jetzt noch der push vom *master* nach *uberspace*.

```
git push uberspace master
```

Nach der Übertragung der Daten solltest du jetzt die Ausgaben von `git clone`,
`bundle install` und `jekyll build` sehen.

## Learnings

- Get file from git repo <https://stackoverflow.com/questions/610208/how-to-retrieve-a-single-file-from-a-specific-revision-in-git>
- Eine Erkenntnis zu *exit*[^exit] [sic]
> Es ist eine verbreitete Unsitte als letzten Befehl eines Scripts 'exit 0' zu verwenden. 
> Ein Skript das zu Ende ist, ist zu Ende und braucht keinen ausdrücklichen Abbruch, vor allem keinen, der den letzten Fehler kaschiert.
- Darauf bin ich beim Recherchieren zu exit gestoßen: *traps*[^traps]
- *git ours*[^ours], darauf bin ich gestoßen, 
während ich den Hook überarbeitet habe 
und in Richtung Config in Repository gegangen bin und an eine Config je Branch gedacht habe.
Kannte ich nicht, das will ich mal ausprobieren.
- Noch keine README im Repository, aber über *goldene Türklinken* nachdenken.
*jekyll_deployment.sh* ist im Vergleich zu *post-receive* nicht so schön und schlank,
aber die grundlegenede Funktionalität ist in beiden Skipten gleich... 
Auslagern🧠, es geht schöner⌨️!
Verlieren wir uns nicht in Schönheit 
und bringen wir diesen Post erstmal ins Netz, Florian☝️.
Es handelt sich hierbei ja eigentlich um ein Abfallprodukt, 
dass aus einer Ur-Version basiert. 

## Credits

Dieser Artikel basiert im wesentlichen auf 
[Jekyll Auf Uberspace Mit Git](https://www.wittberger.net/post/jekyll-auf-uberspace-mit-git/) von Daniel Wittberger 
und [Jekyll Auf Uberspace](https://lc3dyr.de/blog/2012/07/22/Jekyll-auf-Uberspace/)
von Franz aka laerador. Danke!

Dieser Artikel ist eine aktuelle Essenz, die sich nur auf das Deployment bezieht. 
Seit 2012, 2013 hat sich einiges in Jekyll und auf Uberspace etc. getan 
und das Skript hat noch etwas Liebe erfahren. 

## Verwandte Artikel

- [s/Drupal/Jekyll](/2019/11/09/von-drupal-nach-jekyll.html), 
über meinen [Umstieg von Drupal nach Jekyll](/2019/11/09/von-drupal-nach-jekyll.html) Anfang 2019
- In `_draft`: *Migration von Drupal 6 nach Jekyll*.
Vorbereitende Schritte, Anpassung des Jekyll Drupal6 Importers und Nacharbeiten
- Alle weiteren [Artikel mit dem Tag Jekyll](/tags/jekyll/index.html)

---

[^bare]: [What is a bare git repository?](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)
[^hooks]: [Git einrichten - Git Hooks](https://git-scm.com/book/de/v2/Git-einrichten-Git-Hooks) 
[^remote]: [Git Grundlagen - Mit Remotes arbeiten](https://git-scm.com/book/de/v2/Git-Grundlagen-Mit-Remotes-arbeiten)
[^bundler]: [Gems, Gemfiles and the Bundler](https://learn.cloudcannon.com/jekyll/gemfiles-and-the-bundler/)
[^docroot]: [Uberspace: DocumentRoot](https://manual.uberspace.de/web-documentroot/)
[^reinstall]: [How do I force Bundler to reinstall all of my gems?](https://stackoverflow.com/questions/45290135/how-do-i-force-bundler-to-reinstall-all-of-my-gems?answertab=votes#tab-top)
[^env]: [Linux/UNIX Umgebungsvariablen](https://linuxwiki.de/UmgebungsVariable)
[^redownload]: [How do I force Bundler to reinstall all of my gems?](https://stackoverflow.com/questions/45290135/how-do-i-force-bundler-to-reinstall-all-of-my-gems)
[^exit]: [exit > Wiki > ubuntuusers.de](https://wiki.ubuntuusers.de/exit/)
[^traps]: [Unix / Linux - Signals and Traps](https://www.tutorialspoint.com/unix/unix-signals-traps.htm)
[^ours]: [How to make Git preserve specific files while merging](https://medium.com/@porteneuve/how-to-make-git-preserve-specific-files-while-merging-18c92343826b)

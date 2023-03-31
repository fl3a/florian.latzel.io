---
title: Jekyll Deployment via Bare Repository und post-receive Hook
tags: 
- Jekyll
- howto
- "#!/bin/bash"
- deployment
- Open Source
- uberspace
- git
- snippet
layout: post
toc: true
permalink: /jekyll-deployment-via-bare-repository-und-post-receive-hook.html 
image: /assets/imgs/gears-of-industry.jpg
last_modified_at: 2021-09-04
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
Ab hier solltest du das exemplarische *florian.latzel.io* durch deine Domain ersetzen.
```
mkdir florian.latzel.io
```

und wechseln hinein.
```
cd florian.latzel.io
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

### Der Code

Hier der Stand vom 03. September 2021: 
```bash
#!/bin/bash

# Deployment of Jekyll-Sites via Git Bare Repository and post-receive hook.
#
# USAGE:
# - git hook: Place this script as .hooks/post-receive within your git repository
# - standalone: ${SCRIPT} /path/to/git-bare-repository
#
# See https://florian.latzel.io/jekyll-deployment-via-bare-repository-und-post-receive-hook.html
# for setup and a more detailed description (german)
#
# set -x

if [ -z "$1" ]; then
  read oldrev newrev ref
  pushed_branch=${ref#refs/heads/}
elif [ -d "$1" ] && { cd $1 ; git rev-parse --is-bare-repository ; } >/dev/null; then
  pushed_branch=""
else
  exit
fi

config=$(mktemp)
git show HEAD:deploy.conf > $config || exit
source $config

[ -z "$pushed_branch" ] && build_branch=$pushed_branch
[ "$pushed_branch" != "$build_branch" ] && exit
tmp=$(mktemp -d)
git clone $git_repo $tmp
cd $tmp
bundle install || bundle install --redownload
JEKYLL_ENV=${env:-production} \
  bundle exec jekyll build --source $tmp --destination $www $build_prefix
rm -rf $tmp $config
```

#### Beschreibung des Codes 

1. *"Debug Modus"*, entfernen der Raute um mehr Ausgaben zu sehen (Zeile 12) 
2. Indikator für Git-Hook: Überprüfung ob keine Parameter übergeben wurden(Zeile 14)
3. Einlesen des gepushten Branches(Zeile 15 und 16) um ihn später vergleichen zu könnnen  
3. Test ob es sich um ein Verzeichnis handelt, Verzeichnswechsel dort hinein 
und testen ob es sich um ein *Bare-Repository* handelt (Zeile 20), sonst Exit.
Die Standardausgabe, also `true` wird nach `/dev/null` geschrieben 
während der Fehlerkanal bewusst ausgegeben wird (Zeile 20)
4. Zusweisung eines leeren Strings auf Variable `pushed_branch` (Zeile 18)
5. Anlegen einer temporären Variablen `config` (Zeile 23)
6. Umleiten des Inhalts der Datei *deploy.conf* aus dem Bare-Repository,
die unsere Konfiguration für das Deployment enthält in die Variable `$config`,
falls die Datei existiert sonst `exit` (Zeile 24)
7. Einlesen der Konfiguration aus der Variablen `$config`(Zeile 25)
8. Falls Variable `$pushed_branch` leer ist (vergl. Zeile 18),
dann bekommt die Variable `build_branch` den gleichen Wert 
den `$pushed_branch` enthält (Zeile 27)
9. Die Variablen `$pushed_branch` und `$build_branch` werden auf Ungleichheit verglichen,
ist das der Fall, dann wird das Skript mit `exit` verlassen (Zeile 28).
10. Anlegen eines temporären Verzeichnises Names `tmp` (Zeile 29)
11. Klonen des Bare-Repos[^bare] das das temporäre Verzeichnis `tmp` (Zeile 30).
12. Verzeichniswechsel in das temporäre Verzeichnis `$tmp` (Zeile 31)
13. Installation der im Gemfile spezifizierten Abhängigkeiten via `bundle install`[^bundler].
Falls `bundle install` fehlschlägt, 
wird das nochmal mit der Option `--redownload`[^reinstall] versucht (Zeile 32)
14. Setzen von der Variable `JEKYLL_ENV` und Generierung des HTML 
aus `$tmp` in die mit `$www` spezifizierte *Document Root* via `jekyll build` 
15. Löschung des temporären Verzeichnisses `$tmp` und der Datei `$config`. Dat wor et!

### Nutzung als post-receive Git Hook

Wenn der komplette Prozess der Übertragung (Push) abgeschlossen ist, 
greift serverseitig der sogenannte **post-receive Hook**[^hooks]
und führt das gleichnamige Skript (sofern vorhanden) aus.

Das [Jekyll uberspace deployment Skript](https://github.com/fl3a/jekyll_deployment)
welches wir als *post-receive Hook*[^hooks] nutzen 
findest du [hier](https://github.com/fl3a/jekyll_deployment) auf github.  

#### Einrichtung des post-receive Hooks

Als Erstes entfernen wir den *Default post-receive Hook* aus dem Bare-Repository
um ihn später durch einen symbolischen Link auf unser Skript zu ersetzen.

```
rm ~/repos/florian.latzel.io/hooks/post-receive
```

Dann clonen wir das [Jekyll Deployment Skript](https://github.com/fl3a/jekyll_deployment), 
dort passiert später die ganze Magie.

```
git clone https://github.com/fl3a/jekyll_deployment.git ~/repos 
```

Jetzt legen wir einen Symlink namens *post-receive* im *Bare-Repo* an, 
der auf das gleichnamige *Deployment Skript* verweist:

```
ln -s ~/repos/jekyll_deployment/post-receive ~/repos/florian.latzel.io/hooks/post-receive
```

Dann muss das Skript noch ausführbar gemacht werden:

```
chmod +x ~/repos/jekyll_deployment/post-receive
```

Last but not least, muss die Konfiguration 
über die weiter unten beschrieben Datei *deploy.conf* erfolgen

#### Nötige Schritte im lokalen Git-Repository

Das waren die Schritte auf deinem Uberspace, 
weiter gehts in deinen lokalen Git Repository.\\
Das oben erstellte Bare-Repository fügst du deinem lokalen Repository
so als sog. Remote-Repository[^remote] namens *uberspace* hinzu:

```
git remote add uberspace fl3a@bellatrix.uberspace.de:repos/florian.latzel.io
```

Fertig, jetzt noch der push vom *master* nach *uberspace*.

```
git push uberspace master
```

Nach der Übertragung der Daten solltest du jetzt die Ausgaben von `git clone`,
`bundle install` und `jekyll build` sehen.


### Standalone: Aufruf mit dem Jekyll Repo als Argument

Das gleiche Skipt kann auch für die direkte Ausführung auf dem Zielsystem genutzt werden.
Das ist manchmal ganz nützlich um das Deployment direkt und ohne einen Push 
anzustoßen z.B. um den Fehler auszumachen, wenn *bundler*[^bundler] mal wieder zickt.

Es erfolgt die Konfiguration auch hier, wie in der *post-receive* Variante 
über die weiter unten beschriebenen Datei *deploy.conf*.

Um das Skript Standalone nutzen zu können, setzen wir einen Symlink in den Suchpfad:

```
ln -s ~/repos/jekyll_deployment/post-receive ~/bin/jekyll_deployment
```

Der Aufruf der Standalone-Variante erfolgt mit dem Jekyll-Repository als Argument:
```
jekyll_deployment ~/repos/florian.latzel.io
```

### deploy.conf - Anpassung der Variablen

Die Datei *deploy.conf* dient als Konfiguration für die Post-Receice-Hook 
als auch für die Standalone Variante.\\
Mit dieser Konfiguration verfährst du wie folgt:

1. Kopiere hierzu *deploy.conf* in die Hauptebene deines lokalen *Jekyll Repositories* 
2. Passe die Variablen auf die Bedürfnisse deines Zielsystems hin an
3. *Committe* diese Datei anschließend

Sofern du alles wie oben beschrieben umgesetzt hast 
und du auch auf [uberspace](https://uberspace.de) bist😙,
sind nur `subdomain` und `domain` anzupassen.
Alle anderen Variablen sind vorbelegt, werden zusammengesetzt oder sind optional.

- `build_branch`, Der Branch der gebaut werden soll z.B. `master`.
- `subdomain`, optional. z.B. `preview.` oder leer. Falls gesetzt, 
achte auf den `.` am Ende!\\
Wird mit u.g. Domain zu `preview.netzaffe.de`.
- `domain`, Name der Domain, z.B. `netzaffe.de`.
- `git_repo`, Pfad zum Jekyll Bare Repository auf dem Server\\
z.B. `${HOME}/repos/${domain}` 
-  `www`, Pfad zur *Document root* auf dem Server, 
wo das generierte HTML ausgeliefert wird,  
z.B `www=/var/www/virtual/${USER}/${subdomain}${domain}`.   
Dieses Pfadschema ist *uberspace spezifisch* und natürlich anpassbar.
- `env`, Wert für `JEKYLL_ENV`, default `production`
- `build_option`, Option die `bundle excec jekyll build` angefügt wird,\\
z.B. `--incremental`

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
Auslagern🧠, es geht schöner⌨️[^standalone]!
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
[^standalone]: 2021-09-04: Ich habe die 2 Skipte zu einem zusammengefasst und diesen Artikel entsprechend aktualisiert. Eine README gibt es immer noch nicht🤣.

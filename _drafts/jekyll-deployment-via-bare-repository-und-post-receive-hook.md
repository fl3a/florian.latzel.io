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
---
{% responsive_image figure: true 
path: assets/imgs/gears-of-industry.jpg 
alt: "Zahnräder" 
caption: '<a href="https://www.flickr.com/photos/housephotography/953871961/">Gears of industry</a>, 
(CC BY-NC-ND 2.0), House Photography' %}

Deployment einer [Jekyll-Site](/tags/jekyll) via *Git Bare Repository*[^bare] 
und *post-receive Hook*[^hooks] [^post] auf einen Webserver.

Zielstellung ist, dass ein `git push` auf das *Remote Repository*[^remote] 
das weiter unten beschriebene Skript triggert.
Dieses generiert aus dem Repository mit all seinen Änderungen, 
wie z.B. Markdown, Config,  Layout,  Include und Gemfile[^bundler])
das entsprechende HTML, das dann der Welt 
in der *DocumentRoot*[^docroot] deines *Webservers*, 
hier einem [Uberspace](http://uberspace.de) ausgeliefert wird.<!--break-->

## Vorbereitungen auf dem Zielserver

Wir starten nach erfolgreichem SSH-Login auf unserem Uberspace-Host 
in unserem Home-Verzeichnis und legen Ordner für unser Repository an

```
mkdir repos
```

und wechseln dort hinein,
```
cd repos
```

und erstellen den Ordner für das Repo auf das wir später *pushen* wollen.
In diesem Fall entspricht der Ordnername der Domain.
Ab hier solltest du das exemplarische *netzaffe.de* durch dein Domain ersetzen.
```
mkdir netzaffe.de
```

und wechseln hinein.
```
cd netzaffe.de
```

Jetzt initialisieren wir den Ordner als *Bare Repository*[^bare].
```
git init --bare
```

## Das Deployment Skript

Wenn komplette Prozess der Übertragung (Push) abgeschlossen ist, 
greift serverseitig der sogenannte *post-receive Hook*[^hooks]  
und führt das gleichnamige Skript (sofern vorhanden) aus.

Das [Jekyll uberspace deployment Skript](https://github.com/fl3a/jekyll_deployment)
welches wir als *post-receive Hook*[^hooks] nutzen 
findest du [hier](https://github.com/fl3a/jekyll_deployment) auf github.

{% highlight bash linenos %}
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
source ${config}

## Do the magic

[ "$pushed_branch" != "$build_branch" ] && exit 1
tmp=$(mktemp -d)
git clone $git_repo $tmp
cd $tmp
bundle install || bundle install --redownload
bundle exec jekyll build --source $tmp --destination $www
rm -rf $tmp $config
{% endhighlight %}

### Beschreibung des Skipts 

Das *Do the magic*

1. Überprüfung ob der übertragene- (pushed) und Build-Branch übereinstimmen, ansonsten Abruch.
2. Klonen des Bare-Repos[^bare] nach *tmp*
2. Verzeichniswechsel nach *tmp*
3. Installation der im Gemfile spezifizierten Abhängigkeiten via `bundle install`[^bundler]
4. Generierung der HTML von *tmp* nach *www* via `jekyll build` 
5. Löschen von *tmp*
6. Beendigung des Skripts


### post-receive Hook

Als erstes entfernen wir den *Default post-receive Hook* aus dem Bare-Repo
um ihn später durch einen Link auf unser Skript zu ersetzen.
```
rm ~/repos/netzaffe.de/hooks/post-receive
```

Dann clonen wir das [Skript](https://github.com/fl3a/jekyll_deployment), 
dort passiert später die ganze Magie.

```
git clone https://github.com/fl3a/jekyll_deployment.git ~/repos 
```

Jetzt legen wir einen Symlink namens *post-receive* an, 
der auf das gleichnamige *Deployment Skript* verweist:
```
ln -s ~/repos/jekyll_deployment/post-receive ~/repos/netzaffe.de/hooks/post-receive
```

Last but not least, muss das Skript noch ausführbar gemacht werden:
```
chmod +x ~/repos/jekyll_deployment/post-receive
```

### bundle config set --local path '~/.gem' 

> [DEPRECATED] The `--path` flag is deprecated 
> because it relies on being remembered across bundler invocations, 
> which bundler will no longer do in future versions. 
> Instead please use `bundle config set --local path '~/.gem'`, and stop using this flag 

### deploy.conf - Anpassung der Variablen

Sofern du alles wie oben beschrieben umgesetzt wurde 
und du auf uberspace bist😉 sind nur `subdomain` und `domain` anzupassen.
Alle anderen Variablen sind vorbelegt, werden zusammengesetzt oder sind optional.

- `build_branch`, Der Branch der gebaut werden soll z.B. `master`.
- `subdomain`, optional. z.B. `sub.` oder leer. Falls gesetzt, achte auf den `.` am Ende!
- `domain` Name der Domain, z.B. 'netzaffe.de'.
- `git_repo` Pfad zu Jekyll Bare Repo auf dem Server z.B. `${HOME}/repos/${domain}` 
-  `www` Pfad zur *Document root* auf dem Server, 
wo das generierte HTML ausgeliefert wird,  
z.B `www=/var/www/virtual/${USER}/${subdomain}${domain}`. 

1. Kopiere hierzu *deploy.conf* in dein lokales Repo
2. passe die Variablen auf deine Bedürfnisse hin an
3. *committe* diese Datei anschließend.


### Bonus Smash

## Nötige Schritte im lokalen Git-Repository

Das waren die Schrite auf deinem Uberspace, 
weiter gehts in deinen lokalen Git Repo.
Das oben erstellte Bare-Repository fügst du deinem Repo 
so als sog. Remote-Repository[^remote] Namens *uberspace* hinzu:

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
- traps, <https://www.tutorialspoint.com/unix/unix-signals-traps.htm> 
- EXIT 
> Es ist eine verbreitete Unsitte als letzten Befehl eines Scripts 'exit 0' zu verwenden. 
> Ein Skript das zu Ende ist, ist zu Ende und braucht keinen ausdrücklichen Abbruch, vor allem keinen, der den letzten Fehler kaschiert.


## Credits

Dieser Artikel basiert im wesentlichen auf [
Jekyll Auf Uberspace Mit Git](https://www.wittberger.net/post/jekyll-auf-uberspace-mit-git/) 
von Daniel Wittberger 
und [Jekyll Auf Uberspace](https://lc3dyr.de/blog/2012/07/22/Jekyll-auf-Uberspace/)
von Franz aka laerador. Danke!

Der Artikel ist eine aktuelle Essenz, die sich nur auf das Deployment bezieht. 
seit 2012, 2013 hat sich einiges in Jekyll und auf Uberspace etc getan) 
und das Skript hat noch etwas Liebe erfahren. 

## Verwandte Artikel

- [s/Drupal/Jekyll](/2019/11/09/von-drupal-nach-jekyll.html), 
über meinen [Umstieg von Drupal nach Jekyll](/2019/11/09/von-drupal-nach-jekyll.html) Anfang 2019
- In `_draft`: Migration von Drupal 6 nach Jekyll. Vorbereitende Schritte, Anpassung des Jekyll Drupal6 Importers und Nacharbeiten.

---

[^bare]: [What is a bare git repository?](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)
[^hooks]: [Git einrichten - Git Hooks](https://git-scm.com/book/de/v2/Git-einrichten-Git-Hooks) 
[^remote]: [Git Grundlagen - Mit Remotes arbeiten](https://git-scm.com/book/de/v2/Git-Grundlagen-Mit-Remotes-arbeiten)
[^bundler]: [Gems, Gemfiles and the Bundler](https://learn.cloudcannon.com/jekyll/gemfiles-and-the-bundler/)
[^docroot]: [Uberspace: DocumentRoot](https://manual.uberspace.de/web-documentroot/)

[^env]: [Linux/UNIX Umgebungsvariablen](https://linuxwiki.de/UmgebungsVariable)
[^redownload]: [How do I force Bundler to reinstall all of my gems?](https://stackoverflow.com/questions/45290135/how-do-i-force-bundler-to-reinstall-all-of-my-gems)

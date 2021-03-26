---
title: Jekyll Deployment auf Uberspace via Bare Repo und post-receive Hook
tags: 
- Jekyll
- howto
- "#!/bin/bash"
- uberspace
- git
- snippet
layout: post
toc: true
permalink: /jekyll-deployment-auf-uberspace-via-bare-repo-und-post-receive-hook/
---
Deployment einer [Jekyll-Site](/tags/jekyll) auf [Uberspace](https://uberspace.de) via *Git Bare Repository*[^2] und *post-receive Hook*[^1].

Zielstellung ist, dass ein `git push` auf das *uberspace Remote Repository*[^3] das weiter unten beschriebene Skript triggert,
welches aus deinem Jekyll Repository mit all seinen Änderungen (wie z.B. Markdown, Config-,  Layout- und  Include-Änderungen und Gemfile[^4]) 
eine Website generiert und dann der Welt auf dem *Webserver*[^5] deiner Uberspace 6 Umgebung verfügbar macht.<!--break-->

## Vorbereitungen auf uberspace

Wir starten nach erfolgreichem SSH-Login auf unserem Uberspace-Host 
in unserem Home-Verzeichnis und legen Ordner für unser Repository

### Bare Repository anlegen

```
mkdir repos
```

und wechseln dort hinein,
```
cd repos
```

erstellen den Ordner für das Repo auf das wir später *pushen* wollen 
(Ab hier solltest du das exemplarische *netzaffe.de* durch eure Domain ersetzen.)
```
mkdir netzaffe.de.git
```

und wechseln hinein.
```
cd netzaffe.de.git
```

Jetzt initialisieren wir den Ordner als *Bare Repo*[^2].
```
git init --bare
```

### post-receive Hook 

Wenn komplette Prozess der Übertragung (Push) abgeschlossen ist, greift der sogenannte *post-receive Hook*[^1] 
und führt das gleichnamige Skript (sofern vorhanden) aus.

Dafür wechseln wir in das Verzeichnis *hooks*
```
cd hooks
```

und entfernen den *Default post-receive Hook* 
```
rm post-receive
```

Dann clonen wir das [Skript](https://github.com/fl3a/jekyll_uberspace_deployment), 
dort passiert später die ganze Magie.

```
cd ~/repos
```

```
git clone 
```


um später einen auf das *Deployment Skript* den Symlink setzen zu können
```
ln -s ~/repos/jekyll_uberspace_deployment/jekyll_uberspace_deployment.sh ~/repos/netzaffe.de.git/hooks/post-receive
```

Last but not least, muss das Skript noch ausführbar gemacht werden:
```
chmod +x post-receive
```

## Das Deployment Skript

Das [uberspace-jekyll-deployment.sh](https://github.com/fl3a/jekyll_uberspace_deployment) Skript 
welches wir als *post-receive Hook*[^1] nutzen findest du auch als Gist auf github.

{% highlight bash linenos %}
#!/bin/bash

# Deployment of Jekyll-Sites on Uberspace 
# via Git Bare Repository and post-receive Hook.
#
# See https://netzaffe.de/jekyll-deployment-auf-uberspace-via-bare-repo-und-post-receive-hook/ 
# for requirements and more detailed description (german)

if [[ $# -eq 1 && $1 == "--cli" ]] 
then
	pushed_branch="NONE" 
else
	read oldrev newrev ref 
	pushed_branch=${ref#refs/heads/} 
fi

## Variables

# Path to your Jekyll Git-Repository 
git_repo=${HOME}/repos/${domain}.git	

# Branch which should be build via this script on post-receive, e.g. 'master'
build_branch='master'			

# Subdomain, e.g. 'sub.' Optional, mind the trailing '.' !
subdomain=''
# Domain, e.g. 'example.com'.
domain='netzaffe.de'			

# Path to document root, destination where the the generated html is served.
www=/var/www/virtual/${USER}/${subdomain}${domain}

## Do the magic
 
[[ "$pushed_branch" != "$build_branch" && "$pushed_branch" != "NONE" ]] && exit
tmp=$(mktemp -d)
git clone ${git_repo} ${tmp}
cd ${tmp}
bundle install --path=~/.gem || bundle install --path=~/.gem --redownload
bundle exec jekyll build --source ${tmp} --destination ${www}
rm -rf ${tmp}
exit
{% endhighlight %}

### bundle config set --local path '~/.gem' 

> [DEPRECATED] The `--path` flag is deprecated 
> because it relies on being remembered across bundler invocations, 
> which bundler will no longer do in future versions. 
> Instead please use `bundle config set --local path '~/.gem'`, and stop using this flag 

### Anpassungen der Variablen

Im Skript sind nur 3 Variablen anzupassen (sofern alles wie oben beschrieben umgesetzt wurde ;-D).

Kopiert *deploy.conf* in euer Repo und passt die folgenden Variablen nach euren Bedürfńissen an:

1. `build_branch`, **der** Branch der für das Deployment genutzt werden soll. 
 Andere Zweige werden ignoriert. Hier `master`.
2. `site` die Site bwz. die Domain. Hier `netzaffe.de`
3. `site_prefix`, Optionaler Prefix bzw. Subdomain, der der Variablen site vorangestellt wird. Hier `sandbox.`. 

### Beschreibung des Skipts 

Die anderen Variablen werden aus den oben angepassten und/oder Umgebungsvariablen[^6] zusammengesetzt.

* `git_repo`, Pfad, wo die Bare-Repo[^2] liegt, 
es fließt die Umgebungsvariable[^5] *HOME* und die Variable *site* mit ein.
* `tmp`, hier wird unser Bare-Repo[^2] temporär *hin-ge-clon-ed*, 
um als Quelle für die Generierung des statischen HTML für die Site zu dienen.
Es fließen die Umgebungsvariablei[^6] *HOME* und die Variable *site* mit ein.
* `www`, das Verzeichnis, das letztendlich vom Webserver ausgeliefert wird. 
Es fließen die Umgebungsvariable[^6]] *USER* sowie *site_prefix* und *site* ein.

Das *Do the magic*

1. Überprüfung ob der übertragene- (pushed) und Build-Branch übereinstimmen, ansonsten Abruch.
2. Klonen des Bare-Repos[^2] nach *tmp*
2. Verzeichniswechsel nach *tmp*
3. Installation der im Gemfile spezifizierten Abhängigkeiten via `bundle install`[^4]
4. Generierung der HTML von *tmp* nach *www* via `jekyll build` 
5. Löschen von *tmp*
6. Beendigung des Skripts

## Vorbereitungen im lokalen Git-Repository

Das waren die Schrite auf deinem Uberspace, weiter gehts in deinen Repo.

Das oben erstellte Bare-Repository fügst du deinem Repo als sog. Remote-Repository[^3] Namens *uberspace* hinzu:
```
git remote add uberspace fl3a@bellatrix.uberspace.de:repos/netzaffe.de.git
```

Fertig, jetzt noch der push vom *master* nach *uberspace*.

```
git push uberspace master
```

Nach der Übertragung der Daten solltest du die Ausgaben von `bundle install` und `jekyll build` sehen.

Dieses Howto bezieht sich auf Uberspace 6, für Anmerkungen, Ideen und Feedback (nicht nur zu Uberspace 7) würde ich mich freuen!

## Credits

Dieser Artikel basiert im wesentlichen auf [Jekyll Auf Uberspace Mit Git](https://www.wittberger.net/post/jekyll-auf-uberspace-mit-git/) 
und [Jekyll Auf Uberspace](https://lc3dyr.de/blog/2012/07/22/Jekyll-auf-Uberspace/). Danke!

Der Artikel ist eine Essenz, die sich nur auf das Deployment bezieht. 
Zudem ist er aktualisiert (seit 2012, 2013 hat sich einiges in Jekyll und auf Uberspace etc getan) 
und das Skript hat noch etwas Liebe erfahren. 

---

[^1]: [Git auf einen Server bekommen](https://git-scm.com/book/de/v1/Git-auf-dem-Server-Git-auf-einen-Server-bekommen), [What is a bare git repository?](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)

[^2]: [What are Git hooks?](https://githooks.com/), [Git individuell einrichten - Git Hooks](https://git-scm.com/book/de/v1/Git-individuell-einrichten-Git-Hooks) 

[^3]: [Git Grundlagen - Mit externen Repositorys arbeiten](https://git-scm.com/book/de/v1/Git-Grundlagen-Mit-externen-Repositorys-arbeite), [man git-remote](https://git-scm.com/docs/git-remote)

[^4]: [Gems, Gemfiles and the Bundler](https://learn.cloudcannon.com/jekyll/gemfiles-and-the-bundler/)

[^5]: [Uberspace Wiki: Webserver](https://wiki.uberspace.de/webserver)

[^6]: [Linux/UNIX Umgebungsvariablen](https://linuxwiki.de/UmgebungsVariable)
[^redownload]: [How do I force Bundler to reinstall all of my gems?](https://stackoverflow.com/questions/45290135/how-do-i-force-bundler-to-reinstall-all-of-my-gems)

---
last_modified_at: 2023-10-03
date: 2010-03-13 17:26
tags:
- Debian
- Security
- howto
- Git
- Drupal
layout: post
permalink: /git-gitosis-gitweb-the-debian-way.html
image: /assets/imgs/1024px-Git-logo-2007.svg.png
title: Git, Gitosis, Gitweb (the Debian way)
---
<figure role="group">
  <img src="/assets/imgs/1024px-Git-logo-2007.svg.png" alt="git logo" />
  <figcaption>Git-Logo, Git, CC BY 3.0</figcaption>
</figure>

Howto: Installation und Konfiguration von Git, Gitosis und Gitweb unter Debian (getestet mit Debian 5/Lenny).

  - [Git](http://git-scm.com/) ist ein DVCS, welches 2005 von Linus
    Thorvalds  
    als Alternative zum vorher genutzten proprietären BitKeeper für die
    Quellcode-Verwaltung des Linux-Kernels entwickelt wurde.
  - [Gitosis](http://eagain.net/gitweb/?p=gitosis.git) ist eine Software
    um Git-Repositories einfach und sicher zu hosten.  
    Die Authentifizierung an gitosis erfolgt über SSH-Schlüssel.
  - [Gitweb](http://git.wiki.kernel.org/index.php/Gitweb) ist eine
    schnelle und skalierbare Weboberfläche für Git.

Das folgende Setup erstreckt sich über 3 Rechner:

1. *birgit*, das zentrale Repository welches über gitosis verwaltet wird und die Gitweb Weboberfläche bereitstellt
2. *demine*, eine lokale Entwicklungsumgebung
3. *sandy*, noch ein lokale Entwicklungsumgebung

Warum man seinen Code versionieren sollte, müsste eigentlich jedem
Entwickler klar sein, [dass Drupal in Zukunft auf Git setzen wird](http://groups.drupal.org/node/48818#comment-133893), dürfte wohl
der Anreiz für Drupalentwickler sein sich frühzeitig mit dem Thema Git zu auseinanderzusetzen.<!--break-->

* toc
{:toc} 

**Hätte, würde, wäre** 

Hätte ich an der [Session von Daniel und Eugen über Git](http://drupaletics.de/sessions/git-versionskontrolle-die-spass-macht),
die meiner Meinung nach eine der besten Session auf dem [DrupalCamp Essen](http://drupaletics.de/) 
war einen Monat früher teilgenommen,  
hätte ich Gitoltite bei unserem jetzigen Projekt eingesetzt und dieses
Howto würde eben von Gitolite handeln...  

...wäre besser, da gitolite unter anderem Berechtigungen auf
Branch-Ebene vergeben kann...

## Installation und Einrichtung von Gitosis

Installation von git, gitosis und gitweb über aptitude als Benutzer
*root* auf *birgit*, unserem späteren Git-Server:

```
aptitude install git-core gitosis gitweb
```

Bei der Installation von *gitosis* wird unter Debian der Systembenutzer
*gitosis* mit */srv/gitosis* als Heimatverzeichnis angelegt.

Auf *demine* ein SSH-Schlüsselpaar für den Benutzer Florian erstellen:

```
ssh-keygen -t rsa
```

Öffentlichen Schlüssel auf den Server *birgit*, der später als zentrales
Repository bzw. Git-Server fungieren soll kopieren:

```
scp .ssh/id_rsa.pub birgit:/tmp
```

Den Gitosis-Dienst auf birgit mit dem eben kopiertem Public-Key initialisieren:

```
sudo -H -u gitosis gitosis-init < /tmp/id_rsa.pub
```

Dies erzeugt die folgende Ausgabe:

```
Initialized empty Git repository in
/srv/gitosis/repositories/gitosis-admin.git/  
Reinitialized existing Git repository in
/srv/gitosis/repositories/gitosis-admin.git/
```

Durch die Initialisierung sind in */srv/gitosis* die folgenden
Verzeichnisse entstanden:

1.  */srv/gitosis/repositories*, welches die von *gitosis* verwalteten
    Repositories beinhaltet, es enthält bereits *gitosis-admin.git*, das
    Repository, welches zur Verwaltung von *gitosis* selbst dient.
2.  */srv/gitosis/gitosis/*, welches die noch leere Datei
    *projects.list* enthält, die in den nächsten Schritten pro Zeile
    durch Leerzeichen getrennt Repository und Eigentümer enthalten wird.

Als Benutzer *florian* auf *demine* das Repository jetzt ge-clone-ed werden:

```
git clone gitosis@birgit:gitosis-admin.git
```

Das durch das Klonen entstandene Verzeichnis *gitosis-admin/* hat den
folgenden Inhalt:

  - *gitosis.conf*, die zentrale Konfigurationsdatei für gitosis
  - Das Verzeichnis *keydir*, welches die öffentichen Schlüssel zur
    Authentifizierung an gitosis enthält.  
    Durch die Initialisierung von gitosis ist in *keydir* bereits der
    öffentiche Schlüssel *florian@demine.pub* vorhanden.

### SSH Port und GIT URLS

**Achtung!** Falls auf dem Server, auf dem Gitosis und somit in unserm Fall auch SSH läuft
einen Non Default Port verwendet wird, also nicht Port 22,
so ändert sich die in den folgenden Schritten die Git-URL.

In unserem Fall wird

```
gitosis@birgit:${REPOSITORY}.git
```

zu

```
ssh://gitosis@lbirgit:${PORT}/${REPOSITORY}.git
```

Beispielhaft für das Repository gitosis-admin mit einem SSHD welcher auf Port 1337 lauscht:

```
ssh://gitosis@lbirgit:1337/gitosis-admin.git
```

Mehr zu **Git URLS** findet sich in der Manpage zu `git-clone`.

## Der Gruppe gitosis-admin einen neuen Benutzer hinzufügen

Damit der neue Benutzer, hier sandra@sandy später selbständig weitere Repositories anlegen kann
muss sie Mitglied in der Gruppe *gitosis-admin* werden.

Auf Rechner demine als Benutzer Florian, die Datei *gitosis.conf* im bereits geklonten gitosis-admin Resopitory bearbeiten, 
um in der members Direktive von `[group gitosis-admin]` den Benutzer `sandra@sandy` hinzufügen:

```
[group gitosis-admin]
writable = gitosis-admin
members = florian@demine sandra@sandy
```

Anschließend, ein Commit mit aussagekräftiger Commit-Message (`-m`)...

```
git commit -a -m "Added 'sandran@sandy' to group gitosis-admin."
```

Output:

```
Created commit 819f0f0: Added 'sandra@sandy' to group gitosis-admin.
 1 files changed, 1 insertions(+), 1 deletions(-)
```

...und ein push um den Commit auf den Server zu übertragen:

```
git push
```

Output:

```
Counting objects: 6, done.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 534 bytes, done.
Total 4 (delta 1), reused 0 (delta 0)
To gitosis@birgit:gitosis-admin.git
   b2240d3..819f0f0  master -> master
```


## SSH-Public-Key für neuen Benutzer hinzufügen

Zuerst muss wieder für den jew. Benutzer ein SSH-Key angelegt werden, 
damit sich der Benutzer über diesen Key an Gitiosis anmelden kann.

Als Benutzer Sandra auf sandy:

```
ssh-keygen -t rsa
```

Defaults übernehmen

Falls Windows Rechner als Clients verwendet werden sollen,
hilft **PuttyGen** von der [Putty Downloadseite](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) bei der Erstellung des SSH-Public-Keys.

Hier muss ggf. nach der öffentliche SSH-Schlüssel in ein für OpenSSH verständliches Format konvertiert werden.

```
ssh-keygen -i -f is_rsa.pub > id_rsa2.pub
```

Benutzer Sandra lässt Florian den ihren öffentlichen SSH-Schlüssel *id_rsa2.pub* für die weiteren Schrite zukommen z.B. via Mail.

Weiter im Kontext mit Florian auf demine, der den Key nach dem Schema a *user@host.pub* umbenennt 
und nach keydir verschiebt (**Achtung: Der Key muss die Dateiendung .pub haben!**)

```
mv /tmp/id_rsa2.pub gitolite-admin/keydir/sandra\@sandy.pub
```

Die Datei sandra@sandy.pub in das das *keydir* Verzeichnis des *gitosis-admin Repositories* aufnehmen:

```
git add keydir/sandra\@sandy.pub
```

Und wieder ein commit...

```
git commit -m "Added Key 'sandra@sandy.pub'."
```

...und wieder ein push, damit die Änderungen auf birgit auch wirksam werden.

```
git push
```

## Neues Repository hinzufügen

Jetzt können wir mit unserem frischgebackenem Admin-User *sandra@sandy* neue Repositories anlegen.

Als Sandra auf sandy, ihrer lokalen Workstation:

gitosis-admin.git auschecken:
```
git clone gitosis@birgit:gitosis-admin.git
```

Da sich Sandra bis jetzt noch nicht mit brigit verbunden hat, muss dem ersten Verbindungsversuch über SSH mit yes zugestimmt werden:
```
Initialized empty Git repository in /home/sandra/gitosis-admin/.git/
The authenticity of host 'birgit (88.198.7.214)' can't be established.
RSA key fingerprint is b4:c0:e6:e9:7c:fa:6b:a4:b1:d0:d2:4c:b5:b7:11:d1.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'birgit,88.198.7.214' (RSA) to the list of known hosts.
```

Wechsel in das soeben geklonte Repository:
```
cd gitosis-admin/
```

Die folgende Sektion, hier examplarisch die Gruppe developers,
die auf das Repo *hongomat* via `writable` Schreibzugriff haben soll, der Datei *gitosis.conf* hinzufügen.
```
[group developers]
writable = hongomat
members = florian@demine sandra@sandy
```

...wieder ein commit:
```
git commit -a -m "Added group "developers" with members 'florian@demine' and 'sandra@sandy' and write access to 'hongomat'."
```

...und wieder ein push:
```
git push
```

## Neues Repository anlegen

Jetzt kann als sandra@sandy ein neues Repository, hier *hongomat* angelegt werden:

Mit `git init` wird das Repository initialisiert, es ist ein initialer Commit nötig.
```
mkdir hongomat
cd hongomat
git init
vi foo
vi bar
git add foo bar
git commit -m 'Initial commit'
```


Bei dem `git remote add` Statement wird mit birgit:hongomat.git das Remote Repository bestimmt.

Siehe SSH Port und GIT URLS bei Abweichung vom SSH-Standard-Port (22).

Der push Befehl schiebt alles in unser zentrales Repository auf brigit.
```
git remote add origin gitosis@birgit:hongomat.git
git push origin master:refs/heads/master
```

## Konfiguraton von gitweb

Einrichtung von gitweb der Weboberfläche für Git.

### /etc/gitweb.conf

Die Konfigurationsdatei für Gitweb,
hier angepasst $projectroot welche auf das Verzeichnis /srv/gitosis/repositories, 
in dem gitosis seine Repos ablegt zeigt.
```
# path to git projects (<project>.git)
# $projectroot = "/var/cache/git";
$projectroot = "/srv/gitosis/repositories";

# directory to use for temp files
$git_temp = "/tmp";

# target of the home link on top of all pages
#$home_link = $my_uri || "/";

# html text to include at home page
$home_text = "indextext.html";

# file with project list; by default, simply scan the projectroot dir.
$projects_list = $projectroot;

# stylesheet to use
$stylesheet = "/gitweb.css";

# logo to use
$logo = "/git-logo.png";

# the 'favicon'
$favicon = "/git-favicon.png";
```

### Virtual Host für gitweb anlegen

Auf birgit, die Datei /etc/apache2/sites-available/birgit.example.com mit dem folgendem Inhalt anlegen:
```
<VirtualHost *>
  ServerName birgit.example.com
  ServerAdmin webmaster@example.com
  DocumentRoot /srv/gitosis/repositories
  SetEnv GITWEB_CONFIG /etc/gitweb.conf
  Alias /gitweb.css /usr/share/gitweb/gitweb.css
  Alias /git-logo.png /usr/share/gitweb/git-logo.png
  Alias /git-favicon.png /usr/share/gitweb/git-favicon.png
  ScriptAlias /gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi
  DirectoryIndex gitweb.cgi
</VirtualHost>
```

Da wir in einem verteiltem Team arbeiten und Gitweb aus dem Internet aufrufbar ist,

In unserem Fall ist dies eine Atrium Installation, in der jeder Entwickler ein Benutzerkonto besitzt.

### Leserechte für den Webserver-Prozess

Damit der Webserver auch die Repositories in Gitweb anzeigen kann,
habe ich den Benutzer gitosis der Gruppe www-data hinzugefügt.

Als root:
```
usermod -g www-data gitosis
```

## Git personalisieren
  
Befehl: git config
```
git config --global user.name "Florian Latzel"
git config --global user.email "floh@netzaffe.de"
```

Git-Konfigurationsdateien: /etc/gitconfig, ~/.gitconfig, .git/config

Auswertungsreihenfolge:

1. `/etc/gitconfig` - Systemweite Git-Konfigurationsdatei
2. `~/.gitconfig` - Benutzerweite Git-Konfigurationsdatei
3. `.git/config` - Projektspezifische Git-Konfigurationsdatei im jeweiligen Repository

Rudimentär, nur Name und EMail nach Eingabe des obigen git config Befehls. 
Die `--global` Option bewirkt das Schreiben nach *~/.gitconfig*, ohne diese Option wäre es *.git/config*. 

Nach dem abesetzen der beiden git config Befehle hat die Datei *~/.gitconfig* den folgende Inhalt:
 
```
[user]
     name = Florian Latzel
     email = floh@netzaffe.de
```

Umgebungsvariable `$EDITOR` Variable anpassen, 
um z.B. Commit-Messages direkt mit dem gewüschten Editor schreiben zu können, 
falls man sich die m-Option beim git commit weglässt.  `export EDITOR='vim'`.

- [man (1) git-config](http://kernel.org/pub/software/scm/git/docs/git-config.html)
- [Git Status im BASH Prompt](http://www.andrewvos.com/2011/07/25/showing-git-status-in-your-bash-prompt)
- [Farbige Prompterstrings](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)

##  Weiterführende Links zu Git

**Git**

- [Git Homepage](http://git-scm.com/)
- [Git for the lazy](http://www.spheredev.org/wiki/Git_for_the_lazy#Linux)
- [gittutorial(7) Manual Page (das offizielle Git-Tutorial)](https://mirrors.edge.kernel.org/pub/software/scm/git/docs/gittutorial.html)
- [Video: Tom Preston-Werner, Chris Wanstrath and Scott Chacon — Git, GitHub and Social Coding](https://www.youtube.com/watch?v=rsnodzi2ULM)
- [Chaosradio Express Podcast: DVCS - Distributed Version Control Systems](https://cre.fm/cre130-verteilte-versionskontrollsysteme)
- [man 5 githooks](http://www.kernel.org/pub/software/scm/git/docs/githooks.html)

**Gitosis**

- [example.conf (gitosis.conf)](https://github.com/res0nat0r/gitosis/blob/master/example.conf)
- [Hosting Git repositories, The Easy (and Secure) Way](http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way/)

**Gitolite**

- [Gitolite](http://gitolite.com/gitolite/index.html)
- [Git auf dem Server - Gitolite](https://git-scm.com/book/de/v1/Git-auf-dem-Server-Gitolite)

**Gitweb**

- [Gitweb](http://git.wiki.kernel.org/index.php/Gitweb)
- [Gitweb README](https://repo.or.cz/w/alt-git.git?a=blob_plain;f=gitweb/README)

**Git-GUI's und -Clients**

- [Egit (Eclipse Plugin)](http://www.eclipse.org/egit/)
- [Egit User Guide](http://wiki.eclipse.org/EGit/User_Guide)
- [Git for windows (ehemals msysgit)](https://gitforwindows.org/)
- [TortoiseGit (Windows)](https://tortoisegit.org/)
- [gitg (gtk+/GNOME)](https://wiki.gnome.org/Apps/Gitg/)
- [gitk - The git repository browser](https://www.git-scm.com/docs/gitk/1.7.2)
- [tig - Text-mode interface for git](https://github.com/jonas/tig)

**Git und Drupal**

- [Evaluation discussion for how to move Drupal.org off of CVS](https://groups.drupal.org/node/48818)
- [Daniel Wehner: Git für Drupal.org](https://web.archive.org/web/20100613043932/http://freeblogger.org/blog/dereine/2010-02-17-git-f%C3%BCr-drupalorg)


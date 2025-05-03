---
tags:
- howto
- Git
- Debian
- config
- Linux
permalink: "/howto-setup-gitolite-on-debian-wheezy.html"
layout: post
title: 'Howto: Setup Gitolite on Debian Wheezy'
created: 1354361320
last_modified_at: 2019-05-30
---
Installation von gitolite (2.3-1) auf Debian Wheezy/unstable.

* toc
{:toc}
<!--break-->

## Erzeugung eines SSH-Kepairs
```
ssh-keygen  -t rsa
```
```
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
e0:90:34:92:d8:e1:08:fc:24:45:b5:17:5a:0d:c9:2b root@git
The key's randomart image is:
+--[ RSA 2048]----+
|oo==+..++        |
|o=o+ o+o..       |
|. = oo...        |
|   . E.o         |
|      o S        |
|                 |
|                 |
|                 |
|                 |
+-----------------+
```

## Installation von gitolite
```
apt-get install gitolite
```
```
Paketlisten werden gelesen... Fertig
Abhängigkeitsbaum wird aufgebaut.       
Statusinformationen werden eingelesen.... Fertig
Die folgenden zusätzlichen Pakete werden installiert:
  git git-man libcurl3-gnutls liberror-perl librtmp0 libssh2-1 rsync
Vorgeschlagene Pakete:
  git-daemon-run git-daemon-sysvinit git-doc git-el git-arch git-cvs git-svn git-email git-gui gitk gitweb
Die folgenden NEUEN Pakete werden installiert:
  git git-man gitolite libcurl3-gnutls liberror-perl librtmp0 libssh2-1 rsync
0 aktualisiert, 8 neu installiert, 0 zu entfernen und 0 nicht aktualisiert.
Es müssen 8.920 kB an Archiven heruntergeladen werden.
Nach dieser Operation werden 16,9 MB Plattenplatz zusätzlich benutzt.
göchten Sie fortfahren [J/n]? 
[...]
No adminkey given - not setting up gitolite.
```

## Konfiguration von Gitolite
Da sich die Installation mit <strong>"No adminkey given - not setting up gitolite."</strong> verabschiedet, stoßen wir die Konfiguration manuell an...
```
dpkg-reconfigure gitolite
```
...und landen in einem NCurses-Dialog: 

### Gitolite Systemnutzer

```
Bitte geben Sie einen Namen für den Systemnutzer ein, der von gitolite verwendet werden soll, um auf die Repositorys zuzugreifen. Er wird falls  

Name des Systemnutzers für gitolite:
```

Hier behalten wir die Voreinstellung:
```
gitolite
```

### Repository-Pfad
```
Bitte geben Sie den Pfad ein, in dem gitolite die Repositorys speichern soll. Dies wird zum Heimatverzeichnis des Systemnutzers.  

Repository-Pfad:
```

Auch hier nutzen wir den Default:
```
/var/lib/gitolite
```

### Gitolite Admin Key
```
Bitte geben Sie den Schlüssel eines Nutzers an, der die Zugriffskonfiguration von gitolite administrieren wird.                                  
                                                                                                                                                        
Dies kann entweder der öffentliche SSH-Schlüssel selbst sein oder aber der Pfad zu einer Datei, die ihn enthält. Falls dies leer gelassen wird,     
bleibt gitolite unkonfiguriert und muss manuell aufgesetzt werden.                                                                                   
                                                                                                                                                        
SSH-Schlüssel des Administrators:                                                       
```

Hier geben wir den Pfad zum öffentlichen SSH-Schlüssel, den wir oben erzeugt haben an:
```
/root/.ssh/id_rsa.pub
```

```
creating gitolite-admin...
Initialized empty Git repository in /var/lib/gitolite/repositories/gitolite-admin.git/
creating testing...
Initialized empty Git repository in /var/lib/gitolite/repositories/testing.git/
[master (root-commit) c3ee4ee] start
 2 files changed, 6 insertions(+)
 create mode 100644 conf/gitolite.conf
 create mode 100644 keydir/admin.pub
```

## Klonen des Admin-Repositoires
Zu Abweichungen zum Standard-SSH wie hier,
habe ich bereits  <a href="/node/990">SSH Port und GIT URLS</a> geschrieben.
```
git clone ssh://gitolite@git.example.com:1337/gitolite-admin 
```

```
Cloning into 'gitolite-admin'...
The authenticity of host '[git.example.com]:1337 ([127.0.1.1]:1337)' can't be established.
ECDSA key fingerprint is 54:89:8b:b9:9b:e8:ef:22:31:06:2e:fa:01:a0:80:07.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[git.example.com]:1337' (ECDSA) to the list of known hosts.
remote: Counting objects: 6, done.
remote: Compressing objects: 100% (4/4), done.
Receiving objects: 100% (6/6), 712 bytes, done.
remote: Total 6 (delta 0), reused 0 (delta 0)
```

## Struktur des Admin-Repositories
```
gitolite-admin/
├── conf
│   └── gitolite.conf
└── keydir
    └── admin.pub
```

## Weiterführend
<ul>
 <li><a href="http://gitolite.com/gitolite/master-toc.html">gitolite documentation</a></li>
<li><a href="http://sitaramc.github.com/gitolite/write-types.html">different types of write operations</a></li>
 <li><a href="http://eosrei.net/blog/2012/01/one-conf-repo-gitolite-using-include">One conf per repo in Gitolite using include </a></li>
 <li><a href="http://sitaramc.github.com/gitolite/syntax.html">gitolite.conf Syntax</a></li>
 
</ul>

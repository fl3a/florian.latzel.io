---
title: Dotfiles managen mit Git und GNU Stow 
layout: post
tags:
- howto
- config
- git
- Linux
- vimrc
---
Als ich letztes Wochenende den Talk über Dotfiles verwalten[^fc23] auf der Frocon 2023 
habe ich das erste von [GNU Stow][stow] erfahren.
Danach habe ich direkt eine Suche angestoßen 
und bin auf den Artikel von Brandon Invergo[^st1] gestoßen.

Stow beschreibt sich als *symlink farm manager*, 
welcher gerne auch als zuverlässiges 
und bequemes Werkzeug zur Verwaltung von Dotfiles verwendet wird.

**Inhalt**
- Inhalt
{:toc}

## Was sind Dotfiles?

> Home is where your dotfiles are!

Als Dotfiles bezeichnet Dateien (und Verzeichnisse) mit vorangestellten `.`
im Namen, die Konfigurationen beziehungsweise Einstellungen für Programme.

## Installation von GNU Stow

Installation von [GNU Stow][stow]* unter Debian (und Derivaten wie z.B. Ubuntu):

    sudo apt install stow

Oder unter macOS via *brew*:

    brew install stow

Auch das Kompilieren aus den Quellen auf Uberspace hat auf anhieb funktioniert.
Auf NetBSB (9.1 und 10.0) bin ich an der Kompilation verzweifelt.
Dort hat jedoch das Kopieren der Dateien aus dem Paket von 
<https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/sysutils/stow/index.html>
funktioniert.

## Das Dotfile Repository

Stow nimmt per Default immer das übergeordnete Vereichnis als Target[^term]. 
Von daher ist es sinnvoll *.dotfiles* direkt in Home zu haben.

    git clone git@github.com:fl3a/dotfiles.git ~/.dotfiles
^
    cd ~/.dotfiles

Werfen wir mal ein Blick in das Dotfile Repository (siehe unten):

- Es gibt die typischen Indikatoren für Git-Repos: .git/, .gitignore 
und eine README.md 
- Daneben liegen die sogenannten *Packages*[^term] bombadillo, git, irssi, stow, vim und zsh.
- Besonders anschaulich ist beim Package irssi mit seinen Dateien
und weiterer Unterverzeichnissen (wobei die Dateien 
und der Symlink unter scripts und autorun nur symbolisch dargestellt sind.).
- Selbst stow hat ein Package,
das wiederrum seine eigene [Stow Konfiguration](#konfiguration-von-stow) beinhaltet.

```
home/florian/.dotfiles
├── bombadillo
│   └── .bombadillo.ini
├── .git
│   └── [...]
├── git
│   ├── .gitconfig
│   └── .gitignore_global
├── .gitignore
├── irssi
│   └── .irssi
│       ├── config
│       ├── default.theme
│       ├── irc.prison.net.crt
│       └── scripts
│           ├── autorun
│           │   └── [...] -> ../[...]
│           └── [...]
├── README.md
├── stow
│   ├── .stow-global-ignore
│   └── .stowrc
├── vim
│   └── .vimrc
└── zsh
    └── .zshrc
```

## Arbeiten mit GNU Stow

Du kannst verschiedene Mengen an Packages *"stowen"*: 

- Für ein Package, beispielsweise vim `stow vim`
- Für mehrere Packages,  `stow vim zsh irssi`
- Für alle Packages: `stow */`

Probe aufs Exempel mit dem einen Package, hier wie oben mit dem vim Package:
   
    ls -la ~/.vimrc

Voila, Symlink da!

    lrwxrwxrwx 1 florian florian 19  6. Okt 22:44 /home/florian/.vimrc -> dotfiles/vim/.vimrc

Falls ein Target[^term] bereits besteht (und nicht explizit die `--override=REGEX` 
Option verwendet wird), dann meckert stow das an und quittiert seinen Dienst. 


    WARNING! stowing irssi would cause conflicts:
      * existing target is neither a link nor a directory: .irssi/config
    All operations aborted.

Es ist möglich, den Konflikt aufzulösen, in dem die Datei in das stow Package
mit `--adopt`[^sao] importiert wird. 
Hier mit zusätzlichen Verbose, um genauer zu sehen was dann passiert: 

    stow irssi --adopt -v 
^
    MV: .irssi/config -> .dotfiles/irssi/.irssi/config

Jetzt kann das VCS übernehemen.

### Konfiguration von Stow

### Ignore-Lists

[^ign]

### Resource-Files

[^rc]

## Fazit

Als ich das mich das letzte mal mit Dotfiles beschäftigt habe,
standen einige große Fragen noch im Raum. 
Die wichtigste war, 
wie bekomme ich die Syncronisierung zwischen den Dotfiles im Repository und $HOME hin?
Welches der vielen Tools[^dfu] soll ich denn dafür nutzen?
Wie umfangreich sind Die, wie kompliziert ist deren Bedienung,
wie sieht es mit der Portabilität aus
und wieviel Abhängigkeiten handle ich mir damit rein?
Vielleicht doch lieber direkt selber skripten oder Makefile schreiben?

Der Ansatz mit Stow hat mir gefallen
Symlink farm manager




**Fußnoten**


[^fc23]: [froscon 2023 -- Dotfiles verwalten,  Christoph Stoettner (stoeps)](https://media.ccc.de/v/froscon2023-2907-dotfiles_verwalten)
[^dfu]: [General-purpose dotfiles utilities](https://dotfiles.github.io/utilities/)
[^st1]: <https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html>
[^sao]: [-\-adopt Option (Stow)](https://www.gnu.org/software/stow/manual/stow.html#index-adopting-existing-files)
[^rc]: [Resource Files (Stow)](https://www.gnu.org/software/stow/manual/stow.html#Resource-Files)
[^ign]: [Types And Syntax Of Ignore Lists (Stow)](https://www.gnu.org/software/stow/manual/html_node/Types-And-Syntax-Of-Ignore-Lists.html)
[^term]: [Terminology (Stow)](https://www.gnu.org/software/stow/manual/html_node/Terminology.html)

[stow]: https://www.gnu.org/software/stow/manual/ "stow"

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
Als ich letztes Wochenende den Talk über Dotfiles managen[^df23] auf der Frocon 2023 
habe ich das erste von [GNU Stow](https://www.gnu.org/software/stow/) erfahren.
Danach habe ich direkt eine Suche angestoßen und bin vom Artikel von Marcus[^st1] 
auf den von Brandon Invergo[^st2] gestoßen.

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

Wir installieren *[GNU Stow][stow]* (unter Debian und Derivaten wie z.B. Ubuntu)

    sudo apt install stow

## Voraussetzungen

Ein Remote Repository für deine dotfiles z.B. bei Github oder Gitlab.

## Erzeugung des Dotfile Repositories

Dann legen wir den Ordner *dotfiles* in unserem Home Verzeichnis an,

    mkdir ~/.dotfiles

wechseln hinein...

    cd ~/.dotfiles

und erzeugen darin unser Repository für die Versionierung via Git. 

    git init                                   

Als Beispiel starten wir mit der Überführung von [vim](/themen/vim/)
in Dotfiles Repo.    
Hierzu legen wir den Ordner *vim* an, 
wobei *vim* später auch das sogenannte Package im Stow-Sprech ist.

    mkdir vim

Wir verschieben hier die *vimrc* 

    mv ~/.vim/vimrc vim/.vimrc
^ 
    git add vim 
^
    git commit -m 'Initial commit.'
^
    git remote add origin git@github.com:fl3a/dotfiles.git
^
    git push -u origin main

## Arbeiten mit GNU Stow

    stow vim
^   
    ls -la ~/.vimrc
^
    lrwxrwxrwx 1 florian florian 19  6. Okt 22:44 /home/florian/.vimrc -> dotfiles/vim/.vimrc
^
    stow *
^                              
    stow: ERROR: The stow directory .dotfiles does not contain package README.md
^
    stow */
^
    WARNING! stowing irssi would cause conflicts:
      * existing target is neither a link nor a directory: .irssi/config
    All operations aborted.
^
    stow irssi --adopt -v 
^
    MV: .irssi/config -> .dotfiles/irssi/.irssi/config
^




Stolpersteine

- stow nimmt per Default immer das übergeordnete vereichnis als Target. Von daher ist es sinnvoll *dotfiles* direkt in Home zu haben.

[^df23]: [froscon 2023 -- Dotfiles verwalten,  Christoph Stoettner (stoeps)](https://media.ccc.de/v/froscon2023-2907-dotfiles_verwalten)
[^dfu]: [General-purpose dotfiles utilities](https://dotfiles.github.io/utilities/)
[^dfst1]: <https://www.marcusjaschen.de/blog/2017/gnu-stow-dotfiles-managen/>
[^dfst2]: <https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html>
[^sao]: [Stow Manual --  -\-adopt Option](https://www.gnu.org/software/stow/manual/stow.html#index-adopting-existing-files)
[^src]: [Stow Manual -- Resource Files](https://www.gnu.org/software/stow/manual/stow.html#Resource-Files)

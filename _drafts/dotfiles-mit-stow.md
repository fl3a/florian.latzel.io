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

Symlink farm manager

Wir installieren *GNU Stow* (unter Debian und Derivaten wie z.B. Ubuntu)

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

## Arbeiten mit GNU Stow

    stow vim
^   
    ls -la ~/.vimrc
^
    lrwxrwxrwx 1 florian florian 19  6. Okt 22:44 /home/florian/.vimrc -> dotfiles/vim/.vimrc

Stolpersteine

- stow nimmt per Default immer das übergeordnete vereichnis als Target. Von daher ist es sinnvoll *dotfiles* direkt in Home zu haben.

- [dotfiles - Your unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/)
- https://www.marcusjaschen.de/blog/2017/gnu-stow-dotfiles-managen/
- https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
- [Stow - GNU Project](https://www.gnu.org/software/stow/)
- [Stow has forever changed the way I manage my dotfiles](https://www.youtube.com/watch?v=y6XCebnB9gs)

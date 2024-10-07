---
title: Dotfiles managen mit GNU Stow
layout: post
---

Symlink farm manager

    apt install stow
^
    mkdir ~/dotfiles
^
    cd ~/dotfiles
^
   git init                                   
^
    Leeres Git-Repository in /home/florian/repos/dotfiles/.git/ initialisiert
^
    mkdir vim
^
    mv ~/.vim/ vim/

Datei umbenennen und leeres, nicht benötigtes Verzeichnis löschen

    mv vim/.vim/vimrc vim/.vimrc
    rmdir vim/.vim
^
    git add vim 
^
    git commit -m 'Initial commit.'
^
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

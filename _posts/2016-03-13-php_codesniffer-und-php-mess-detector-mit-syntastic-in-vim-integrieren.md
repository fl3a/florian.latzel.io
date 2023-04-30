---
title: PHP_CodeSniffer und PHP Mess Detector mit Syntastic in Vim integrieren
tags:
- vim
- "<?php ?>"
- howto
- vimrc
- Linux
- Drupal
nid: 1640
image: "/assets/imgs/bad-code-php-vim-syntastic.png"
layout: post
created: 1457865294
---
<figure role="group">
  <img src="/assets/imgs/bad-code-php-vim-syntastic.png" alt="VIM mit Syntastic for PHP  and Drupal development"/>
  <figcaption>Abbildung 1, Vim mit Editor Tab und location list.</figcaption>
</figure>
Bei der [Statischen Code Analyse](https://de.wikipedia.org/wiki/Statische_Code-Analyse) 
(englisch linting), welche den den White-Box-Test-Verfahren zugeordnet ist, 
wird der Quellcode einer Software auf seine Beschaffenheit überprüft.
 
Hierzu gehört z.B. neben dem eigentlichen Linting, in PHP  mit z.B. ```php -l``` 
oder dem Tool <em>phplint</em> die Überprüfung von [Coding-Standards](
https://de.wikipedia.org/wiki/Programmierstil) 
oder das Erkennen von potenziellen Problemem bzw. suboptimalen Code wie z.B. 
ungenutzen Variablen, Properties oder Funktionen, 
zu hoher Komplexität (z.B. in Zusammenhang mit Wartbarkeit) und die Erkennung möglicher Fehler.  

In der Programmiersprache PHP werden hierfür die Werkzeuge [PHP_CodeSniffer](
https://github.com/squizlabs/PHP_CodeSniffer) 
und [PHP Mess Detector](http://phpmd.org/about.html) genutzt, 
welche sich bequem in <acronym title="Integrated Development Envirment">IDE's</acronym> 
wie PHPStorm integrieren lassen. 

Aber wie schaut es mit einem scheinbar betagtem und angestaubtem UNIX-Editor wie dem VIM aus?

Natürlich geht das auch im VIM! Wie zeigt dieser Post.<!--break--> 

Als erstes brauchen wie das Syntax-Check-Plugin [Syntastic](https://github.com/scrooloose/syntastic) 
für VIM, welches wir via Paketmanager unserer Distribution (hier Debian) installieren:

	sudo apt-get install vim-syntastic

Dann brauchen wir noch phpcs, phpmd und phploc, 
unsere eigentlichen Werkzeuge für die Code-Analyse, die wir über composer installieren:

```
composer global require "squizlabs/php_codesniffer=*"
composer global require "phpmd/phpmd"  
composer global require "phploc/phploc" 
```

Unsere über composer installierten Tools sollten sich natürlich im Suchpfad 
für ausführbare Dateien, kurz <em>PATH</em> befinden, 
hierzu dem Startup-File(<em>~/.bashr</em>, <em>~/.zshrc</em>, usw.) 
deiner Shell folgendes Statement verpassen:

	export PATH=$PATH:"/home/florian/.composer/vendor/bin"

Als letztes muss VIM noch konfiguriert werden, hier bearbeiten wir die Datei <em>.vimrc</em> in unserem Home-Verzeichnis mit 

	vi ~/.vimrc

und fügen die folgenden Zeilen am Ende der Datei hinzu:
```
" Syntastic
let g:syntastic_aggregate_errors=1
let g:syntastic_sort_aggregate_errors=1
let g:syntastic_id_checkers=1
let g:syntastic_cursor_column=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_enable_highlighting=1
let g:syntastic_error_symbol='x'
let g:syntastic_warning_symbol='!'
let g:syntastic_mode='active'
let g:syntastic_php_checkers=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map={
\'mode': 'active',
\'active_filetypes': ['php'],
\'passive_filetypes': []
\}
unlet g:syntastic_php_checkers
let g:syntastic_php_checkers = ["php", "phpcs", "phpmd"]
let g:syntastic_php_phpcs_args='--report=csv --standard=my_standard'

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.php call s:syntastic()
  autocmd BufWritePost *.module call s:syntastic()
  autocmd BufWritePost *.install call s:syntastic()
  autocmd BufWritePost *.profile call s:syntastic()
  autocmd BufWritePost *.inc call s:syntastic()
  autocmd BufWritePost *.test call s:syntastic()
augroup END 
function! s:syntastic()
  SyntasticCheck
endfunction
```
<small>Listing 1, ~/.vimrc mit Syntastic Konfiguration für PHP- 
und Dateinamenserweiterungen für die Drupal-Entwicklung</small>

Die Bedienung gestaltet sich jetzt wie folgt:
Die Editor ist jetzt zweigeteilt, s.o. Abbbildung 1, 
oben befindet sich das Editor-Tab, hinzugekommen ist das sog.  
<em>location list</em> unten:
```
  1 UneededHelper.module|7 col 1 error| There must be no blank line following an inline comment [php/phpcs]
  2 UneededHelper.module|15 col 3 error| Whitespace found at end of line [php/phpcs]
  3 UneededHelper.module|16 col 4 warning| @package tag is not allowed in class comment [php/phpcs]
  4 UneededHelper.module|22 error| Avoid unused private fields such as '$foo'. [php/phpmd]
  5 UneededHelper.module|24 col 3 error| Doc comment for parameter \"$bar\" missing [php/phpcs] 
```
<small>Listing 2, <em>location list</em> Beispieleinträge</small>

Im Editor-Bereich sind am linken Rand Indikatoren für Fehler und Warnungen, 
die sog. <em>signs</em> dazugkommen,  
bei mir ```S>```, entweder Rot hinterlegt für Error oder Gelb für Warning. 

Mit CRTL und 2xW springt man von Editorfenster in die location list, 
in der dann mit den Richtungstasten durch die einzelnen Listeneinträge gehen kann, 
ein ENTER lässt dich dann an die entsprechende Stelle in Code springen. 

Nach Behebung eines Listeneintrages im Code und Speichern sollte die Liste nun schrumpfen :D

Danke bro für das Teilen dieses Jedi-Vim-Wissens!

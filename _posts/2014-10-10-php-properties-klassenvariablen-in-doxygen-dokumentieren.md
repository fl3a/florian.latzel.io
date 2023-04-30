---
layout: post
tags:
- "<?php ?>"
- snippet
- howto
- Gut zu wissen
- Drupal
- doxygen
- Entwicklung
nid: '1631'
image: /assets/imgs/doxygen-var-doxygen-notation.png
title: PHP Properties/Klassenvariablen in Doxygen dokumentieren
created: 1412931876
---
Zur Dokumentation von Klassenvariablen, auch  Properties[^1] oder Member genannt
wird in Doxygen[^2] (u.a.) und PHPDoc[^3] (phpDocumentor 2) das Tag `@var`[^4] [^5] verwendet. 

In PHPDoc wird die folgende Notation verwendet, diese wird so auch in Drupals Coding-Standards[^6] beschrieben: 

```php
/** 
 * Passed command line options 
 * @var string 
 */ 
 protected $commandLineOptions; 
```

...welche in Doxygen leider weder mit Typ noch mit dem zusätzlichen Kommentar angezeigt wird. 

<img alt="PHP Member Data Documenation within Doxygen, PHPDoc Notation" src="/assets/imgs/doxygen-var-phpdoc-notation.png" />
<!--break--> 

Um das gewünschte Ergebnis in Doxygen zu erzielen, **muss hinter dem Typ noch redundanterweise der Name der Variablen**[^7] notiert werden...

```php
/** 
 * Passed command line options 
 * @var string $commandLineOptions 
 */ 
protected $commandLineOptions; 
```

Tada, Typ und der optionale Kommentar werden angezeigt.

<img alt="PHP Member Data Documenation within Doxygen, Doxygen Notation, redundanter Variablenname" src="/assets/imgs/doxygen-var-doxygen-notation.png" />

Interessant ist vielleich auch noch _Documenting PHP with Doxygen: The Pros and Cons_[^8].

* * *

[^1]: [PHP Properties](http://php.net/manual/en/language.oop5.properties.php)
[^2]: [Doxygen](http://doxygen.org)
[^3]: [PHPDoc](http://www.phpdoc.org/)
[^4]: [PHPDoc @var Tag](http://phpdoc.org/docs/latest/references/phpdoc/tags/var.html)
[^5]: [Doxygen \var (variable declaration)](http://www.doxygen.nl/manual/commands.html#cmdvar)
[^6]: [Drupals Coding-Standard](https://www.drupal.org/coding-standards/docs#var)
[^7]: [Documenting PHP with Doxygen: The Pros and Cons](http://technosophos.com/2012/02/01/documenting-php-doxygen-pros-and-cons.html)
[^7]: [stackoverflow: How to set member type in Doxygen for PHP code?](http://stackoverflow.com/questions/9125754/how-to-set-member-type-in-doxygen-for-php-code)
[^8]: [Documenting PHP with Doxygen: The Pros and Cons](http://technosophos.com/2012/02/01/documenting-php-doxygen-pros-and-cons.html)

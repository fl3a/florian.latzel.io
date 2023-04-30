---
tags:
- snippet
- "#!/bin/bash"
- nützlich
- Linux
- Entwicklung
- Arrays
nid: 691
permalink: "/arrays-in-der-bash.html"
layout: post
title: Arrays in der Bash
created: 1229244988
---
In der <acronym title="Bourne Again SHell">BASH</acronym> ist es möglich mit eindimensionalen Arrays zu arbeiten: 

```
#!/bin/bash 

declare -a array1 
array1=(zero one two three) 
array1[4]="and four" 
echo ${array1[2]} 
echo ${array1[@]} 
```
In Zeile 3 wird mit <i>declare -a</i> explizit ein Array deklariert.

In Zeile 4 wird mit <i>array1</i> ein Array intitialisiert, 

der Zugriff auf die Elemente erfolgt über den Index des Array(Zeile 5, Zeile 6), 
welcher wie in den meisten Programmiersprachen von 0 bis Anzahl der Elemente - 1 ist (Anzahl Elemente in Zeile 7).

Alternativ kann bei der Initialisierung auch der Index benutzt werden(Zeile 5).

Die Möglichkeit ein assoziatives Array anzulegen, besteht leider nicht.

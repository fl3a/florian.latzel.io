---
title: Installation von postgresql 7.3.3-1 und cygwin 1.3.16-1 unter Win2k
layout: post
date: 2004-12-22 12:19
tags:
- Cygwin
- m$
- PostgreSQL
last_modified_at: 2020-08-08
---
Geschrieben im August 2003 als SOnstige LEIstung, eine Webseite  für das Fach  INTernetprogrammierung während der Zeit am <a href="http://www.bib.de/b.i.b._International_College_Bergisch_Gladbach.aspx">b.i.b.  in Bergisch-Gladbach</a><br/>
<p>Um für die Übungen im Fach DAtenBanken nicht ins Rechenzentum nach  Bergisch Gladbach fahren zu müssen, habe auf meiner lokalen Maschine, damals noch Windows 2000 eine Postgres-Instanz unter Cygwin installiert, hierbei entstand das Shellskript </p>
<p>Während der Überarbeitung dieses Artikel, bin ich darauf gestoßen, daß cygipc mittlerweile Bestandteil von Cygwin ist und es bereits grafische Installer für Windows gibt..</p>

<h2>Was ist PostgreSQL?</h2>
PostgreSQL [<a href="#info">1</a>] ist eine objektrationale Datenbank die auf dem Quellcode von POSTGRES 4.1 basiert, welcher von der Universität von Kalifornien in Berkeley entwickelt wurde.
Es bietet die unterstützt die SQL-Standards SQL92 und SQL99, Views, Subqueries, Trigger, referenzielle Intigrität, und Transaktionen.
Da Postgres meistens auf Unix oder Unixähnlichen Systemen anzutreffen ist, geht es hier mit Cygwin weiter...<br/>
<h2>Was ist Cygwin?</h2>
Cygwin [<a href="#info">2</a>] ist laut <a href="http://www.cygwin.com/">Definition</a>: GNU + Cygnus + Windows = cygwin<br/>
Cygwin ist eine von Red Hat entwickelte UNIX-Umgebung für Windows bestehend aus der cygwin1.dll,<br/>
die als UNIX-Emulationsschicht eine UNIX-API bereitstellt und einer Ansammlung von Tools die ein UNIX-artiges Look-and-Feel bereitstellen.<br/>
Kurz: eine Unix-Umgebung und die Schnittstelle zu PostgreSQL auf Windows<br/>
<br/>
<h2>Beweggründe zur Installation</h2>
Mit Cygwin stehen euch die GNU-Compiler-Collection, Editoren wie VIm, Client- und Server-Anwendungen wie X, SSH und PostgreSQL 
und jede Menge Tools und Portierungen wie zum Beispiel Irssi oder Nmap zur Verfügung die euch keine DOS-Box bieten kann.<br/>
Zudem besteht die  Möglichkeit für Win32 Konsolen- und GUI-Programme zu erstellen 
und UNIX- oder GNU-Programme zu portieren. 
Cygwin ist vielleicht <b>der Einstieg</b> für all jene die mit Linux auseinandersetzen wollen<br/>
aber (noch) nicht auf Windows verzichten wollen oder für all jene die auch unter Windows nicht auf eine bash verzichten möchten. Aber</b> es ist <b>kein</b> Ersatz zu zu UNIX&reg; und UNIX-Derivaten, wie zum Beispiel Linux oder BSD.<br/>
Falls Ihr einfach nur eine vernünftige Datenbank zu Hause laufen lassen wollt
sind nicht besonders viele Packete nötig:<br/>
  <ul>
   <li>cygwin 1.3.16-1</li>
   <li>postgresql 7.3.3-1</li>
   <li>cygrunsrv</li>
   <li>bzip2</li>
   <li>tar</li>
   <li>cygipc 1.14-1 [<a href="#info">3</a>]</li>
  </ul>
  zum Programmieren optional noch:
  <ul>
   <li>gcc</li>
   <li>libncurses</li>
   <li>libreadline</li>
   <li>perl</li>
   <li>readline</li>
   <li>crypt</li>
   <li>zlib</li>
   <li>Sun JDK</li>
   <li>ANT</li>
  </ul>
Da Windows die Verwaltung der Speicherblöcke und Semaphoren
nicht unterstützt muss cygipc 1.14-4 installiert werden4.
Generell ist sinnvoll stets die neuste Version von cygipc zu benutzen.<br/>
Im Gegensatz zu den Windows9x-Versionen gibt es bei
NT und 2000 Benutzterverwaltung
und die Möglichkeit Dienste einzurichten. 
Unter XP-Home braucht Ihr noch Für das Zusammenspiel Benutzer/Dienst noch die NT-Rechtevergabe ntrights.zip [<a href="#info">4</a>]<br/><br/>
Bei der eigentlichen Installation der Datenbank, empfehle ich,
man halte sich an das postgresql-7.3.3.README [<a href="#info">5</a>] von Jason Tishler.<br/>
Für eine Installation von PostgreSQL-7.3.3 mit Cygwin-1.3.16-1 unter Windows2000
habe ich für eilige ein entsprechendes Skript [<a href="#info">8</a>]
geschrieben, das PostgreSQL als Dienst einrichtet, sollte auch unter XP-Professional laufen habe ich aber noch nicht getestet.
dafür  sollte sich cygipc 1.14-1 im Cygwin Root Verzeichnis befinden.
ggf. solltet Ihr das Skript mit chmod 700 ausführbar machen
Das Skript sollte vom Benutzter Administrator aufgerufen werden
 <br/>
weiterführende Links:<br/>
 <a href="http://netzaffe.de/taxonomy/term/3">Links zu Cygwin</a><br/>
 <a href="http://netzaffe.de/taxonomy/term/27">Links zu PostgreSQL</a><br/> 
 <a href="" title="http://netzaffe.de/taxonomy/term/9">Links zu PostgreSQL on Windows</a><br/>
<br/>
<br/>
<a name="info"></a>  
Informationen:<br/>
<a href="http://www.postgresql.org/" title="www.postgresql.org">[1] PostgreSQL</a><br/>
 <a href="http://www.cygwin.com/" title="http://www.cygwin.com">[2] Cygwin</a><br/> 
 <a href="http://cygutils.fruitbat.org/" title="http://cygutils.fruitbat.org/">[3] cygipc 1.14-1</a><br/>
 <a href="http://www.dynawell.com/reskit/microsoft/win2000/ntrights.zip" title="http://www.dynawell.com/reskit/microsoft/win2000/ntrights.zip">[4] ntrights.zip:</a><br/>
 <a href="http://www.tishler.net/jason/software/postgresql/postgresql-7.3.3.README" title="http://www.tishler.net/jason/software/postgresql/postgresql-7.3.3.README">[5] postgresql-7.3.3.README</a><br/>
 <a href="/node/515" title="">[6] install_postgres0.07.bz2</a>

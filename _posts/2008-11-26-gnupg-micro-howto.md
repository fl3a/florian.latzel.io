---
date: 2008-11-26 07:43
last_modified_at: 2023-05-06 09:19 
tags:
- howto 
- gpg 
- Datenschutz 
- Sicherheit 
- Verschlüsselung 
- Linux 
- uberspace
layout: post
permalink: /gnupg-micro-howto.html
title: GnuPG Micro Howto
image: /assets/imgs/gnupg/gnupg-logo.png
---
{% responsive_image figure: true path: assets/imgs/gnupg/gnupg-logo.png 
alt: "GnuPG Logo" caption: "GnuPG Logo, Thomas Wittek, GnuPG Projekt, Gemeinfrei" %}

*Gnu Privavy Guard* oder GnuPG (gpg)  ist eine freie Kryptographiesoftware, 
die das *OpenPGP Message Format* gemäß *RFC 4880[^rfc4880]* implementiert.
GnuPG ist unter Windows ([Gpg4win](https://www.gpg4win.org/)), 
Android ([OpenKeychain](https://www.openkeychain.org/)), MacOS ([GPG Suite](https://gpgtools.org/)) 
und Linux (dort meistens per Default an Board) sowie anderen unixioden System verfügbar. 

Die primären Anwendungsgebiete von GnuPG sind die Sicherstellung von Integrität
beziehungsweise vertraulicher digitaler Kommunikation und Privatsphäre.
Beispiele für Sicherstellung von Integrität sind signierte Emails,
signierte Softwarepakete wie z.B. unter Debian[^secure-apt] 
oder signierte Git[^git-gpg] Commits[^gh-sign-commit] und Tags/Releases[^gh-sign-tag] auf wie Github,
durch die man Echtheit und Quelle überprüfen kann.
Das wohl bekannteste Beispiel für die Sicherstellung von digitaler Privatsphäre 
ist neben dem Ver- und Entschlüsseln von Dateien die verschlüsselte Emailkommunikation

Dieses Howto beschreibt unter anderem die [Erstellung eines GnuPG Schlüsselpaares](
#erstellung-eines-gnupg-schlüsselpaares), 
das [Hinzufügen weiterer Emailadressen als Unterschlüssel](
#unterschlüssel-mehrere-emailadressen-mit-einem-gpg-key-nutzen),
die [Konfiguration von GnuPG](#konfiguration-von-gnupg)
und des GPG-Agents,
der [Einrichtung eines Web Key Directories (WKD Direct Method)](#wkd-einrichten) 
und gebräuchliche Anwendungsfälle auf der Kommandozeile (gpg), 
wie z.B. dem [Arbeiten mit Keyservern](#arbeiten-mit-keyservern)[^4].    
Es ist auf die oben genannten Systeme übertragbar.<!--break-->

Inhaltverzeichnis
* toc
{:toc}

## Konzept und Terminologie

GnuPG verwendet das sog. Public-Key-Verschlüsselungsverfahren[^1], 
das heißt, dass es 2 Arten von Schlüssel gibt, 
Öffentliche- (Public Keys)[^2] und Private Schlüssel (private Keys)[^3]. 
Jeder Schlüssel hat sein dazugehöriges Gegenstück, allgemein als Schlüsselpaar bezeichnet.

Der öffentliche Schlüssel wird zum Verschlüsseln 
und zur Überprüfung von Signaturen genutzt 
und muss deinem Kommunikationspartner zur Verfügung stehen, 
damit er diese Aktionen ausführen kann. 
Öffentliche Schlüssel können z.B. 
über  [Keyserver](#arbeiten-mit-keyservern) 
oder [WKD](#web-key-directory-wkd) verbreitet werden.

Der private Schlüssel wird hingegen zum Signieren 
und Entschlüsseln genutzt und sollte, 
wie der Name schon vermuten lässt, 
eher nicht weitergegeben werden und ist i.d.R mit einem Passwort geschützt.

Die Schlüssel werden über Schlüsselbunde verwaltet, 
auch hier wieder die Unterscheidung:

- einen für die Öffentlichen, *~/.gnupg/pubring.gpg*, eigenen Keys und die deiner Kommunikationspartner
- und den für die Privaten, *~/.gnupg/secring.gpg*

## Erstellung eines GnuPG Schlüsselpaares

Zur Erstellung eines GnuPG Schlüsselpaares ist der folgende Befehl 
unter deiner Benutzer-ID, 
also dem Benutzer, 
unter dem der Key auch genutzt werden soll, auszuführen. 
Andernfalls müssen der Ort durch `--homedir` angegeben
und ggf. Berechtigungen angepasst werden.

	gpg --full-generate-key 

Anstelle der `--full-generate-key` kann auch `--gen-key` verwendet werden,
es werden aber deutlich mehr Voreinstellungen, wie z.B. die Schlüsselgröße von 3072 Bits
oder einem Ablaufdatum von 2 Jahren gemacht.

```
gpg (GnuPG) 2.2.4; Copyright (C) 2017 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg: Verzeichnis `/home/florian/.gnupg' erzeugt
gpg: Die "Keybox" `/home/florian/.gnupg/pubring.kbx' wurde erstellt
```

Verschüsselungsalgorithmus wählen:
```
Bitte wählen Sie, welche Art von Schlüssel Sie möchten:
   (1) RSA und RSA (voreingestellt)
   (2) DSA und Elgamal
   (3) DSA (nur signieren/beglaubigen)
   (4) RSA (nur signieren/beglaubigen)
Ihre Auswahl? 1
```

Wir entscheiden uns mit `1` für die Voreinstellung RSA und RSA und bestätigen mit Enter.

Wahl der Länge bzw. Stärke des Schlüssels voreingestellt 3072 Bit.

```
RSA-Schlüssel können zwischen 1024 und 4096 Bit lang sein.
Welche Schlüssellänge wünschen Sie? (3072) 4096
```

Wir wählen den Maximalwert von `4096` und bestätigen mit Enter.\\
Es folgt die Quittierung von GnuPG: 

	Die verlangte Schlüssellänge beträgt 4096 Bit

Gültigkeitzeitraum des Schlüssels.   
Hier kann spezifiziert werden, ob und wann der Schlüssel verfällt.
Hier sollte entgegen dem Defaults `(0)` auf jeden Fall ein Ablaufdatum gewählt werden, 
denn in Falle eines korrumpierten Rechners 
oder Schlüssel verfällt dieser immerhin irgendann.

```
Bitte wählen Sie, wie lange der Schlüssel gültig bleiben soll.
         0 = Schlüssel verfällt nie
      <n>  = Schlüssel verfällt nach n Tagen
      <n>w = Schlüssel verfällt nach n Wochen
      <n>m = Schlüssel verfällt nach n Monaten
      <n>y = Schlüssel verfällt nach n Jahren
Wie lange bleibt der Schlüssel gültig? (0) 2y
```

Wir möchten, dass unser Schlüssel 2 Jahr gültig ist und geben entsprechend
`2y` über die Tastatur ein. 
Nach einem Enter quittiert gpg: 

	Key verfällt am Sa 01 Jul 2023 13:12:45 CEST

Anschließend wird die Eingabe nochmal hinterfragt:

	Ist dies richtig? (j/N) j


Das bestätigen wir mit `j` gefolgt von Enter.

Jetzt kommen wir zur Eingabe von Name, Emailadresse und optionalen Kommentar


	GnuPG erstellt eine User-ID, um Ihren Schlüssel identifizierbar zu machen.


Voller bzw. Realname:

	Ihr Name: Florian Latzel


Die Email-Adresse, die unsere spätere UID wird...

	Email-Adresse: florian@latzel.io


Die Email-Adresse `florian@latzel.io`, gefolgt von Enter.

Und ein optionaler Kommentar, den wir mit Enter überspringen.

	Kommentar: 

Es folgt eine letzte Überprüfung:
```
Sie haben diese User-ID gewählt:
    "Florian Latzel <florian@latzel.io>"
Ändern: (N)ame, (K)ommentar, (E)-Mail oder (F)ertig/(A)bbrechen? F
```

Wir wollen die Schlüsselerstellung abschließen und geben `F` gefolgt von Enter ein. 

```
Wir müssen eine ganze Menge Zufallswerte erzeugen.  Sie können dies
unterstützen, indem Sie z.B. in einem anderen Fenster/Konsole irgendetwas
tippen, die Maus verwenden oder irgendwelche anderen Programme benutzen.
gpg: /home/florian/.gnupg/trustdb.gpg: trust-db erzeugt
gpg: Schlüssel F4F62999C3BA4866 ist als ultimativ vertrauenswürdig gekennzeichnet
gpg: Verzeichnis `/home/florian/.gnupg/openpgp-revocs.d' erzeugt
gpg: Widerrufzertifikat wurde als '/home/florian/.gnupg/openpgp-revocs.d/3F9F644542DD63E82165D376F4F62999C3BA4866.rev' gespeichert.
Öffentlichen und geheimen Schlüssel erzeugt und signiert.

pub   rsa4096 2021-07-01 [SC] [verfällt: 2023-07-01]
      3F9F644542DD63E82165D376F4F62999C3BA4866
uid                      Florian Latzel <florian@latzel.io>
sub   rsa4096 2021-07-01 [E] [verfällt: 2023-07-01]
```

## Ein GPG Widerrufs (Revoke) Zertifikat erstellen

Es gibt Falle, in dem du deinen [Schlüssel auf den Keyservern widerrufen](
#schlüssel-widerrufen) möchtest, 
wie z.B. eine nicht genutzte Emailadresse, 
eine unzureichende Stärke des Schlüssels 
oder im schlimmsten Fall sind dein Schlüssel oder Rechner korrumpiert worden.

Mittlerweile generiert GnuPG (unter Ubuntu) via Default ein Widerrufszertifikat 
bei der Schlüsselerstellung(s.o).\\
Ein GnuPG Widerrufszertifikat solltest du unbedingt erstellen und sicher aufbewahren.

Manuelle Erstellung des Widerrufszertikats.  
Die Nutzer-ID kann EMail oder die Key-ID sein.
Hier mit der User-ID `florian@latzel.io`, 
der Revoke-Key wird in die Datei `~/florian@latzel.io-F4F62999C3BA4866-revoke-key.rev` 
geschrieben.

	gpg --gen-revoke florian@latzel.io > ~/florian@latzel.io-F4F62999C3BA4866-revoke-key.rev

GnuPG fragt, ob du mit der Erstellung des Widerrufszertifikats fortfahren möchtest,
`j` - ja wollen wir:
```
sec  rsa4096/F4F62999C3BA4866 2021-07-01 Florian Latzel <florian@latzel.io>

Ein Widerrufszertifikat für diesen Schlüssel erzeugen? (j/N) j
```

Dann kannst du mögliche Gründe angeben.
Hier lassen wir den Grund mal offen und wählen `0`...

```
Grund für den Widerruf:
  0 = Kein Grund angegeben
  1 = Hinweis: Dieser Schlüssel ist nicht mehr sicher
  2 = Schlüssel ist überholt
  3 = Schlüssel wird nicht mehr benutzt
  Q = Abbruch
(Wahrscheinlich möchten Sie hier 1 auswählen)
Ihre Auswahl? 0
```

...gleiches für die Beschreibung, wir überspringen mit Enter:
```
Geben Sie eine optionale Beschreibung ein. Beenden mit einer leeren Zeile:
> 
```
Grund für Widerruf: Kein Grund angegeben
(Keine Beschreibung angegeben)

Abschließend wird gefragt, ob wir mit den vorher gemachten Eingaben *OK sind*
und sagen mit `j` *OK*.
```
Ist das OK? (j/N) j
```

Wir bekommen noch ein paar Tipps für den Umgang mit den Widerrufszertifikat mit:
```
Ausgabe mit ASCII Hülle erzwungen
Widerrufszertifikat wurde erzeugt.

Bitte speichern Sie es auf einem Medium, welches Sie wegschließen
können; falls Mallory (ein Angreifer) Zugang zu diesem Zertifikat
erhält, kann er Ihren Schlüssel unbrauchbar machen.  Es wäre klug,
dieses Widerrufszertifikat auch auszudrucken und sicher aufzubewahren,
falls das ursprüngliche Medium nicht mehr lesbar ist.  Aber Obacht: Das
Drucksystem kann unter Umständen anderen Nutzern eine Kopie zugänglich
machen.
```

## Unterschlüssel: mehrere Emailadressen mit einem GPG-Key nutzen

Statt der Erstellung eines neuen Schlüssels für jede weitere Emailadresse,
besteht die Möglichkeit einem Schlüssel weitere Identitäten hinzufügen. 

### Weitere Emailadresse (User-ID) hinzufügen

Wir starten mit der Bearbeitung unseres Schlüssels 
via Key-ID, spezifizierbar über Emailadresse

	gpg --edit-key florian@latzel.io

oder hexadizmalschreibweise

	gpg --edit-key 3F9F644542DD63E82165D376F4F62999C3BA4866


```
gpg (GnuPG) 2.2.4; Copyright (C) 2017 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Geheimer Schlüssel ist vorhanden.

sec  rsa4096/F4F62999C3BA4866
     erzeugt: 2021-07-01  verfällt: 2023-07-01  Nutzung: SC  
     Vertrauen: ultimativ     Gültigkeit: ultimativ
ssb  rsa4096/4260D8234C49E8D6
     erzeugt: 2021-07-01  verfällt: 2023-07-01  Nutzung: E   
[uneingeschränkt] (1). Florian Latzel <florian@latzel.io>
```

Wir befinden uns jetzt im interaktiven Modus von gnupg (erkennbar im Prompt `gpg>`), 
mit `adduid` initieren die Erstellung des Unterschlüssels.

	adduid

Wie bei der Erstellung des Schlüssels, 
wird bei dem Erzeugen eines Unterschlüssels nach einem Namen...

	Ihr Name: Florian Latzel

und einer Email-Adresse gefragt.

	Email-Adresse: florian.latzel@is-loesungen.de


Kommentar: Wenn gewollt, kann auch der Unterschlüssel kommentiert werden.
	
	Kommentar: 

Abschließend eine Zusammenfassung der gemachten Angaben, 
die wir mit `F` bestätigen:
```
Sie haben diese User-ID gewählt:
    "Florian Latzel <florian.latzel@is-loesungen.de>"

Ändern: (N)ame, (K)ommentar, (E)-Mail oder (F)ertig/(A)bbrechen? F
```

Hier geht ein *Pinentry* Dialog auf, der zu Entsperrung des geheimen OpenPGP Schlüssels
die entsprechende Passphrase verlangt.

{%responsive_image figure:true 
path:assets/imgs/gnupg/pinentry-passphrase-geheimen-openpgp-schluessel-entsperren.png
alt:"Pinentry Dialog: Eingabe der Passphrase zum Entsperren des geheimen OpenPGP Schlüssels" %}

Der neu hinzugefügte Unterschlüssel wird aufgelistet:
```
sec  rsa4096/F4F62999C3BA4866
     erzeugt: 2021-07-01  verfällt: 2023-07-01  Nutzung: SC  
     Vertrauen: ultimativ     Gültigkeit: ultimativ
ssb  rsa4096/4260D8234C49E8D6
     erzeugt: 2021-07-01  verfällt: 2023-07-01  Nutzung: E   
[uneingeschränkt] (1)  Florian Latzel <florian@latzel.io>
[ unbekannt] (2). Florian Latzel <florian.latzel@is-loesungen.de>
```

	save
 
Nach dem Speichern mit `save` verlassen wir den interaktiven Modus von gpg 
und bekommen wieder den Prompt der Shell zu sehen.

### Unterschlüssel (User-ID) entfernen

	gpg --edit-key 768146CD269B69D1 

```
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
pub  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: SC  
     Vertrauen: unbekannt     Gültigkeit: widerrufen
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
sub  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: E   
[ widerrufen] (1)  Florian Latzel <florian.latzel@is-loesungen.de>
[ widerrufen] (2)  Florian Latzel <f.latzel@is-loesungen.de>
```

Wir wählen den zu löschenden Unterschlüssel. 
Dieser wird durch die entsprechende Zahl in der runden Klammer `(1)` spezifiziert:

	uid 1

Der entsprechende Unterschlüssel ist für die weitere Aktion ausgewählt,
erkennbar am `*` hinter der Zahl:

```
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
pub  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: SC  
     Vertrauen: unbekannt     Gültigkeit: widerrufen
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
sub  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: E   
[ widerrufen] (1)* Florian Latzel <florian.latzel@is-loesungen.de>
[ widerrufen] (2)  Florian Latzel <f.latzel@is-loesungen.de>
```

Jetzt die entsprechende Aktion:

	deluid

Es folgt eine weitere Sicherheitsabfrage, die wir mit `j` quittieren:

	Diese User-ID wirklich entfernen? (j/N) j

```
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
pub  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: SC  
     Vertrauen: unbekannt     Gültigkeit: widerrufen
Der folgende Schlüssel wurde am 2007-05-27 von DSA Schlüssel 768146CD269B69D1 Florian Latzel <florian.latzel@is-loesungen.de> widerrufen
sub  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  widerrufen: 2007-05-27  Nutzung: E   
[ widerrufen] (1)  Florian Latzel <f.latzel@is-loesungen.de>
```

Mit `save` beenden wir die Bearbeitung und den interaktiven Modus.

	save

## Konfiguration von GnuPG

### ~/.gnupg/options

Grundlegende Konfiguration von gnupg in ~/.gnupg/options

```
default-key 3F9F644542DD63E82165D376F4F62999C3BA4866
charset utf-8
require-cross-certification
use-agent
keyserver hkps://keys.openpgp.org  
```

- `default-key`, Schlüssel-ID unseres Hauptschlüssels
- `keyserver`, Angabe des Default [Keyservers](#arbeiten-mit-keyservern), der genutzt werden soll
- `require-cross-certification`, Schutz vor subtilen Angriffen auf Subkeys beim signieren (Default).
Siehe auch  `no-require-cross-certification`.
- `use agent`, Dummy Option, wird immer benötigt
 
### ~/.gnupg/gpg-agent.conf

Konfiguration des gpg-agents in *~/.gnupg/gpg-agent.conf*

```
default-cache-ttl 18000
max-cache-ttl 86400
ignore-cache-for-signing
no-grab
pinentry-program /usr/bin/pinentry-gnome3
debug-level basic
```

- `default-cache-ttl`, Zeit in Sekunden, die ein Cache-Eintrags gülig ist
- `max-cache-ttl`, Maximale Zeit in Sekunden, die ein Cache-Eintrag gültig ist
- `ignore-cache-for-signing` Bypass des Passwort Caches bei Signing
- `no-grab` Zur Vorbeugung von sog. X-Sniffing-Angriffen bei Nutzung von Pinentry.
- `pinentry-program`, Absolute Pfadangabe dazu

## Web Key Directory (WKD) 

WKD[^wkd] ist einfaches Konzept zur Verteilung öffentlicher PGP-Schlüssel via HTTPS.

Viele Mailcients[^mcl] wie z.B. Thunderbird, Outlook (GpgOL) 
oder Failmail (via OpenKeychain) nutzen WKD automatisch 
und einige Email-Provider (die cooleren[^emailwkd]) haben WKD im Funktionsumfang. 

WKD bietet zwei Methoden um öffentliche Schlüssel Schlüssel abzurufen,
die *direct method* und die *advanced method*. 
Neben einer unterschiedlichen Verzeichnisstruktur 
benötigt die *advanced method* zusätzlich eine Subdomain namens *openpgpkey* 
und einen entsprechenden TXT-Eintrag hierfür.   

Die folgende Schritte befassen sich mit der 
[Einrichtung von WKD in der direct method](#wkd-einrichten). 

### WKD einrichten 

Die *WKD direct method* nutzt folgendes Schema für URLs:    
https://$DOMAIN/.well-known/openpgpkey/hu/$HASHED_USERID,    
für florian@latzel.io ergibt sich daraus die folgende URL:   
<https://latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb>

So sieht die entsprechende Verzeichnisstruktur,
für meine im Beispiel genutzte Emailadresse florian@latzel.io aus.   
Wir blicken auf die *Document Root* für die Domain latzel.io auf uberspace.   
Im Verzeichnis hu liegen die Dateien .htaccess 
und die Hashed-UserID aus florian.

```
/var/www/virtual/${USER}/latzel.io
└── .well-known
    └── openpgpkey
        ├── hu
        │   ├── .htaccess
        │   └── qcuniwbujk3zrj7166onyz4t5cxgy3wb
        └── policy
```
Voraussetzungen für die nächsten Schritte sind ein Webserver, 
der via HTTPS ausliefert,
ein gültiges TLS Zertifikat besitzt
und dir die Möglichkeit gibt *.htaccess-Dateien* zu nutzen
(oder du hast entsprechend hohe Privilegien 
um Einstellungen an Webserver bzw. Konfiguration vornehmen zu können).

Sofern unsere  Domain[^domain], 
wie im hier genutzten Beispiel von uberspace[^domain] ausgeliefert wird
und ein entsprechender A- oder AAA-Eintrag existiert,
wird der Webserver, dank des *Let's Encrypt Zertifikats* 
den via WKD angefragten Key via TLS/SSL ausliefern.


Erzeugen der Verzeichnisstruktur für WKD:

    mkdir -p /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/hu

Symlink im Home Verzeichnis mit Namen der Domain erstellen:
    
    ln -s /var/www/virtual/${USER}/latzel.io ~/
    
Anlegen der (leeren) Datei *policy* :

    touch /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/policy


Damit der Webserver die benötigten HTTP-Header ausliefert, 
legen wir eine .htaccess-Datei mit folgendem Inhalt an:

    vi /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/hu/.htaccess


```
<IfModule mod_mime.c>
   ForceType application/octet-stream
   Header always set Access-Control-Allow-Origin "*"
</IfModule>
```


### Upload der Public Keys in das WKD

So kommst du an die WKD Hashes der Emailadressen:\\
Die sog. hashed-userid, ist ein SHA1 Hash, der aus dem lokalen Teil(User/Prefix),
der anschließend mit dem *Z-Base-32 Verfahren* kodiert wird[^zbase32].

Diese entspricht dem späteren Dateinamen.


    gpg --with-wkd-hash --fingerprint florian@latzel.io 


Das wäre `qcuniwbujk3zrj7166onyz4t5cxgy3wb` für `florian`, wie wir in Zeile 4 sehen.
```
pub   rsa4096 2021-07-01 [SC] [verfällt: 2023-07-01]
      3F9F 6445 42DD 63E8 2165  D376 F4F6 2999 C3BA 4866
uid        [uneingeschränkt] Florian Latzel <florian@latzel.io>
           qcuniwbujk3zrj7166onyz4t5cxgy3wb@latzel.io
uid        [uneingeschränkt] Florian Latzel <florian.latzel@is-loesungen.de>
           t66qdyuka3hnekbqs31pd3jqtuyqp3z5@is-loesungen.de
uid        [uneingeschränkt] Florian Latzel <floh@netzaffe.de>
           4ucicrgmurtefmgehpbqdm3bf49kmk6b@netzaffe.de
uid        [uneingeschränkt] Florian Latzel <florian.latzel@gmail.com>
           t66qdyuka3hnekbqs31pd3jqtuyqp3z5@gmail.com
sub   rsa4096 2021-07-01 [E] [verfällt: 2023-07-01]
```

Wir übertragen den Key auf dem Server, indem die Ausgabe von `gpg --export` an den SSH-Befehl via Pipe weitergeben.
So entsteht keine Datei, die wir gar nicht brauchen und nach der Übertragung löschen müssten.

    gpg --no-armor --export florian@latzel.io | ssh ssh-server-oder-ip "cat > latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb"

    
### Testen der Schlüsselerkennung via WKD

#### Via Zugriff auf HTTPS

Via Browser 
<https://latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb> 
aufrufen.
Im Erfolgsfall sollte eine Datei zum Download angeboten werden.

Oder via Curl: 

    curl -I https://latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb 

Hier können wir gut Statuscode und die ausgespielten Header sehen:
    
```    
HTTP/2 200 
date: Sun, 11 Jul 2021 10:50:13 GMT
content-type: application/octet-stream
content-length: 4193
server: nginx
access-control-allow-origin: *
last-modified: Sun, 11 Jul 2021 10:50:07 GMT
etag: "1061-5c6d6c49ad544"
accept-ranges: bytes
x-xss-protection: 1; mode=block
x-frame-options: SAMEORIGIN
strict-transport-security: max-age=31536000
x-content-type-options: nosniff
referrer-policy: strict-origin-when-cross-origin
```

#### Via WKD Checker Webfrontend   

Auf <https://metacode.biz/openpgp/web-key-directory> findest du 
ein Webfrontend zum Testen des Deployments deiner Keys in ein *Web Key Directory*.

{% responsive_image figure: true 
path: assets/imgs/gnupg/gnupg-wkd-web-key-directory-deployment-checker-webfrontend.png
alt: "Überprüfung des WKD Deployments via Webfrontend" %}

    
#### Via gpg

    gpg -v --auto-key-locate clear,wkd,nodefault --locate-key florian@latzel.io  

```
gpg: verwende Vertrauensmodell pgp
gpg: pub  rsa4096/F4F62999C3BA4866 2021-07-01  Florian Latzel <florian@latzel.io>
gpg: Schlüssel F4F62999C3BA4866: "Florian Latzel <florian@latzel.io>" nicht geändert
gpg: Anzahl insgesamt bearbeiteter Schlüssel: 1
gpg:              unverändert: 1
gpg: auto-key-locate found fingerprint 3F9F644542DD63E82165D376F4F62999C3BA4866
gpg: `florian@latzel.io' automatisch via WKD geholt
pub   rsa4096 2021-07-01 [SC] [verfällt: 2023-07-01]
      3F9F644542DD63E82165D376F4F62999C3BA4866
uid        [uneingeschränkt] Florian Latzel <florian@latzel.io>
uid        [uneingeschränkt] Florian Latzel <florian.latzel@is-loesungen.de>
uid        [uneingeschränkt] Florian Latzel <floh@netzaffe.de>
uid        [uneingeschränkt] Florian Latzel <florian.latzel@gmail.com>
sub   rsa4096 2021-07-01 [E] [verfällt: 2023-07-01]
```

## Arbeiten mit GnuPG

Eine Sammlung von gebräuchlichen von GnuPG-Befehlen und -Optionen..

### Geheime Schlüssel auflisten

Anzeigen aller Private-Keys, alternativ steht noch `-K` als Shortoption zur Verfügung.

	gpg --list-secret-keys

### Export eines geheimen Schlüssels

Für eine Sicherheitskopie oder das Arbeiten auf mehreren Maschinen 
exportieren wir den Geheimen Schlüssel (Private Key).
Dieser sollte auf einem externen Datenträger gespeichert 
und an einem sicheren Ort aufbewahrt werden.

Um den den Schlüssel auf einen anderen Rechner zu transferieren sollte eine verschlüsselte Verbindung benutzt werden.

	gpg --export-secret-key 269B69D1 > 269B69D1-private.key

### Geheimen Schlüssel löschen

Um einen geheimen Schlüssel zu löschen wird das folgende Kommando verwendet, 
der zu löschende Schlüssel muss durch Key-ID oder EMail angegeben werden.

	gpg --delete-secret-keys 269B69D1


### Public-Keys auflisten

Public-Keys auflisten. Erzeugt eine Auflistung aller Public-Keys im Keyring.
Short Option `-k`.
	
	gpg --list-keys

Es erscheint unser frisch erzeugter Schlüssel

### Fingerprint ausgeben

Fingerprint ausgeben. Analog zur Ausgabe wie mit --list-keys lässt zusätzlich noch der Fingerprint anzeigen.

	gpg --fingerprint

Der Fingerprint besteht aus 10 4er Paaren(hexadezimal), 
die letzen 2 4er Paare sind gleichzeitig die Key-ID.

	B043 7BFD 2D37 E901 4F88 2463 7681 46CD 269B 69D1

### Public-Keys in Datei exportieren. 

Den Public-Key in eine sog. ASCII-Armored Datei (via `-a`) exportieren.
Die Ausgabe, hier die Datei *florian-at-latzel-io.asc* wird via `-o` festgelegt,
Default ist Stdout.

	gpg --export -a -o florian-at-latzel-io.asc florian@latzel.io

### Public-Key aus Datei importieren

Mit dem folgendem Befehl wird Keyring importiert:

	gpg --import <Datei>

## Arbeiten mit Keyservern

Key- beziehungsweise Schlüsselserver stellen öffentliche Schlüssel bereit,
die du oder andere zum Verschlüsseln oder zur Überprüfung von Signaturen brauchen.

Kleiner geschichtlicher Abriss: 
Ende Juni 2019 [^sks1] [^sks2] wurde das *SKS Keyserver Netzwerk* wiedermal angegriffen.
GnuPG in der Version 2.2.17 ignorierte bereits standardmäßig alle Signaturen, die von einem Keyserver stammen. 
Im Juni 2021 wurde das SKS abgeschaltet[^sks-aus].

Mittlerweile gibt es Keyserver mit Überprüfung der Schlüssel 
via *Double-Opt-In* und Löschmöglichkeit[^newkeys], 
allerdings zulasten des sogenannten *Web of Trust*[^weboftrust].
Zwei Vertreter davon sind [keys.mailvelope.com](https://keys.mailvelope.com/) 
betrieben mit [Mailvelope](https://github.com/mailvelope/keyserver)
und der De-Facto-Standard [keys.openpgp.org](https://keys.openpgp.org/) betrieben mit [Hagrid](
https://gitlab.com/keys.openpgp.org/hagrid).   
Mit [keyserver.ubuntu.com](https://keyserver.ubuntu.com) 
(betrieben mit [Hockeypuck](https://github.com/hockeypuck/hockeypuck))
steht dir ein Keyserver zur Verfügung, 
der zwar Signaturen erhält,
allerdings keine Überprüfung oder Löschmöglichkeit der Schlüssel bietet 

### Public-Key auf keys.openpgp.org veröffentlichen

Von der Startseite, <https://keys.openpgp.org/> 
kommen wir über den Link [hochladen](https://keys.openpgp.org/upload) 
auf das Upload-Formular <https://keys.openpgp.org/upload>.
Dort laden wir unseren öffentlichen Schlüssel 
(siehe [Public-Keys in Datei exportieren.](#public-keys-in-datei-exportieren)) hoch.

Alternativ können wir unseren öffentlichen Schlüssel nach curl *pipen*...

	    gpg --export florian@latzel.io | curl -T - https://keys.openpgp.org

In der Ausgabe des Befehls finden wir den Link zur Bestätigungsseite. 
``` 
Key successfully uploaded. Proceed with verification here:
https://keys.openpgp.org/upload/$LONG_RANDOM_VERIFICATION_STRING
``` 
Die weiteren Schritte verlaufen analog zum Upload über den Browser.

{% responsive_image path: assets/imgs/gnupg/keys-openpgp-org-1-schluessel-hochladen-upload.png
alt: "Öffentlichen PGP Schlüssel auf keys.openpgp.org hochladen" %}

Anschließend senden wir uns je Schlüssel eine Bestätigungs-Email via Klick auf den Button
*Bestätigungs-Email senden* 
und folgen dem Link in der Email um diesen auf dem Keyserver zu veröffentlichen.

{% responsive_image path: assets/imgs/gnupg/keys-openpgp-org-2-bestaetigungs-email-senden.png
alt: "Verifizierung der Öffentlichens PGP Schlüssel auf keys.openpgp.org, Bestätigungs-Email senden" %}

Nachdem die Überprüfung aller Schlüssel abgeschlossen ist, sieht das so aus:

{% responsive_image path: assets/imgs/gnupg/keys-openpgp-org-3-schluessel-veroeffentlicht.png
alt: "Verifizierte Identitäten des öffentlichens PGP Schlüssels auf keys.openpgp.org" %}

### Public-Key von keys.openpgp.org entfernen

Mit Klick auf [verwalten](https://keys.openpgp.org/manage) 
kommen wir nach <https://keys.openpgp.org/manage>. 
Hier haben wir die Möglichkeit nach Email-Adresse, Schlüssel-ID oder Fingerprint zu suchen.
Nach erfolgreicher Suche wird eine Email 
mit dem Link zur Verwaltung unserer Schlüssel versand.

{% responsive_image path: assets/imgs/gnupg/keys-openpgp-org-4-schluessel-verwalten-sende-link.png
alt: "Schlüssels auf keys.openpgp.org verwalten, Sende Link" %}

Hier können wir unser Schlüssel aus der Suche entfernen. 
Achtung, der nächste Schritt erfordert keine Bestätigung!

Aus der Suche entfernte Keys könnten wir durch erneutes Hochladen wieder
in die Suche aufnehmen.

{% responsive_image path: assets/imgs/gnupg/keys-openpgp-org-5-schluessel-entfernen.png 
alt: "Schlüssels von keys.openpgp.org entfernen" %}

### Schlüssel auf Keyserver suchen

Suche nach EMail-Adresse (uid) 

	gpg --search-keys florian@latzel.io

oder Key-ID

	gpg --search-keys F4F62999C3BA4866


Die Suche nach Namen oder Teilstrings klappt bei keys.openpgp.org nicht, 
aber auf dem mit Hagrid betriebenen keyserver, <https://keyserver.ubuntu.com>.
Den Default Keyserver aus der [*~/.gnupg/options*](#gnupgoptions)
können wir durch die Angabe eines anderen Keyservers via `--keyserver` Option überschreiben.

Suche nach Namen...

	gpg --keyserver keyserver.ubuntu.com --search-keys 'Florian Latzel' 

...nach Teilstring des Namens, z.B. dem Nachnamen...	

	gpg --keyserver keyserver.ubuntu.com --search-keys 'Latzel' 

...oder der Suche nach eine Teilstring der E-Mailadresse, z.B. der Domain...

	gpg --keyserver keyserver.ubuntu.com --search-keys 'netzaffe.de' 


Bei einer erfolgreichen Suchanfrage besteht die Möglichkeit, 
gefundenen Schlüssel interaktiv in den Schlüsselbund zu importieren.
Im folgenden Besispiel geschieht das 
über die Eingabe der Nummer des Schlüssels,
hier `1`, für den einen gefundenen Schlüssel `(1)`, erkennbar in Zeile 2.

```
gpg: data source: https://keys.openpgp.org:443
(1)     Florian Latzel <floh@netzaffe.de>
        Florian Latzel <florian.latzel@gmail.com>
        Florian Latzel <florian.latzel@is-loesungen.de>
        Florian Latzel <florian@latzel.io>
          4096 bit RSA key F4F62999C3BA4866, erzeugt: 2021-07-01
Keys 1-1 of 1 for "florian@latzel.io".  Eingabe von Nummern, Nächste (N) oder Abbrechen (Q) > 1
```

### Public-Key von Keyserver importieren

Einen Public-Key, dessen Key-ID bekannt ist, können wir direkt vom Keyserver herunterzuladen 

	gpg --recv-keys F4F62999C3BA4866

### Schlüssel widerrufen

Sofern Hockeypuck basierte Keyserver genutzt werden,
ist der folgende Absatz relevant. 
Während bei Hagrid (siehe oben) 
und Mailvelope die Einträge aus der Suche entfernt werden können,
verbleibt bei Hockeypuck der Schlüssel als widerrufen gekennzeichnet auf dem Server.

#### Primärschlüssel widerrufen

Wir importieren den [Revoke-Key](#ein-gpg-widerrufs-revoke-zertifikat-erstellen) 
in unseren Keyring:

	gpg --import 269B69D1-revoke-key.asc

Nun senden wir senden unseren Schlüssel, 
in dem sich jetzt unser Revoke-Key befindet zum Keyserver, 
um ihn dort zu widerufen.

	gpg --send-keys F4F62999C3BA4866


#### Unterschlüssel (User-ID) widerrufen

Analog zum Widerruf des Primärschlüssel, können auch [Unterschlüssel]() widerufen werden. 

	gpg --edit-key B0437BFD2D37E9014F882463768146CD269B69D1


Es folgt eine Auflistung alle Schlüssel.

```  
gpg (GnuPG) 2.2.4; Copyright (C) 2017 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Geheimer Schlüssel ist vorhanden.

sec  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  verfällt: 2021-07-01  Nutzung: SC  
     Vertrauen: ultimativ     Gültigkeit: ultimativ
ssb  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  verfällt: niemals       Nutzung: E   
[uneingeschränkt] (1). Florian Latzel <florian.latzel@is-loesungen.de>
[uneingeschränkt] (2)  Florian Latzel (M\xfc\x6cheim ist nett - K\xf6\x6cn- M\xfc\x6cheim Punkt Net - http://koeln-muelheim.net) <floh@koeln-muelheim.net>
[uneingeschränkt] (3)  Florian "floh" Latzel (gib dem Netzaffen Zucker!) <floh@netzaffe.de>
[uneingeschränkt] (4)  Florian Latzel (is-loesungen.de) <f.latzel@is-loesungen.de>
[uneingeschränkt] (5)  Florian Latzel <f.latzel@is-loesungen.de>
[ widerrufen] (6)  Florian Latzel <latzel@silpion.de>
[ widerrufen] (7)  Florian Latzel <florian@datengarten.com>
[ widerrufen] (8)  Florian Latzel <florian@funpromotion.eu>
[uneingeschränkt] (9)  Florian Latzel (Reinblau CMS Framworkers) <florian.latzel@reinblau.de>
[uneingeschränkt] (10)  Florian Latzel <developer@optona.de>
[uneingeschränkt] (11)  Florian Latzel <florian.latzel@gmail.com>
```  

Wir wollen die *Reinblau User-ID* (unter 9) widerufen, 
dafür wählen wir die entsprechend Zahl.

	9

Die User-ID ist, erkennbar durch den Stern, ausgewählt.

```  
sec  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  verfällt: 2021-07-01  Nutzung: SC  
     Vertrauen: ultimativ     Gültigkeit: ultimativ
ssb  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  verfällt: niemals       Nutzung: E   
[uneingeschränkt] (1). Florian Latzel <florian.latzel@is-loesungen.de>
[uneingeschränkt] (2)  Florian Latzel (M\xfc\x6cheim ist nett - K\xf6\x6cn- M\xfc\x6cheim Punkt Net - http://koeln-muelheim.net) <floh@koeln-muelheim.net>
[uneingeschränkt] (3)  Florian "floh" Latzel (gib dem Netzaffen Zucker!) <floh@netzaffe.de>
[uneingeschränkt] (4)  Florian Latzel (is-loesungen.de) <f.latzel@is-loesungen.de>
[uneingeschränkt] (5)  Florian Latzel <f.latzel@is-loesungen.de>
[ widerrufen] (6)  Florian Latzel <latzel@silpion.de>
[ widerrufen] (7)  Florian Latzel <florian@datengarten.com>
[ widerrufen] (8)  Florian Latzel <florian@funpromotion.eu>
[uneingeschränkt] (9)* Florian Latzel (Reinblau CMS Framworkers) <florian.latzel@reinblau.de>
[uneingeschränkt] (10)  Florian Latzel <developer@optona.de>
[uneingeschränkt] (11)  Florian Latzel <florian.latzel@gmail.com>
```  

Mit `revuid` leiten wir die entsprechende Aktion ein.

	revuid

Es folgt eine Sicherheitsabfrage.

	Diese User-ID wirklich widerrufen? (j/N) j

Und ein Grund für den Wideruf.

```  
Grund für den Widerruf:
  0 = Kein Grund angegeben
  4 = User-ID ist nicht mehr gültig
  Q = Abbruch
(Wahrscheinlich möchten Sie hier 4 auswählen)
```  

Wir wählen `4`.

	Ihre Auswahl? 4
	
Wir haben noch die Möglichkeit einer optionalen Beschreibung, 
die wir jedoch leerlassen.

```  
Geben Sie eine optionale Beschreibung ein. Beenden mit einer leeren Zeile:
> 
```  
```  
Grund für Widerruf: User-ID ist nicht mehr gültig
(Keine Beschreibung angegeben)
```  

Es folgt eine letzte Abfrage zur Bestätigung.

	Ist das OK? (j/N) j

Jetzt wird die *User-ID 9* in den eckigen Klammern als `widerufen` gekennzeichnet.
```  
sec  dsa1024/768146CD269B69D1
     erzeugt: 2007-05-25  verfällt: 2021-07-01  Nutzung: SC  
     Vertrauen: ultimativ     Gültigkeit: ultimativ
ssb  elg2048/0D12C6401914C2F9
     erzeugt: 2007-05-25  verfällt: niemals       Nutzung: E   
[uneingeschränkt] (1). Florian Latzel <florian.latzel@is-loesungen.de>
[uneingeschränkt] (2)  Florian Latzel (M\xfc\x6cheim ist nett - K\xf6\x6cn- M\xfc\x6cheim Punkt Net - http://koeln-muelheim.net) <floh@koeln-muelheim.net>
[uneingeschränkt] (3)  Florian "floh" Latzel (gib dem Netzaffen Zucker!) <floh@netzaffe.de>
[uneingeschränkt] (4)  Florian Latzel (is-loesungen.de) <f.latzel@is-loesungen.de>
[uneingeschränkt] (5)  Florian Latzel <f.latzel@is-loesungen.de>
[ widerrufen] (6)  Florian Latzel <latzel@silpion.de>
[ widerrufen] (7)  Florian Latzel <florian@datengarten.com>
[ widerrufen] (8)  Florian Latzel <florian@funpromotion.eu>
[ widerrufen] (9)  Florian Latzel (Reinblau CMS Framworkers) <florian.latzel@reinblau.de>
[uneingeschränkt] (10)  Florian Latzel <developer@optona.de>
[uneingeschränkt] (11)  Florian Latzel <florian.latzel@gmail.com>
```  

## Historie dieses Howtos

- Seit 2021-07    
Aktualisierungen und Ergänzungen basierend auf einem im Juli 2021    
mit gpg 2.2.4 erstellten Schlüssel.
  - Überarbeitung: Text allgemein und Struktur
  - Aktualisierung: [Erstellung eines GnuPG Schlüsselpaares](
#erstellung-eines-gnupg-schlüsselpaares) 
und [Subkeys](#unterschlüssel-mehrere-emailadressen-mit-einem-gpg-key-nutzen)
  - Neu: [User-ID entfernen (deluid)](#unterschlüssel-user-id-entfernen)
  - Neu: [Web Key Directory (WKD)](#web-key-directory-wkd) 
und [Einrichtung von WKD (direct method)](#wkd-einrichten)
  - Neu: [Nutzung von keys.openpgp.org](#public-key-auf-keysopenpgporg-veröffentlichen) 
  - Neu: [User-ID widerrufen (revuid)](#unterschlüssel-user-id-widerrufen)
- 2008-11-26    
[Veröffentlichung auf netzaffe.de](
https://web.archive.org/web/20081216082227/http://netzaffe.de/2008/11/26/gnupg-micro-howto.html).    
Als Grundlage diente ein Skript, welches während meiner Linux Dozententätigkeit um 2007/2008 entstand.
Dieses Skript basierte auf gpg in der Version 1.4.6 und pinentry 0.7.2 unter Debian Etch   
und wurde unter anderem getestet auf/mit:     
  - Ubuntu 8.04 mit gpg 1.4.6 und pinentry 0.7.4
  - openSuSE 11 mit gpg2 2.0.9-22.1 und pinentry 0.7.5-5.1
  - Windows Vista mit gnupg-w32cli-1.4.9.exe

Siehe [Changelog](
https://github.com/fl3a/florian.latzel.io/commits/master/_posts/2008-11-26-gnupg-micro-howto.md) 
für weitere Details

## Weiterführende Artikel

- [GNU Privacy Guard - Wikipedia](
http://de.wikipedia.org/wiki/GNU_Privacy_Guard)
- [Das GNU-Handbuch zum Schutze der Privatsphäre (2000)](
https://www.gnupg.org/gph/de/manual/book1.html)
- [Einfach erklärt: E-Mail-Verschlüsselung mit PGP](
https://www.heise.de/ct/artikel/Einfach-erklaert-E-Mail-Verschluesselung-mit-PGP-4006652.html)
- [Die c't-Krypto-Kampagne - Abhörsichere E-Mail mit PGP](
https://www.heise.de/security/dienste/Krypto-Kampagne-2111.html)
- [GnuPG in der Debian-Referenz](
https://www.debian.org/doc/manuals/debian-reference/ch10.de.html#_data_security_infrastructure)
- [GnuPG auf ubuntuusers.de](https://wiki.ubuntuusers.de/GnuPG)
- [GPG und Vim](https://wiki.debianforum.de/Vim_mit_gnupg)
- [RFC2440: OpenPGP Message Format, obsolet mit RFC4880](
https://www.ietf.org/rfc/rfc2440.txt)
- [RFC2015: MIME Security With Pretty Good Privacy(PGP)](
https://www.ietf.org/rfc/rfc2015.txt)
- [The Keysigning Party HOWTO](
https://www.cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html)
- [E-Mail-Verschlüsselung und Signatur in der IT-Forensik](
https://it-forensik.fiw.hs-wismar.de/index.php/E-Mail-Verschl%C3%BCsselung_und_Signatur_in_der_IT-Forensik)
- [The OpenPGP HTTP Keyserver Protocol (HKP) draft-shaw-openpgp-hkp-00.txt](
https://tools.ietf.org/html/draft-shaw-openpgp-hkp-00)


## Credits

Danke Mike Kuketz für deinen Artikel [GnuPG: Web Key Directory (WKD) einrichten](
https://www.kuketz-blog.de/gnupg-web-key-directory-wkd-einrichten/),
an dem ich mich bei meinem Setup orientieren konnte🙏.

Danke an meine ersten Proband\*innen Nadine, Michael und Thomas🙏 aus der DAA Bonn 
für das erste Feedback zum Skript und die Checks auf Ubuntu, openSuSE 11 und Windows Vista.  

## Fußnoten

[^1]: [Public-Key Verschlüsselungsverfahren](https://de.wikipedia.org/wiki/Public-Key-Verschl%C3%BCsselungsverfahren)
[^2]: [Öffentlicher Schlüssel](https://de.wikipedia.org/wiki/%C3%96ffentlicher_Schl%C3%BCssel)
[^3]: [Privater Schlüssel](https://de.wikipedia.org/wiki/Geheimer_Schl%C3%BCssel)
[^rfc4880]: [RFC 4880 - OpenPGP Message Format](https://datatracker.ietf.org/doc/html/rfc4880)
[^secure-apt]: [Paketsignierung in Debian](https://www.debian.org/doc/manuals/securing-debian-manual/deb-pack-sign.de.html#apt-0.6) 	
[^gh-sign-commit]: [Signing commits - Github Docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
[^gh-sign-tag]: [Signing tags - Github Docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-tags)
[^git-gpg]: [Git Tools - Signing Your Work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
[^4]: [Schlüsselserver](https://de.wikipedia.org/wiki/Schl%C3%BCsselserver)
[^5]: [Keysigning-Party](https://de.wikipedia.org/wiki/Keysigning-Party)
[^newkeys]: [Neuer OpenPGP-Keyserver liefert endlich verifizierte Schlüssel - heise.de](https://www.heise.de/security/meldung/Neuer-OpenPGP-Keyserver-liefert-endlich-verifizierte-Schluessel-4450814.html)
[^domain]: [Domains - Uberspace Manual  ](https://manual.uberspace.de/web-domains.html)
[^mcl]: [Mailclients mit WKD Unterstützung - GnuPG Wiki](https://wiki.gnupg.org/WKD#Mail_Clients)
[^zbase32]: [Z-Base-32 converter – cryptii](https://cryptii.com/pipes/z-base-32)
[^sks1]: [SKS Keyserver Network Under Attack - rjhansen](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f)
[^sks2]: [Verschlüsselte Kommunikation: Angriff auf PGP-Keyserver demonstriert hoffnungslose Situation - heise.de](https://www.heise.de/security/meldung/Angriff-auf-PGP-Keyserver-demonstriert-hoffnugslose-Situation-4458354.html)
[^weboftrust]: [PGP: Der langsame Tod des Web of Trust - heise.de](https://www.heise.de/hintergrund/PGP-Der-langsame-Tod-des-Web-of-Trust-4467052.html)
[^wkd]: [Web Key Service: OpenPGP-Schlüssel über HTTPS verteilen - golem.de](https://www.golem.de/news/web-key-service-openpgp-schluessel-ueber-https-verteilen-1609-123194.html)
[^sks-aus]: [SKS: Das Ende der alten PGP-Keyserver - golem.de](https://www.golem.de/news/sks-das-ende-der-alten-pgp-keyserver-2106-157613.html)
[^emailwkd]: [Mail Service Providers offering WKD](https://wiki.gnupg.org/WKD#Mail_Service_Providers_offering_WKD)

*[RFC]: Request for Comment
*[WKD]: Web Key Directory
*[SSL]: Secure Socket Layer
*[TLS]: Transport Layer Security
*[PGP]: Pretty Good Privacy
*[HTTPS]: Hypertext Transfer Protocol Secure
*[SKS]: Synchronizing Key Server
*[DAA]: Deutsche Angestellten-Akademie
*[HTTPS]: Hypertext Transfer Protocol Secure

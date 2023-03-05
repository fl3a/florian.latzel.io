---
date: 2008-11-26 07:43
last_modified_at: 2019-03-31 2019-03-31 18:59 
tags:
- Datenschutz 
- gpg 
- howto 
- Linux 
- Sicherheit 
- Verschlüsselung 
layout: post
permalink: /gnupg-micro-howto.html
title: GnuPG (GPG) Micro Howto
image: /assets/imgs/1280px-GnuPG.svg.png
---
<figure role="group">
  <img src="/assets/imgs/1280px-GnuPG.svg.png" alt="GnuPG Logo 1280x387" title="GnuPG Logo" />
  <figcaption>GnuPG Logo, Thomas Wittek, GnuPG Projekt, Gemeinfrei</figcaption>
</figure>
GnuPG ist eine freie Kryptographiesoftware, 
die das *OpenPG Message Format* gemäß *RFC 4880[^rfc4880]* implementiert
und unter Linux, MacOS, Windows sowie anderen unixioden System nutzbar ist.\\
Diese wird zum Ver- und Entschlüsseln sowie Erzeugung und Überprüfung von Signaturen genutzt,
Verwendungsbeispiele sind verschlüsselte EMailkommunikation 
oder die Sicherstellung der Integrität durch signierte Softwarepakete wie unter Debian.

Dieses Howto beschreibt die Schlüsselerstellung, gebräuchliche Anwendungsfälle,
das Arbeiten mit Keyservern, Konfiguration von GnuPG auf der Kommandozeile 
und ist auf alle oben genannten Systeme übertragbar<!--break-->

* toc
{:toc}

## Konzept und Terminologie

GnuPG verwendet das sog. Public-Key-Verschlüsselungsverfahren[^1], 
dass heißt, das es 2 Arten von Schlüssel gibt, 
Öffentliche- (Public Keys)[^2] und Private Schlüssel (private Keys)[^3]. 
Jeder Schlüssel hat sein dazugehöriges Gegenstück, allgemein als Schlüsselpaar bezeichnet.

Der öffentlicher Schlüssel wird wird zum Verschlüsseln 
und zur Überprüfung von Signaturen genutzt 
und muss deinem Kommunikationspartner zur Verfügung stehen 
damit er diese Aktionen ausführen kann 
und wird i.d.R. über z.B. sog. Keyserver öffentlich verbreitet.

Der private Schlüssel wird hingegen zum Signieren 
und Entschlüsseln genutzt und sollte, 
wie der Name schon vermuten lässt eher nicht weitergegeben werden 
und ist i.d.R mit einem Passwort geschützt.

Die Schlüssel werden über Schlüsselbünde verwaltet, auch hier wieder die Unterscheidung:

- einen für die Öffentlichen, *~/.gnupg/pubring.gpg*, eigenen Keys und die deiner Kommunikationspartner
- und den für die Privaten, *~/.gnupg/secring.gpg*

## Erstellung eines GnuPG Schlüsselpaares

Zur Erstellung eines GnuPG Schlüsselpaares ist der folgende Befehl 
unter deiner Benutzer-ID, 
also dem Benutzer unter dem der Key auch genutzt werden soll auszuführen. 
Andernfalls müssen der Ort durch `--homedir` angegeben
und ggf. Berechtigungen angepasst werden.

```
gpg --full-generate-key 
```

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

### Verschüsselungsalgorithmus

Verschüsselungsalgorithmus wählen
```
Bitte wählen Sie, welche Art von Schlüssel Sie möchten:
   (1) RSA und RSA (voreingestellt)
   (2) DSA und Elgamal
   (3) DSA (nur signieren/beglaubigen)
   (4) RSA (nur signieren/beglaubigen)
Ihre Auswahl? 1
```

Wir entscheiden uns mit `1` für die Voreinstellung RSA und RSA und bestätigen mit Enter.

### Schlüssellänge

Wahl der Länge bzw. Stärke des Schlüssels, voreingestellt 3072.

```
RSA-Schlüssel können zwischen 1024 und 4096 Bit lang sein.
Welche Schlüssellänge wünschen Sie? (3072) 4096
```

Wir wählen den Maximalwert von `4096` und bestätigen mit Enter.\\
Es folgt die Quittierung von GnuPG:

```
Die verlangte Schlüssellänge beträgt 4096 Bit
```

Wir wählen die Voreinstellung und bestätigen diese.

### Gültigkeitzeiraum

Gültigkeitzeiraum des Schlüssels\\
Hier kann spezifiziert werden ob und wann der Schlüssel verfällt.
Hier sollte entgegen des Defaults `(0)` auf jeden Fall ein Ablaufdatum gewählt werden, 
denn in Falle eines korumpierten Rechners 
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

```
Key verfällt am Sa 01 Jul 2023 13:12:45 CEST
```

Anschließend wird die Eingabe nochmal hinterfragt:

```
Ist dies richtig? (j/N) j
```

Das bestätigen wir mit `y` gefolgt von Enter.

### Name, Email-Adrese und Kommentar

Jetzt kommen wir zur Eingabe der persönlichen Daten...

```
GnuPG erstellt eine User-ID, um Ihren Schlüssel identifizierbar zu machen.
```

Voller bzw. Realname:
```
Ihr Name: Florian Latzel
```

Die Email-Adresse, die unsere spätere UID wird...
```
Email-Adresse: florian@latzel.io
```

Die Email-Adresse `florian@latzel.io`, gefolgt von Enter.

Und ein optionaler Kommentar, den wir mit Enter überspingen.
```
Kommentar: 
```

Es folgt eine letzte Überprüfung:
```
Sie haben diese User-ID gewählt:
    "Florian Latzel <florian@latzel.io>"
```

```
Ändern: (N)ame, (K)ommentar, (E)-Mail oder (F)ertig/(A)bbrechen? F
```
Wir wollen die Schlüsselerstellung abschließen und geben `F` gefolgt von Enter ein. 

```
Wir müssen eine ganze Menge Zufallswerte erzeugen.  Sie können dies
unterstützen, indem Sie z.B. in einem anderen Fenster/Konsole irgendetwas
tippen, die Maus verwenden oder irgendwelche anderen Programme benutzen.
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


Es gibt Falle, in dem du deinen Schlüssel auf den Keyservern widerrufen möchtest, 
wie z.B. eine mittlerweile unzureichenede Stärke des Schlüssels, Schlüssel oder Rechner sind korrumpiert worden.

Mittlerweile generiert GnuPG (unter Ubuntu) via Default einen Widerrufszertifikat 
bei der Schlüsselerstellung(s.o).\\
Einen GnuPG Widerrufungsschlüssels solltest du unbedingt erstellen und sicher aufbewahren.

Erstellung des GNUPG Revoke-Keys, die Nutzer-ID kann EMail oder die Key-ID sein.
Hier mit `florian@latzel.io`, der Revoke-Key wird in die Datei `~/florian@latzel.io-F4F62999C3BA4866-revoke-key.rev` 
geschrieben.
```
gpg --gen-revoke florian@latzel.io > ~/florian@latzel.io-F4F62999C3BA4866-revoke-key.rev
```

GnuPG fragt, ob du mit der Erstellung des Widerrufszertifikat fortfahren möchtest,
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

Wir bekommen noch ein Tipps für den Umgang mit den Widerrufszertifikat mit:
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

## Dem GPG-Key weitere Email Adressen (Unterschlüssel) hinzufügen


Mehrere Email Adressen mit einem GPG-Key nutzen.

Statt der Erstellung eines neuen Schlüssels für jede weitere Emailadresse,
besteht die Möglichkeit einem Schlüssel weitere Identitäten hinzufügen. 
```
gpg --edit-key 3F9F644542DD63E82165D376F4F62999C3BA4866
```
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

Wir befinden uns jetzt im interaktiven Modus von gnupg, 
mit `adduid` initieren die Erstellung des Unterschlüssels.
```
gpg> adduid
```

Wie bei der Erstellung des Schlüssels, 
wird bei dem Erzeugen eines Unterschlüssels nach einem Namen...
```
Ihr Name: Florian Latzel
```

und einer Email-Adresse gefragt.
```
Email-Adresse: florian.latzel@is-loesungen.de
```

Kommentar: Wenn gewollt, kann auch der Unterschlüssel kommentiert werden.
```
Kommentar: 
```

Abschließend eine Zusammenfassung der gemachten Angaben, 
die wir mit `F` bestätigen:
```
Sie haben diese User-ID gewählt:
    "Florian Latzel <florian.latzel@is-loesungen.de>"

Ändern: (N)ame, (K)ommentar, (E)-Mail oder (F)ertig/(A)bbrechen? F
```

Hier geht Pinentry auf und verlangt die Eingabe der Passphrase 
des geheimen OpenPGP Schlüssels.

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

```
gpg> save 
```
Nach dem Speichern mit `save` verlassen wir den interaktiven Modus von gpg 
und bekommen wieder den Prompt der Shell zu sehen.

## Konfiguration von GnuPG

### ~/.gnupg/options

Konfiguration von GnuPG in *~/.gnupg/options*.

Unter Debian und Ubuntu heißt die zuständige Konfigurationsdatei options, diese befindet in unserem Heimatverzeichnis im Verzeichnis .gnupg.

Bei default-key wird die Schlüssel-ID unseres Hauptschlüssels angegeben,
die Direktive keyserver ist für die Interaktion mit den Keyservern im Internet zuständig.
```
default-key 269B69D1
keyserver hkp://wwwkeys.eu.pgp.net
charset utf-8
use-agent
```

*~/.gnupg/gpg.conf*, unter opensuse 11 heißt das Pedant zu *~/.gnupg/options* unter Debian *gpg.conf*, die Inhalte sind gleich.

### ~/.gnupg/gpg-agent.conf

Konfiguration des gpg-agents in *~/.gnupg/gpg-agent.conf*


```
pinentry-program /usr/bin/pinentry-qt
no-grab
default-cache-ttl 1800

debug-level basic
log-file socket:///home/florian/.gnupg/log-socket
```

...to be continued.

## Arbeiten mit GnuPG

Eine Kurzreferenz von GnuPG-Befehlen und -Optionen die öfter mal benutzt werden.

### Arbeiten mit Private-Keys

Sichern der Private-Keys. 

Für eine Sicherheitskopie oder das Arbeiten auf mehreren Maschinen exportieren wir den Geheimen Schlüssel (Private Key).
Dieser sollte auf einem externen Datenträger gespeichert und an einem sicheren Ort aufbewahrt werden.

Um den den Schlüssel auf einen anderen Rechner zu transferieren sollte eine verschlüsselte Verbindung benutzt werden.
```
gpg --export-secret-key 269B69D1 > 269B69D1-private.key
```

Private-Keys auflisten. Analog zur Auflistung der Public-Keys geht dies auch mit den Private-Keys,
alternativ steht noch -K als Shortoption zur Verfügung.
```
gpg --list-private-keys
```

Private-Key löschen. Um einen privaten Key zu löschen wird das folgende Kommando verwendet, 
der zu löschende Schlüssel muss durch Key-ID oder EMail angegeben werden.
```
gpg --delete-private-keys 269B69D1
```

### Arbeiten mit Public-Keys

Operationen mit den Public-Keys.

Public-Keys auflisten. Erzeugt eine Auflistung aller Public-Keys im Keyring.
```
gpg --list-keys
```

Es erscheint unser frisch erzeugter Schlüssel

Fingerprint ausgeben. Analog zur Ausgabe wie mit --list-keys lässt zusätzlich noch der Fingerprint anzeigen.
```
gpg --fingerprint
```

Der Fingerprint besteht aus 10 4er Paaren(hexadezimal), die letzen 2 4er Paare sind gleichzeitig die Key-ID.
Die Key-ID müssen wir uns für den nächsten Schritt merken.
```
B043 7BFD 2D37 E901 4F88 2463 7681 46CD 269B 69D1
```

Public-Keys in Datei exportieren. 

Den Public-Key in eine ASCII-Armored Datei exportieren, die Angabe des Schlüssels erfolgt über Key-ID oder die E-Mailadresse.
```
gpg --export -a -o f-punkt-latzel-ät-loesungen-de.asc f punkt-latzel ät loesungen punkt de
```

Public-Key aus Datei importieren. Mit dem folgendem Befehl wird Keyring importiert.
```
gpg --import <Datei>
```

### Arbeiten mit Keyservern

#### Public-Key auf Keyserver keys.openpgp.org veröffentlichen

**Platzhalter für Intro, Screenshots und curl + Double OptIn**

#### Public-Key an Keyserver senden

Damit unser öffentlicher Schlüssel jedem zur Verfügung stehen kann, exportieren wir ihn auf den Schlüsselserver[^4].
```
gpg --send-key 269B69D1
```

Bei dem Zusammenspiel von GnuPG und Schlüsselservern(keyserver) kann man den Keyserver spezifizieren,
ohne explizite Angabe des Keyservers, wird der in der ~/.gnupg/options definierte Keyserver verwendet.
```
gpg --keyserver subkeys.pgp.net --send-key 269B69D1
```

#### Schlüssel auf Keyserver suchen

Suche nach EMail-Adresse (uid) 
```
gpg --search-keys florian@latzel.io
```
oder Key-ID
```
gpg --search-keys F4F62999C3BA4866
```

Bei einer erfolgreichen Suchanfrage besteht die Möglichkeit, 
gefundenen Schlüssel interaktiv in den Schlüsselbund zu importieren.
Im folgenden Besispiel geschieht das 
über die Eingabe der Nummer des Schlüssels hier `1`,
für den einen gefundenen Schlüssel `(1)`, erkennbar in Zeile 2.

```
gpg: data source: https://keys.openpgp.org:443
(1)     Florian Latzel <floh@netzaffe.de>
        Florian Latzel <florian.latzel@gmail.com>
        Florian Latzel <florian.latzel@is-loesungen.de>
        Florian Latzel <florian@latzel.io>
          4096 bit RSA key F4F62999C3BA4866, erzeugt: 2021-07-01
Keys 1-1 of 1 for "florian@latzel.io".  Eingabe von Nummern, Nächste (N) oder Abbrechen (Q) > 1
```

Die Suche nach Namen oder Teilstring der E-Mail Adresse 
klappt aus Datenschutzgründen auf keys.openpgp.org nicht.

Durch Angabe eines anderen Keyservers ist dies aber dennoch möglich:

Suche nach Namen...
```
gpg --keyserver pgp.mit.edu --search-keys 'Florian Latzel' 
```
Suche Teilstring Domain der E-Mail Adresse...
```
gpg --keyserver pgp.mit.edu --search-keys 'is-loesungen.de' 
```

#### Public-Key von Keyserver importieren

Um einen Public-Key, dessen Key-ID bekannt ist vom Keyserver herunterzuladen, wird die folgende Options verwendet.
```
gpg --recv-keys 269B69D1
```

#### Schlüssel widerrufen

Den Revoke-Key importieren.

Um den Revoke-Key nutzen zu können, muß dieser in unseren Keyring importiert werden.
```
gpg --import 269B69D1-revoke-key.asc
```

Schlüssel auf Server widerrufen. 

Wir senden unseren Keyring, in dem sich jetzt unser Revoke-Key befindet zum Keyserver, um ihn dort zu widerufen.
Alternativ zur Key-ID kann auch der Fingerabdruck verwendet werden.
```
gpg --send-keys 269B69D1
```
## Historie

- Aktualisierungen und Ergänzungen: Juli 2021 bis 2023, 
basierend auf einem mit gpg 2.2.4 neu erstellten Schlüssel im Juli 2021.
- Veröffentlicht am 2008-11-26 auf Basis von gpg in der Version 1.4.6
und pinentry 0.7.2 auf Debian Etch. Getestet wurden:
  - Ubuntu 8.04 mit gpg 1.4.6 und pinentry 0.7.4
  - openSuSE 11 mit gpg2 2.0.9-22.1 und pinentry 0.7.5-5.1
  - Windows Vista mit gnupg-w32cli-1.4.9.exe

## Software für die GnuPG Nutzung

Diverse nützliche Software für die Nutzung von GnuPG unter Windows, 
Mac OS, die Integration in Mail-Clients, Datei Browser oder Ähnliches.

- [Enigmail - GnuPG Integration für Mozilla Applikationen wie z.B. Thunderbird](https://www.enigmail.net/index.php/en/)
- [gpg4win - EMail-Sicherheit mit GnuPG für Windows, u.a. Outlook- oder Explorer Integration](https://www.gpg4win.org/index-de.html)
- [GPG Suite (GPG Tools) für die Nutzung Mac OS, wie z.B. Einbindung in Apple Mail](https://gpgtools.org/)
- [signing-party - Diverse nützliche OpenPGP für Tools für Keysigning-Partys](https://packages.debian.org/search?keywords=signing-party)[^5]

## Weiterführendes zu GnuPG & Fußnoten

- [GNU Privacy Guard - Wikipedia](http://de.wikipedia.org/wiki/GNU_Privacy_Guard)
- [Das GNU-Handbuch zum Schutze der Privatsphäre](https://www.gnupg.org/gph/de/manual/book1.html)
- [Deutsches GPG Mini Howto auf gnupg.org](https://www.gnupg.org/howtos/de/GPGMiniHowto.html#toc1)
- [GPG Schlüsselverwaltung für apt-get(Secure APT)](https://linux.spiney.org/gpg_schlusselverwaltung_fur_apt_get)
- [GnuPG in der Debian-Referenz](https://www.debian.org/doc/manuals/debian-reference/ch10.de.html#_data_security_infrastructure)
- [GnuPG auf ubuntuusers.de](wiki.ubuntuusers.de/GnuPG)
- [Das GnuPG Keysigning-Party HOWTO von V. Alex Brennen](https://rhonda.deb.at/projects/gpg-party/gpg-party.de.html)
- [GPG und Vim](https://wiki.debianforum.de/Vim_mit_gnupg)
- [PGP-Keyserver mit Webfrontend](https://pgp.mit.edu/)
- [RFC2440: OpenPGP Message Format](https://www.ietf.org/rfc/rfc2440.txt)
- [RFC2015: MIME Security With Pretty Good Privacy(PGP)](https://www.ietf.org/rfc/rfc2015.txt)
- [Die c't-Krypto-Kampagne - Abhörsichere E-Mail mit PGP](https://www.heise.de/security/dienste/Krypto-Kampagne-2111.html)
- [Einfach erklärt: E-Mail-Verschlüsselung mit PGP](https://www.heise.de/ct/artikel/Einfach-erklaert-E-Mail-Verschluesselung-mit-PGP-4006652.html)

[^1]: [Public-Key Verschlüsselungsverfahren](https://de.wikipedia.org/wiki/Public-Key-Verschl%C3%BCsselungsverfahren)
[^2]: [Öffentlicher Schlüssel](https://de.wikipedia.org/wiki/%C3%96ffentlicher_Schl%C3%BCssel)
[^3]: [Privater Schlüssel](https://de.wikipedia.org/wiki/Geheimer_Schl%C3%BCssel)
[^rfc4880]: [RFC 4880 - OpenPGP Message Format](https://datatracker.ietf.org/doc/html/rfc4880)
[^4]: [Schlüsselserver](https://de.wikipedia.org/wiki/Schl%C3%BCsselserver)
[^5]: [Keysigning-Party](https://de.wikipedia.org/wiki/Keysigning-Party)


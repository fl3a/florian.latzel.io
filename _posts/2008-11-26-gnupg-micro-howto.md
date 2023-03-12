---
date: 2008-11-26 07:43
last_modified_at: 2019-03-31 2019-03-31 18:59 
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
title: GnuPG (GPG) Micro Howto
image: /assets/imgs/1280px-GnuPG.svg.png
---
<figure role="group">
  <img src="/assets/imgs/1280px-GnuPG.svg.png" alt="GnuPG Logo 1280x387" title="GnuPG Logo" />
  <figcaption>GnuPG Logo, Thomas Wittek, GnuPG Projekt, Gemeinfrei</figcaption>
</figure>
*Gnu Privavy Guard* oder GnuPG (gpg)  ist eine freie Kryptographiesoftware, 
die das *OpenPGP Message Format* gemäß *RFC 4880[^rfc4880]* implementiert
und unter Windows, Android, MacOS und Linux sowie anderen unixioden System verfügbar ist. 

Die primären Anwendungsgebiete sind die Sicherstellung von Integrität
bzw. vertraulicher digitaler Kommunikation und Privatsphäre.
Beispiele für Integrität sind signierte Emails
oder signierte Softwarepakete wie z.B. unter Debian,
durch die man Echtheit und Quelle überprüfen kann.
Das wohl bekannteste Beispiel für die Sicherstellung von digitaler Privatsphäre, 
ist neben dem Ver- und Entschlüsseln von Dateien die verschlüsselte Emailkommunikation

Dieses Howto beschreibt unter anderem die [Erstellung eines GnuPG Schlüsselpaares](
/gnupg-micro-howto.html#erstellung-eines-gnupg-schlüsselpaares), 
das [Hinzufügen weiterer Emailadressen als Unterschlüssel](
/gnupg-micro-howto.html#dem-gpg-key-weitere-email-adressen-unterschlüssel-hinzufügen),
die [Konfiguration von GnuPG](/gnupg-micro-howto.html#konfiguration-von-gnupg)
und des GPG-Agents,
der [Einrichtung eines Web Key Directories (WKD Direct Method)](
/gnupg-micro-howto.html#wkd-einrichten) 
und gebräuchliche Anwendungsfälle auf der Kommandozeile (gpg), 
wie z.B. dem [Arbeiten mit Keyservern](
/gnupg-micro-howto.html#arbeiten-mit-keyservern)[^4].    
Es ist auf die oben genannten Systeme übertragbar.<!--break-->

Inhaltverzeichnis
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

## Unterschlüssel: mehrere Emailadressen mit einem GPG-Key nutzen

Mehrere Email Adressen mit einem GPG-Key nutzen.

Statt der Erstellung eines neuen Schlüssels für jede weitere Emailadresse,
besteht die Möglichkeit einem Schlüssel weitere Identitäten hinzufügen. 

### Weitere Emailadresse (User-ID) hinzufügen

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

Hier geht ein *Pinentry* Dialog auf, der zu Entsperrung des geheimen OpenPGP Schlüssels
die entsprechende Passphrase verlangt.

{%responsive_image figure:true 
path:assets/imgs/gnupg/pinentry-passphrase-geheimen-openpgp-schluessel-entsperren.png
alt:"Pinentry Dialog: Eingabe der Passphrase zum entsperren des geheimen OpenPGP Schlüssels" %}

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

### Unterschlüssel (User-ID) entfernen

	gpg --edit-key B0437BFD2D37E9014F882463768146CD269B69D1


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

	gpg> uid 1

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

	gpg> deluid



	Diese User-ID wirklich entfernen? (j/N) y

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

	gpg> save

## Konfiguration von GnuPG

### ~/.gnupg/options

Grundlegende Konfiguration von gnupg in ~/.gnupg/options

- `default-key`, Schlüssel-ID unseres Hauptschlüssels
- `keyserver` ist für die Interaktion mit den Keyservern im Internet zuständig
- `require-cross-certification`, Schutz vor sog. *Subtle Angriffen* auf Subkeys beim signieren (Default).
Siehe auch  `no-require-cross-certification`.
- `use agent`, Dummy Option, wird immer benötigt
 
```
default-key 3F9F644542DD63E82165D376F4F62999C3BA4866
charset utf-8
require-cross-certification
use-agent
keyserver hkps://keys.openpgp.org  
```

### ~/.gnupg/gpg-agent.conf

Konfiguration des gpg-agents in *~/.gnupg/gpg-agent.conf*

- `default-cache-ttl`, Zeit in Sekunden, die ein Cache-Eintrags gülig ist
- `max-cache-ttl`, Maximale Zeit in Sekunden, die ein Cache-Eintrag gültig ist
- `ignore-cache-for-signing` Bypass des Passwort Caches bei Signing
- `no-grab` Zur Vorbeugung von sog. X-Sniffing-Angriffen bei Nutzung von Pinentry.
- `pinentry-program`, Absolute Pfadangabe dazu
```
default-cache-ttl 18000
max-cache-ttl 86400
ignore-cache-for-signing
no-grab
pinentry-program /usr/bin/pinentry-gnome3
debug-level basic
```

## Web Key Directory (WKD) 

- Einfaches Konzept zur Verteilung öffentlicher PGP-Schlüssel via HTTPS.
  - Viele Mailcients[^mcl] wie z.B. Thunderbird, Outlook (GpgOL) 
oder Failmail (via OpenKeychain) nutzen WKD autom.
  - 2 Methoden: Advanced und Direct, ich beziehe mich auf Direct. 
  - Funktionsweise: Schriitte, Email, Domain, Schema, Auslieferung Via SSL,


Schema für Direct: <https://latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb>
  - Verzeichnisstruktur


### WKD einrichten 

- Ein muss bei Zugriff auf (eigenen) Server und Domain
Sofern meine Domain[^domain] im hier genutzten Beispiel auf uberspace konfiguiert[^domain] ist
und ein entsprechender A- oder AAA-Eintrag existiert,
wird der Webserver den via WKD angefragten Key via SSL ausliefern.

So sehen auf spezifische Pfad für Uberspace der und die allgemeine *Web Key Directory* Verzeichnisstruktur 
für meine als Bespiel genutzte EMailadresse florian@latzel.io, also Domain *latzel.io* und dem dem WKD-Hash (Hashed-UserID) aus *florian* aus:

```
/var/www/virtual/${USER}/latzel.io
└── .well-known
    └── openpgpkey
        ├── hu
        │   ├── .htaccess
        │   └── qcuniwbujk3zrj7166onyz4t5cxgy3wb
        └── policy
```

Erzeugen der Verzeichnisstruktur für WKD:

    mkdir -p /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/hu

Symlink im Home Verzeichnis mit Namen der Domain erstellen:
    
    ln -s /var/www/virtual/${USER}/latzel.io ~/
    
Anlegen der (leeren) Datei *policy* :

    touch /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/policy


Damit der Webserver die benötigten HTTP-Header ausliefert legen wir eine .htaccess-Datei mit folgendem Inhalt an:

    vi /var/www/virtual/${USER}/latzel.io/.well-known/openpgpkey/hu/.htaccess


```
<IfModule mod_mime.c>
   ForceType application/octet-stream
   Header always set Access-Control-Allow-Origin "*"
</IfModule>
```


### Upload der Public Keys in das WKD

So kommst du an die WKD Hashes der EmailAdressen:\\
Die sog. hashed-userid, ist ein SHA1 Hash, der aus dem lokalen Teil(User/Prefix),
der anschließend mit dem *Z-Base-32 Verfahren* kodiert wird[^zbase32].

Die entspricht dem späteren Dateinamen.


    gpg --with-wkd-hash --fingerprint florian@latzel.io 

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

Das wäre `qcuniwbujk3zrj7166onyz4t5cxgy3wb` für `florian`, wie wir in Zeile 4 sehen.

Wir übertragen den Key auf dem Server, indem die Ausgabe von `gpg --export` an den SSH-Befehl via Pipe weitergeben.
So entsteht keine Datei, die wir gar nicht brauchen und nach der Übertragung löschen müssten.

    gpg --no-armor --export florian@latzel.io | ssh ssh-server-oder-ip "cat > latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb"

    
### Testen der Schlüsselerkennung via WKD

#### Via Zugriff auf HTTPS

Im Browser <https://latzel.io/.well-known/openpgpkey/hu/qcuniwbujk3zrj7166onyz4t5cxgy3wb> aufrufen,
es wird eine Datei zum Download angeboten.

...Via Curl: 

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

Ein Webfrontend zum testen des Deployments deiner Keys in ein *Web Key Directory*.

via <https://metacode.biz/openpgp/web-key-directory>

Screenshot

    
#### Via gpg

Während das Webfrontend alles mit OK quittiert moppert der WKD-Test via Kommandozeile...

    gpg -v --auto-key-locate clear,wkd,nodefault --locate-key florian@latzel.io 

```
gpg: using character set 'utf-8'
gpg: verwende Vertrauensmodell pgp
gpg: Schlüssel F4F62999C3BA4866: Als vertrauenswürdiger Schlüssel akzeptiert
gpg: Fehler beim automatischen holen von `florian@latzel.io' über `WKD': Server zeigt einen unbestimmten Fehler an
gpg: Fehler beim automatischen holen von `florian@latzel.io' über `None': Kein öffentlicher Schlüssel
gpg: Schlüssel "florian@latzel.io" nicht gefunden: Kein öffentlicher Schlüssel
```
Nach einen Kaffee und ca. 10min später:

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

## Arbeiten mit Keyservern

Ende Juni 2019 [^sks1] [^sks2] wurde das SKS Keyserver Netzwerk angegriffen.
Web of Trust[^weboftrust].
- GnuPG Version 2.2.17 ignorierte standardmäßig alle Signaturen, die von einem Keyserver stammen. 
- SKS abgeschaltet 
- keyserver.ubuntu.com mit hockeypuck
- https://keys.mailvelope.com/
- De-Facto-Standard keys.openpgp.org betrieben mit Hagrid

### Public-Key auf keys.openpgp.org veröffentlichen

**Platzhalter für Intro, Screenshots und curl + Double OptIn**[^sks1] [^sks2] [^newkeys]

### Schlüssel auf Keyserver suchen

Suche nach EMail-Adresse (uid) 

	gpg --search-keys florian@latzel.io

oder Key-ID

	gpg --search-keys F4F62999C3BA4866


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

	gpg --keyserver keyserver.ubuntu.com --search-keys 'Florian Latzel' 

Suche Teilstring Domain der E-Mail Adresse...

	gpg --keyserver keyserver.ubuntu.com --search-keys 'netzaffe.de' 

### Public-Key von Keyserver importieren

Um einen Public-Key, dessen Key-ID bekannt ist vom Keyserver herunterzuladen, wird die folgende Options verwendet.

	gpg --recv-keys F4F62999C3BA4866


### Schlüssel widerrufen

#### Primärschlüssel widerrufen

Den Revoke-Key importieren.

Um den Revoke-Key nutzen zu können, muß dieser in unseren Keyring importiert werden.

	gpg --import 269B69D1-revoke-key.asc


#### Unterschlüssel (User-ID) widerrufen

	gpg --edit-key B0437BFD2D37E9014F882463768146CD269B69D1

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

	gpg> 9


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

	revuid


	Diese User-ID wirklich widerrufen? (j/N) j

```  
Grund für den Widerruf:
  0 = Kein Grund angegeben
  4 = User-ID ist nicht mehr gültig
  Q = Abbruch
(Wahrscheinlich möchten Sie hier 4 auswählen)
```  

	Ihre Auswahl? 4
	
```  
Geben Sie eine optionale Beschreibung ein. Beenden mit einer leeren Zeile:
> 
```  
```  
Grund für Widerruf: User-ID ist nicht mehr gültig
(Keine Beschreibung angegeben)
```  

	Ist das OK? (j/N) j

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

#### Schlüssel auf Keyserver widerrufen. 

Emailsadressen auf dem Server sschen auf https://keys.openpgp.org/manage via Double-Opt-In.

Auf Hockeypuck  

Wir senden unseren Keyring, in dem sich jetzt unser Revoke-Key befindet zum Keyserver, um ihn dort zu widerufen.
Alternativ zur Key-ID kann auch der Fingerabdruck verwendet werden.

	gpg --send-keys F4F62999C3BA4866

## Historie dieses Howtos

- 2021-06 - heute: Aktualisierungen und Ergänzungen 
basierend auf einem mit gpg 2.2.4 neu erstellten Schlüssel im Juli 2021 unter Ubuntu.
  - Aktualisierung: Schlüsselerstellung und Subkeys
  - Überarbeitung: Text allgemein und Struktur
  - Neu: User-ID entfernen (deluid)
  - Neu: WKD und Einrichtung
  - Neu: Nutzung von keys.openpgp.org 
  - Neu: User-ID widerrufen (revuid)
- 2008-11-26: Veröffentlichung. Basis war gpg in der Version 1.4.6   
und pinentry 0.7.2 unter Debian Etch.  
Getestet wurden:
  - Ubuntu 8.04 mit gpg 1.4.6 und pinentry 0.7.4
  - openSuSE 11 mit gpg2 2.0.9-22.1 und pinentry 0.7.5-5.1
  - Windows Vista mit gnupg-w32cli-1.4.9.exe

Siehe [Changelog](
https://github.com/fl3a/florian.latzel.io/commits/master/_posts/2008-11-26-gnupg-micro-howto.md) 
für weitere Details

## Weiterführendes zu GnuPG

### Credits

Credits für den WKD Teil:
- <https://www.kuketz-blog.de/gnupg-web-key-directory-wkd-einrichten/>
- <https://lab.uberspace.de/guide_wkd/>

Danke an die Autoren🙏!

### Weiterführende Artikel

- [GNU Privacy Guard - Wikipedia](http://de.wikipedia.org/wiki/GNU_Privacy_Guard)
- [Das GNU-Handbuch zum Schutze der Privatsphäre (2000)](https://www.gnupg.org/gph/de/manual/book1.html)
- [Einfach erklärt: E-Mail-Verschlüsselung mit PGP](https://www.heise.de/ct/artikel/Einfach-erklaert-E-Mail-Verschluesselung-mit-PGP-4006652.html)
- [Die c't-Krypto-Kampagne - Abhörsichere E-Mail mit PGP](https://www.heise.de/security/dienste/Krypto-Kampagne-2111.html)
- [GnuPG in der Debian-Referenz](https://www.debian.org/doc/manuals/debian-reference/ch10.de.html#_data_security_infrastructure)
- [GnuPG auf ubuntuusers.de](https://wiki.ubuntuusers.de/GnuPG)
- [GPG Schlüsselverwaltung für apt-get(Secure APT)](https://linux.spiney.org/gpg_schlusselverwaltung_fur_apt_get)
- [GPG und Vim](https://wiki.debianforum.de/Vim_mit_gnupg)
- [RFC2440: OpenPGP Message Format](https://www.ietf.org/rfc/rfc2440.txt)
- [RFC2015: MIME Security With Pretty Good Privacy(PGP)](https://www.ietf.org/rfc/rfc2015.txt)

### Software für die GnuPG Nutzung

Diverse nützliche Software für die Nutzung von GnuPG unter Windows, 
Android, Mac OS, die Integration in Mail-Clients, Datei Browser oder Ähnliches.

- [Thunderbird Mailclient (unterstützt OpenPGP seit Version 78 direkt)](
https://www.thunderbird.net/de/)
- [gpg4win - GnuPG für Windows, 
u.a. Outlook- (GpgOL) oder Explorer Integration (GpgEX)](
https://www.gpg4win.org/index-de.html)
- [OpenKeychain - Android OpenPGP Integration](https://www.openkeychain.org/)
- [Enigmail - GnuPG Integration und Addons. 
Ursprünglich für  Thunderbird entwickelt](https://www.enigmail.net/index.php/en/)
- [GPG Suite (GPG Tools) für die Nutzung Mac OS, 
wie z.B. Einbindung in Apple Mail](https://gpgtools.org/)
- [signing-party - 
Diverse nützliche OpenPGP für Tools für Keysigning-Partys](
https://packages.debian.org/search?keywords=signing-party)[^5]


### Fußnoten

[^1]: [Public-Key Verschlüsselungsverfahren](https://de.wikipedia.org/wiki/Public-Key-Verschl%C3%BCsselungsverfahren)
[^2]: [Öffentlicher Schlüssel](https://de.wikipedia.org/wiki/%C3%96ffentlicher_Schl%C3%BCssel)
[^3]: [Privater Schlüssel](https://de.wikipedia.org/wiki/Geheimer_Schl%C3%BCssel)
[^rfc4880]: [RFC 4880 - OpenPGP Message Format](https://datatracker.ietf.org/doc/html/rfc4880)
[^4]: [Schlüsselserver](https://de.wikipedia.org/wiki/Schl%C3%BCsselserver)
[^5]: [Keysigning-Party](https://de.wikipedia.org/wiki/Keysigning-Party)
[^newkeys]: [Neuer OpenPGP-Keyserver liefert endlich verifizierte Schlüssel - heise.de](https://www.heise.de/security/meldung/Neuer-OpenPGP-Keyserver-liefert-endlich-verifizierte-Schluessel-4450814.html)
[^domain]: [Domains - Uberspace Manual  ](https://manual.uberspace.de/web-domains.html)
[^mcl]: [Mailclients mit WKD Unterstützung - GnuPG Wiki](https://wiki.gnupg.org/WKD#Mail_Clients)
[^zbase32]: [Z-Base-32 converter – cryptii](https://cryptii.com/pipes/z-base-32)
[^sks1]: [SKS Keyserver Network Under Attack - rjhansen](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f)
[^sks2]: [Verschlüsselte Kommunikation: Angriff auf PGP-Keyserver demonstriert hoffnungslose Situation - heise.de](https://www.heise.de/security/meldung/Angriff-auf-PGP-Keyserver-demonstriert-hoffnugslose-Situation-4458354.html)
[^weboftrust]: [PGP: Der langsame Tod des Web of Trust - heise.de](https://www.heise.de/hintergrund/PGP-Der-langsame-Tod-des-Web-of-Trust-4467052.html)

*[RFC]: Request for Comment
*[WKD]: Web Key Directory
*[SSL]: Secure Socket Layer
*[PGP]: Pretty Good Privacy
*[HTTPS]: Hypertext Transfer Protocol Secure
*[SKS]: Synchronizing Key Server

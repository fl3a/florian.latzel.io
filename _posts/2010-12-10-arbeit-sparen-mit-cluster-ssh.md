---
title: Arbeit sparen mit Cluster SSH
tags:
- ubuntu
- ssh
- nützlich
- Linux
nid: 1000
layout: post
created: 1292019984
image: /assets/imgs/cssh-4-xterms.png
last_modified_at: 2019-05-11
---
<figure role="group">
  <img src="/assets/imgs/cssh-4-xterms.png" alt="ClusterSSH mit 4 XTerms und Controller in der Mitte" />
  <figcaption>ClusterSSH mit 4 XTerms und Controller in der Mitte</figcaption>
</figure>
Nachdem sich bei einem Rechnerverbund mal wieder Updates angehäuft haben, stand bis jetzt normalerweise immer die folgende Prozedur an:

- `ssh server1`
- `aptitude safe-upgrade`
- `exit`
- `ssh server2`
- `aptitude safe-upgrade`
- `exit`
- ...
- `ssh serverN`
- `aptitude safe-upgrade`
- `exit`

Ich hatte noch einen Artikel aus dem Linux-Magazin im Kopf (Ausgabe 1/11, S. 85, Charly Künast: "Sponton simultan"), indem der gute Charly einen möglichen Lösungsansatz für mich parat hält um N Schritte zu einem zusammen fassen zu können. Die Lösung heißt ClusterSSH. <!--break-->

**Installation von ClusterSSH unter Ubuntu**

```
aptitude install clusterssh
```

In *~/.csshrc* die Direktive 
*extra_cluster_file* mit unserer zukünftigen Konfigurationsdatei für die Cluster erweitern: `extra_cluster_file=~/.csshrc.clusters`

**Anlegen eines Clusters**

Anlegen eines Rechnerverbundes in  *~/.csshrc.clusters* (in diesem Fall ist für alle Rechner ein entsprechender _SSH-Public-Key_ hinterlegt): 


```
# Cluster honky
honky honky1 honky2:3419 ez@honky3 honkyN
```

Für ein Login auf allen in _Cluster honky_ eingetragen Rechner reicht jetzt ein: `cssh honky`.

Nach ein erfolgreichem Befehl stehen dann _N_ Xterms zur Verfügung, die über den "Controller", hier in der Mitte angesprochen werden können.


**Arbeiten mit mehreren Clustern**

Bei der Nutzung von mehreren Clustern wird im Gegensatz zum obigen Beispiel eine andere Syntax in *~/.csshrc.clusters* genutzt: 

```
clusters = honky bonk all
    
# Cluster honky
honky = honky1 honky2:3419 ez@honky3 honkyN
    
# Cluster bonk
bonk = bonk1 honkmaster@bonk2 bonk3:3419 bonkN
    
# Cluster all
all = honky bonk
```

In Zeile 1 werden über die Direktive *clusters* die verfügbaren Cluster definiert. 

In den Zeilen 4 und 7 werden analog zum Anlegen eines Clusters die Maschinen,
den in Zeile 1 definierten Clustern zugewiesen, 
wobei hier hinter dem Namen des Clusters ein Gleichheitszeichen (=) stehen muss, 
die jeweiligen Rechner folgen wie oben mit Leerzeichen getrennt. 

In Zeile 10 werden unter *all* oben konfigurierten Cluster wieder zu einen Verbund zusammengefasst.

**Fazit**

Bei absehbarer Wiederverwendung spart das, trotz des einmaligen Mehraufwandes der Konfiguration in Zukunft eine Menge unötigen Aufwand. 

Mehr unter [cssh(1) - Linux man page](http://linux.die.net/man/1/cssh) (man cssh).

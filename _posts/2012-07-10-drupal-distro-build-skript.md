---
tags:
- snippet
- Installations Profile
- drush
- Drupal
- "#!/bin/bash"
nid: 1609
layout: post
title: Drupal-Distro-Build-Skript
created: 1341939334
last_modiefied_at: 2021-04-05
---
Das Testen von Drupal-Installationsprofilen ist relativ mühselig, da sich ein Teil der Schritte, bis man überhaupt erst zum Testen der eigentlichen Funktionalität kommt,
mit dem Build-Prozess beschäftigt.

Diesen muß man eigentlich für jede Änderung erneut durchlaufen...
<ol class="decimal">
 <li>Drush make (das macht es im Falls des <a href="https://github.com/fl3a/fserver_profile">Feature-Server-Installations-Profiles</a>)
<ol class="decimal">
   <li>Drush make mit <em>distro.make</em> aus dem Git-Repository </li>
   <li>Download des Drupal-Cores</li>
   <li>Klonen des in <em>distro.make</em> hinterlegten Repositories für das Installationsprofil</li>
   <li>Rekursive Suche nach weiteren Drush-Makefiles,
   runterladen der Drupal-Module und des Themes, die im gefundenen Makefile <em>drupal-org.make</em> spezifiziert sind</li> 
  </ol>
  </li>
 
 <li>Sybolischer-Link vom erstellten Build auf die DocumentRoot des für Testzwecke angelegten VirtualHosts</li>
 <li>Drop auf alle Tabellen in der Zieldatenbank</li>
 <li>Installation von Drupal und einem bestimmtem Installationsprofiles, hier <em>fserver_profile</em></li>
</ol>
In der scheinbaren Routine des manuellen Durchlaufen dieser Schritte entsteht zudem auch mal schnell ein Fehler.

So habe ich beim gefühlt 100sten Mal des Durchlaufens dieser Prozedur versehentlich in der falschen Datenbank alle Tabellen <em>ge-dropt-t</em> und dachte mir, Automatisierung muss her, schreib ein Shellskript...
<!--break-->
<h2>Vorraussetzungen</h2>
Neben den <em><a href="http://drupal.org/requirements/">Standard-System-Vorrausetzungen</a></em> für Drupal, wird zusätzlich folgendes für das Bash-Skript benötigt:
<ul>
 <li><a href="http://git-scm.com/">git</a></li>
 <li><a href="http://drupal.org/project/drush">drush</a></li>
 <li><a href="http://drupal.org/project/drush_make">drush make</a><br />Falls Drush vor v.5 genutzt wird
</li>
 <li><a href="http://drupal.org/project/drush_site_install6">drush site-install 6.x</a><br />Falls Drush vor v.4  mit Drupal-6.x genutzt wird</li>
</ul>
Zur Ausführung sollte sich das Skript im Suchpfad <em>$PATH</em> befinden, kann aber natürlich auch mit einem vorangestellten <em>bash</em> gestartet werden.

<h2>Das Skript</h2>
Einfaches Bash-Skript welches die o.g. Schritte durchläuft.

Das <em>droppen</em> der Tabellen in der Zieldatenbank erfolgt über <em>drush site-install</em>.
```
#!/bin/bash

# Treat unset variables as an error
set -o nounset

# Source configuration
source $1 || exit 126

echo -e "${BUILD}"

##
# Needed executables & drush commands
#
DRUSH=$(which drush) &> /dev/null \
  || { echo 'Missing drush. Aborting...' >&2; exit 127; } 

# Specific path to drush version for drush site-install
set +o nounset
[ -z "$DRUSH_SITE_INSTALL_DRUSH" ] && DRUSH_SITE_INSTALL_DRUSH=${DRUSH}
set -o nounset

which git &> /dev/null \
  || { echo 'Missing git. Aborting...'>&2; exit 127; }

drush help make &> /dev/null \
  || { echo "Could not probe 'drush make'. Aborting...">&2; exit 127; }

${DRUSH_SITE_INSTALL_DRUSH} help site-install &> /dev/null \
  || { echo "Could not probe 'drush site-install'. Aborting...">&2; exit 127; }


##
# run drush make
#
cd ${WEB_DIR}
echo -e "# Running drush make, create new build ${BUILD} with ${BUILD_MAKEFILE}...\n"
${DRUSH} make ${MAKE_OPTIONS} ${BUILD_MAKEFILE} ${BUILD} 2>&1 \
  && echo -e "\n# Creating build ${BUILD} was successful\n" \
  || { echo -e "\nFAILED!\n"; exit 1; }

##
# link new build to docroot
#
if [ -L ${DOC_ROOT} ] ; then
  echo -ne "# Symlink ${BUILD} already exists, unlink ${BUILD}... " 
  unlink ${DOC_ROOT} 2>&1 \
    && echo -e "done\n" \
    || { echo -e  "FAILED!\n"; exit 2; }	  
fi
echo -ne "# Symlink ${BUILD} to ${WEB_DIR}/${DOC_ROOT}... "
ln -s ${BUILD} ${DOC_ROOT} 2>&1 \
  && echo -e "done\n" \
  || { echo -e "FAILED!\n"; exit 3; }

##
# run drush site-install (and drop existing tables)
#
echo -e "# Running drush site-install...\n"
${DRUSH_SITE_INSTALL_DRUSH} site-install ${BUILD_PROFILE} ${SI_OPTIONS} -y -r ${WEB_DIR}/${DOC_ROOT} \
 --db-url=${DB_DRIVER}://${DB_USER}:${DB_PASS}@${DB_HOST}/${DB} \
 --account-name=${DRUPAL_UID1} \
 --account-pass=${DRUPAL_UID1_PASS} \
 --account-mail=${DRUPAL_UID1_MAIL} \
 --site-mail=${DRUPAL_SITE_MAIL} \
 --site-name=${DRUPAL_SITE_NAME} 2>&1 \
 && echo -e "\n# Site installation was successful." \
 || { echo -e "\n# FAILED!"; exit 4; }

exit 0 
```


<h2>Konfiguration</h2>
Die vom Skript benötigten Variablen, befanden sich in einer früheren Version zwischen der Interpreterdeklaration und <em>set -o nounset</em>, diese habe ich ausgelagert um das Arbeiten mit verschiedenen Branches und Projekten einfacher zu gestalten.

Die Konfiguration wird dem Skript als Parmeter beim Aufruf übergeben

```bash
# @file example build configuration

#
# Webserver specific
#

# Path of the directory 
# where to build should take place
WEB_DIR='/var/www/fserver6_builds'

# Name of DocumentRoot within $WEB_DIR 
# where the webserver should point to
DOC_ROOT='fserver6_build'

#
# Buid process specific
#

# Path to makefile 
BUILD_MAKEFILE='https://raw.github.com/fl3a/fserver_profile/master/drupal-org.make'

# Machine name of the profile that should be installed
BUILD_PROFILE='fserver_profile'

# Date prefix for build
BUILD_DATE=$(date +%Y%m%d%H%M%S)

# Name pattern for the build
BUILD=${DOC_ROOT}-${BUILD_DATE}

#
# Options for drush site-install
# @see drush help site-install
#

# Specific path to drush version for drush site-install command
DRUSH_SITE_INSTALL_DRUSH='/usr/local/share/drush-4.6/drush'

# --account-name Option
DRUPAL_UID1='Hochwohlgeboren'

# --ACCOUNT-PASS OPTION
DRUPAL_UID1_PASS='FbVZQkU5OAYmg'

# --account-mail
DRUPAL_UID1_MAIL='mail@example.com'

# --site-name Option
DRUPAL_SITE_NAME=${BUILD}

# --site-mail Option
DRUPAL_SITE_MAIL='mail@example.com'
#DRUPAL_SITE_MAIL=${DRUPAL_UID1_MAIL}

#
# Database specific settings to build db_url  
# ${DB_DRIVER}://${DB_USER}:${DB_PASS}@${DB_HOST}/${DB}
#

DB_DRIVER="mysqli"

DB_USER="fserver6_build"

DB_PASS="FbVZQkU5OAYmg"

DB_HOST="localhost"

DB="fserver6_build"

#
# Additional drush make options 
# @see drush help make
#

MAKE_OPTIONS='--nocolor --md5=print --no-patch-txt'

#
# Additional drush site-install (si) options
# @see drush help site-install
#

SI_OPTIONS='--nocolor'
```

<h2>Beispiele</h2>
<ol>
  <li>Einfacher Aufruf mit Ausgabe
    <code>
drupal_distro_build.sh fserver6_build.conf.sh
</code>
  </li>
  <li>
    Aufruf mit Mailversand der Ausgabe des Buildprozesses, der Betreff ist hier der Name des Builds<br />
    <code>
drupal_distro_build.sh fserver6_build.conf.sh |  mail -s `head -n 1`  mail@example.com</code>
  </li>
  <li>Aufruf mit Generierung eines Logfile, welches so heißt wie der Build + Suffix <em>.log</em>
  <code>
drupal_distro_build.sh fserver6_build.conf.sh | tee `head -n 1 `.log</code></li>

</ol>

<h2>Möglichkeiten</h2>
Mögliche Verwendung und Einsatzszenarien:
<ul>
 <li>In Git-Hooks</li>
 <li>In Continious Integration</li>
 <li>...und natürlich manuell</li>
</ul>

<h2>Quellen</h2>
Auf github, <a href="https://gist.github.com/3089178">Gist 3089178</a>

<code>
git clone git://gist.github.com/3089178.git drupal_distro_build
</code>

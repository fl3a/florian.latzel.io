---
tags:
- snippet
- howto
- MySQL
- Drupal
- Debian
- apache2
- ".htaccess"
nid: 989
layout: post
title: ".htaccess mit Authentifizierung an einer MySQL Datenbank (Drupal)"
created: 1265658992
---
Htaccess mit Authentifizierung an einer MySQL basierten Drupal-Installation.

Installation des benötigten Apache Moduls: `aptitude install libapache2-mod-auth-mysql`

Aktivierung des authmysql-Moduls: `a2enmod auth_mysql`
<!--break-->
Dieses Snippet in die jeweilige Apache-VirtualHost-Datei einfügen
```
<Directory /var/www/git>
  AuthName "Authentication required"
  AuthType Basic
  require valid-user
  AuthUserFile /dev/null
  AuthBasicAuthoritative Off
  Auth_MYSQL On
  Auth_MySQL_Host mysqlhost
  Auth_MySQL_User mysqluser
  Auth_MySQL_Password mysqlpasswd
  Auth_MySQL_DB drupaldb
  Auth_MySQL_Authoritative On
  Auth_MySQL_Password_Table users
  Auth_MySQL_Encryption_Types PHP_MD5
  Auth_MySQL_Encrypted_Passwords On
  Auth_MySQL_Empty_Passwords Off
  Auth_MySQL_Username_Field name
  Auth_MySQL_Password_Field pass
</Directory>
```

Was in unserm VirtualHost so aussieht:

```
<VirtualHost *>
  ServerName birgit.example.com
  ServerAdmin webmaster@example.com
  DocumentRoot /srv/gitosis/repositories
  SetEnv GITWEB_CONFIG /etc/gitweb.conf
  Alias /gitweb.css /usr/share/gitweb/gitweb.css
  Alias /git-logo.png /usr/share/gitweb/git-logo.png
  Alias /git-favicon.png /usr/share/gitweb/git-favicon.png
  ScriptAlias /gitweb.cgi /usr/lib/cgi-bin/gitweb.cgi
  DirectoryIndex gitweb.cgi
  <Directory /var/www/git>
    AuthName "Authentication required"
    AuthType Basic
    require valid-user
    AuthUserFile /dev/null
    AuthBasicAuthoritative Off
    Auth_MYSQL On
    Auth_MySQL_Host mysqlhost
    Auth_MySQL_User mysqluser
    Auth_MySQL_Password mysqlpasswd
    Auth_MySQL_DB drupaldb
    Auth_MySQL_Authoritative On
    Auth_MySQL_Password_Table users
    Auth_MySQL_Encryption_Types PHP_MD5
    Auth_MySQL_Encrypted_Passwords On
    Auth_MySQL_Empty_Passwords Off
    Auth_MySQL_Username_Field name
    Auth_MySQL_Password_Field pass
  </Directory>
</VirtualHost>
```

Aktivieren der site: `a2ensite birgit.example.com` 

Die Konfiguration des Apachen neu einlesen: `/etc/init.d/apache2 reload`

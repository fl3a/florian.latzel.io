---
title: install_postgres0.07.sh
layout: post
permalink: /node/515
date: 2004-12-22 11:18
tags:
- '#!/bin/bash'
- Cygwin
- m$
- PostgreSQL
---
```bash
#!/bin/sh

# date:         2003-07-23
# author:       Florian Latzel, bbsh2ala@bg.bib.de
# name:         install_postgres
# version:      0.07
# description:  -
# changes:      checks psql version number
#              (should be 7.3.3)
#              
# todo:         checks if needed programms are installed
#               (command --help>/dev/null)
#               ->Problem: stderr in logfile?
#               writing PGDATA in /etc/.profile
#               writing capitalized steps als in the logfile(tee?)

clear
echo -e "installing PostgresSQL 7.3.3 with cyipc-1.14-1 on win2k\n\
-------------------------------------------------------\n\
written by Florian Latzel, bbsh2ala@bg.bib.de\n\
based on the postgresql-7_3_3_README by maintainer Jason Tishler\n\n\
download cygipc-1.14-1.tar.bz2 from:\n\
http://www.neuro.gatech.edu/users/cwilson/cygutils/cygipc/index.html\n\
move or copy it into the CygWin root-directory\n\n\
NOTE:\nOn Windows XP Home, there is no built in way to assign user rights\n\
use ntrights instead.  This tool is available from \nthe Windows 2000 Resource Kit \n\
or :\n\
http://www.dynawell.com/reskit/microsoft/win2000/ntrights.zip\n\n\
to run POSTGRESQL under win9x ==> README\n\n"
echo -n "press any key to continue  "

while test -z $con
do
        read con
done

clear

echo "INSTALLATION FAILED\n">>install_postgres.log

echo -e "\nCHECKING PSQL VERSION"
if psql --version | grep -q 7\.3\.3
then
        echo "+ DONE"
else
        echo "- FAILED"
        echo "psql version is not 7.3.3" 2>>install_postgres.log
        more install_postgres.log
        rm install_postgres.log
        i=2
        exit $i
fi

echo -e "\nUNINSTALLING THE SERVICE IPC-DAEMON "
if cygrunsrv -R ipc-daemon 2>> install_postgres.log
then
        echo "+ DONE"
else   
        echo "- FAILED"
fi

echo -e "\nUNINSTALLING THE SERVICE POSTMASTER"
if cygrunsrv -R postmaster 2>> install_postgres.log
then
        echo "+ DONE"
else   
        echo "- FAILED"
fi

echo  -e "\nEXTRACTING CYGIPC"
if test -s /cygipc-1.14-1.tar.bz2
then
        rm -f /bin/ipc-daemon 2>> install_postgres.log
        bunzip2 -c /cygipc-1.14-1.tar.bz2|tar xvf -
        echo "+ DONE"
else
        echo "- FAILED"
        echo -e "NOTE\ncan not find cygipc-1.14-1.tar.bz2 in the root directory\
        \nmake sure that cygipc-1.14-1.tar.bz2 is in the root directory\
        \nand start install_psql again\n" >> install_postgres.log
        i=3
fi

while test "$i" -eq 0
do
        echo -e "\nINSTALLING IPC-DAEMON AS SERVICE"
        if ipc-daemon --install-as-service 2>> install_postgres.log
        then
                echo "+ DONE"
        else
                echo "- FAILED"
                i=4
        fi
       
        echo -e "\nCREATING THE \"postgres\" USER ACOUNT"
        if net user postgres $password /add /fullname:postgres \
        /comment:'PostgreSQL user account' \
        /homedir:"$(cygpath -w /home/postgres)" 2>> install_postgres.log
        then
                echo "+ DONE"
        else
                echo "- FAILED"
                i=5
        fi
        echo -e "\nCREATING \"postgres\" in /etc/passwd"
        if ! test "$i" = 5
        then
                mkpasswd -l -u postgres >>/etc/passwd
                echo "+ DONE"
                i=0
        else   
                echo "- FAILED"
                i=0
        fi
       
        echo -e "\nGRANT THE \"postgres\" USER THE \"LOG ON AS SERVICE\" USER RIGHT"
        sleep 5
        cmd /c secpol.msc
       
        echo -e "\nINSTALLING POSTMASTER"
        if cygrunsrv --install postmaster --path /usr/bin/postmaster\
        --args "-D /usr/share/postgresql/data -i" --dep ipc-daemon\
        --termsig INT --user postgres --shutdown  >&2 >> install_postgres.log
        then
                echo "+ DONE"
        else
                echo "- FAILED"
                i=6
                break
        fi
       
        echo -e "\nREMOVING /usr/share/postgres/data"
        if rm -r /usr/share/postgresql/data 2>> install_postgres.log
        then
                echo "+ DONE"
        else
                echo "- FAILED"
        fi
       
        echo -e "\nCREATING /usr/share/postgres/data"
        if mkdir /usr/share/postgresql/data  2>> install_postgres.log
        then
                echo "+ DONE"
                echo -e "\nWRITING PGDATA to /etc/profile"
                if echo "#psql's data directory">>/etc/profile&&\
                echo "#written by install_postgres">>/etc/profile&&\
                echo "PGDATA=/usr/share/postgresql/data">>/etc/profile&&\
                echo "export PGDATA">>/etc/profile
                then
                        echo "+ DONE"
                else
                        echo "- FAILED"
                        l=2
                fi
        else
                echo "- FAILED"
        fi
       
        echo -e "\nCHANGING OWNERSHIP OF /usr/share/postgres/data TO USER \"postgres\""
        if chown postgres /usr/share/postgresql/data  2>> install_postgres.log
        then
                echo "+ DONE"
        else
                echo "- FAILED"
                i=7
                break
        fi
       
        echo -e "\nSTARTING IPC-DAEMON"
        if net start ipc-daemon 2>> install_postgres.log
        then    
                echo "+ DONE"
                sleep 1
                #for testing
                clear
        else
                echo "- FAILED"
                i=8
                break
        fi
        if test "$i" -eq 0
        then    
                break
        fi
done

if test "$i" -gt 0
then
        more install_postgres.log
        rm install_postgres.log
        exit $i
else
        echo -e "\nINSTALATION COMPLETE\n\n\
login as postgres, intialize PostgreSQL with: "

if test l = 2
then
         echo -e " initdb -D /usr/share/postgresql/data\n\n"
else
         echo -e " initdb \n"
fi

echo -e "to run the database server type :\n\
net start postmaster\n\n\
to run PostgresSQL type :\n\
 psql [-U postgres] template1 \n\
or type :  
 createdb postgres\nto start psql without a database as parameter\n"

        rm install_postgres.log
        exit 0
fi
```

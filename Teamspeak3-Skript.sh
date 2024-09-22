#!/bin/bash

# Gucken ob der Benutzer root ist
if [ "$(id -u)" != "0" ]; then
  echo $(tput setaf 1)Bitte wechseln Sie zu einem Admin/Root Benutzer$(tput sgr0)
  exit 1;
fi

#Name vom Script
SCRIPTNAME="TS3 Server"
LOCK=".lock-ts3"

content=$(wget wget https://raw.githubusercontent.com/lofentblack/Teamspeak-3-Skript/refs/heads/main/version.txt -q -O -)
Version=$content

checkUpdate() {
content=$(wget wget https://raw.githubusercontent.com/lofentblack/Teamspeak-3-Skript/refs/heads/main/version.txt -q -O -)
version=$content

# Eingabedatei
AnzahlZeilen=$(wc -l ${LOCK} | awk ' // { print $1; } ')
for LaufZeile in $(seq 1 ${AnzahlZeilen})
 do
  Zeile=$(sed -n "${LaufZeile}p" ${LOCK})
  Test=${Zeile}
	if [[ "$Test" == *"version"* ]]; then
		if [[ "$Test" == *"version"* ]]; then
		  var1=$(sed 's/version=//' <<< "$Test")
		  var2=$(sed 's/^.//;s/.$//' <<< "$var1")
		  SkriptVersion=$var2
		fi
	fi
done

if ! [[ $version == $SkriptVersion ]]; then
	sudo apt-get install wget -y
	clear
	clear

	echo $(tput setaf 3)"Update von Version "$SkriptVersion" zu "$version"."
	echo "$(tput sgr0)"
	wget wget https://raw.githubusercontent.com/lofentblack/Teamspeak-3-Skript/refs/heads/main/Teamspeak3-Skript.sh -O Teamspeak3-Skript.sh.new
	rm $LOCK
	chmod 775 Teamspeak3-Skript.sh
	rm Teamspeak3-Skript.sh
	mv Teamspeak3-Skript.sh.new Teamspeak3-Skript.sh

fi
}

checkUpdate

lofentblackDEScript() {

rot="$(tput setaf 1)"
gruen="$(tput setaf 2)"
gelb="$(tput setaf 3)"
dunkelblau="$(tput setaf 4)"
lila="$(tput setaf 5)"
turkies="$(tput setaf 6)"

# Notwendige Packete
installations_packete() {

apt-get install sudo -y
sudo apt-get update -y
sudo apt-get install screen -y

screen=instalations_packete_lb.de_script
screen -Sdm $screen apt-get install figlet -y && screen -Sdm $screen sudo apt-get upgrade -y && screen -Sdm $screen sudo apt-get bzip2 -y

sleep 10

echo "Notwendige Pakete Installiert"

sleep 1

clear
clear
echo $gruen"Bitte starte das Skript neu!"
echo "$(tput sgr0)"

}

download() {

wget -O - https://www.teamspeak.com/de/downloads/#server >> LBsite1.txt
sed '/input/!d' LBsite1.txt > LBsite.txt
rm LBsite1.txt
sed 's/.*value="\([^"]*\).*/\1/p' LBsite.txt > LBoutput.txt
sed '/teamspeak3-server_linux_amd64/!d' LBoutput.txt > LBlink.txt
rm LBsite.txt
rm LBoutput.txt
sed -n '1,1p' LBlink.txt >> LBausgabe.txt
rm LBlink.txt
Test=$(head -n 1 LBausgabe.txt)
rm LBausgabe.txt
rm LBoutput.txt
rm LBsite.txt
wget $Test -O ./latest.tar.bz2

if ! [ -f latest.tar.bz2 ]; then
	echo $rot
	echo "Teamspeak 3 Server nicht herunterladen. Datei nicht gefunden!"
	exit 0;
fi

}

LOGO() {

clear
clear
echo "$(tput setaf 2)"
figlet -f slant -c $SCRIPTNAME
echo "$(tput sgr0)"

}

# Script Verzeichnis
	reldir=`dirname $0`
	cd $reldir
	SCRIPTPATH=`pwd`

clear
clear

 if [ -s $SCRIPTPATH/$LOCK ]; then
	echo "$(tput setaf 2)"
	figlet -f slant -c $SCRIPTNAME
	echo $rot
	echo "Mit dem Ausführen des Skripts akzeptierst du der Lizenz von LofentBlack.de/licence und der von Teamspeak."
	echo "$(tput sgr0)"

	read -p "Befindet sich auf diesem Server ein Teamspeak 3 Server? (Y/N): " server

	if [ $server = "y" ] || [ $server = "Y" ] || [ $server = "J" ] || [ $server = "j" ] || [ $server = "ja" ] || [ $server = "Ja" ] || [ $server = "Yes" ] || [ $server = "yes" ] || [ $server = "ok" ] || [ $server = "Ok" ] || [ $server = "OK" ] || [ $server = "oK" ] || [ $server = "JA" ] || [ $server = "jA" ] || [ $server = "YES" ] || [ $server = "YEs" ] || [ $server = "yES" ] || [ $server = "yeS" ] || [ $server = "YeS" ] || [ $server = "yES" ] || [ $server = "yEs" ]; then
	echo $turkies
	echo 'Wo ist dein Teamspeak 3-Server Vezeichnis angebe z.B. (/home/ts3)'

	read -p "Verzeichnis: " Verzeichnis
	if ! [ -s $Verzeichnis/ ]; then
		echo $rot
		echo "Verzeichnis existiert nicht"
		echo $turkies
	else
	cd $Verzeichnis
	if [ -s ts3server_startscript.sh ]; then
		echo $gruen
		echo "Teamspeak Server gefunden!"
	else
		echo $rot
		echo "Teamspeak 3 Server nicht gefunden!"
	fi
	echo $turkies
	echo "$(tput sgr0)"
	fi


	if [ -s ts3server_startscript.sh ]; then
		
		sleep 1
		LOGO
		echo "1.) Teamspeak Server Updaten"
		echo "2.) Teamspeak Server Neuinstallieren"
		echo "3.) Teamspeak Server Löschen"
		echo "4.) Beenden"
		read -p "Was soll am Teamspeak Server gemacht werden? " Teamspeak

		if [ $Teamspeak = 1 ]; then
			LOGO
			echo "Bei einem Update kann der Teamspeak Server kaputtgehen also bitte machen Sie vorher ein Backup!"
			read -p "(F)ortfahren oder (A)brechen(F/A): " FA
				if [ $FA = "F" ] || [ $FA = "f" ]; then
					LOGO
					echo "ladevorgang."
					
					screen -X -S Teamspeak kill
					
					sleep 1
					mkdir ./ts3-update-LB-script
					mv libts3db_mariadb.so ./ts3-update-LB-script/
					mv ts3server.sqlitedb ./ts3-update-LB-script/
					mv files/ ./ts3-update-LB-script/
					mv query_ip_allowlist.txt ./ts3-update-LB-script/
					mv query_ip_denylist.txt ./ts3-update-LB-script/
					
					
					LOGO
					echo "Ladevorgang.."
					mv ts3-update-LB-script/ ..
					cd ..
					rm -r $Verzeichnis/*
					
					download

					LOGO
					echo "Ladevorgang..."
					tar -xjf ./latest.tar.bz2
					sleep 1
					LOGO
					echo "Ladevorgang...."
					mv teamspeak3-server_linux_amd64/* $Verzeichnis
					rm -r ./latest.tar.bz2
					rm -r ./teamspeak3-server_linux_amd64
					sleep 1
					LOGO
					echo "Ladevorgang....."
					cd $Verzeichnis/
					chmod 775 ts3server_startscript.sh
					chmod 775 ts3server_minimal_runscript.sh
					chmod 775 ts3server
					
					rm libts3db_mariadb.so
					
					sleep 1
					LOGO
					echo "Ladevorgang....."
					cd ..
					mv ./ts3-update-LB-script/* $Verzeichnis/
					rm -r ./ts3-update-LB-script
					sleep 1
					LOGO
					echo "Ladevorgang....."
					sleep 1
					LOGO
					echo "Der Server wurde Erfolgreich upgedatet!"
					
					cd $Verzeichnis/
					#screen -Sdm Teamspeak ./ts3server_minimal_runscript.sh
					
				else
				  	echo "Der Server wurde nicht upgedatet!"
				fi


		elif [ $Teamspeak = 2 ]; then
			ls
			LOGO
			echo $rot
			echo "Sind Sie Sicher das Sie ihren Teamspeak Server Neuinstallieren wollen, dabei gehen alle Daten verloren, falls Sie kein Backup haben!"
			echo "$(tput sgr0)"
			read -p "(N)euinstallieren oder (A)bbrechen (N/A): " SICHER
			if [ $SICHER = "N" ] || [ $SICHER = "N" ]; then
				cd ..
				rm -r $Verzeichnis/*
				echo $rot
				echo "Server wird Neu installiert!"

				download
				
				tar -xjf ./latest.tar.bz2
				mv teamspeak3-server_linux_amd64/* $Verzeichnis
				rm -r ./latest.tar.bz2
				rm -r ./teamspeak3-server_linux_amd64
				cd $Verzeichnis/
				chmod 775 ts3server_startscript.sh
				chmod 775 ts3server_minimal_runscript.sh
				chmod 775 ts3server
				LOGO
				read -p "Soll der Neue Teamspeak Server als Screen gestartet werden? " STARTEN
					if [ $STARTEN = "y" ] || [ $STARTEN = "Y" ] || [ $STARTEN = "J" ] || [ $STARTEN = "j" ] || [ $STARTEN = "ja" ] || [ $STARTEN = "Ja" ] || [ $STARTEN = "Yes" ] || [ $STARTEN = "yes" ] || [ $STARTEN = "ok" ] || [ $STARTEN = "Ok" ] || [ $STARTEN = "OK" ] || [ $STARTEN = "oK" ] || [ $STARTEN = "JA" ] || [ $STARTEN = "jA" ] || [ $STARTEN = "YES" ] || [ $STARTEN = "YEs" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yeS" ] || [ $STARTEN = "YeS" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yEs" ]; then
						screen -Sdm Teamspeak ./ts3server_minimal_runscript.sh start
						echo ""
						echo "Server wurde gestartet!"
					else
						echo ""
						echo "Server wurde nicht gestartet!"
					fi

			else
				echo $gruen
				echo "Server wird nicht gelöscht!"
			fi
		elif [ $Teamspeak = 3 ]; then
			LOGO
			echo $rot
			echo "Okay, der Teamspeak Server wird gelöscht und damit gehen ALLE Daten verloren. Sind Sie sicher, dass Sie den Teamspeak Server Löschen möchten? "
			echo "$(tput sgr0)"
			read -p "(L)öschen oder (B)ehalten (L/B): " SICHER
			if [ $SICHER = "L" ] || [ $SICHER = "l" ]; then
				cd ..
				rm -r $Verzeichnis/
				echo $rot
				echo "Server wurde Erfolgreich gelöscht!"
			else
				echo $gruen
				echo "Server wird nicht gelöscht!"
			fi
		else
			echo "Keine Angabe erkannt"
		fi
	fi



	else





	read -p "Soll ein Teamspeak Server installiert werden? (Y/N): " INSTALATION

	if [ $INSTALATION = "y" ] || [ $INSTALATION = "Y" ] || [ $INSTALATION = "J" ] || [ $INSTALATION = "j" ] || [ $INSTALATION = "ja" ] || [ $INSTALATION = "Ja" ] || [ $INSTALATION = "Yes" ] || [ $INSTALATION = "yes" ] || [ $INSTALATION = "ok" ] || [ $INSTALATION = "Ok" ] || [ $INSTALATION = "OK" ] || [ $INSTALATION = "oK" ] || [ $INSTALATION = "JA" ] || [ $INSTALATION = "jA" ] || [ $INSTALATION = "YES" ] || [ $INSTALATION = "YEs" ] || [ $INSTALATION = "yES" ] || [ $INSTALATION = "yeS" ] || [ $INSTALATION = "YeS" ] || [ $INSTALATION = "yES" ] || [ $INSTALATION = "yEs" ]; then
		echo ""
		echo "Bitte gebe ein Verzeichnis an,"
		echo "wo der Server installiert werden soll z.b(/home/ts3/)"
		read -p "Wo soll der Server installiert werden?: " Verzeichnis
		if ! [ -s $Verzeichnis/ ]; then
			mkdir $Verzeichnis
			if ! [ -s $Verzeichnis/ ]; then
				echo "Verzeichnis konnte nicht erstellt werden da es zu viele Unterordner sind."
				echo "Versuchen Sie das Verzeichnis selber zu Erstellen."
			fi
			if [ -s $Verzeichnis/ ]; then
				echo "Verzeichnis wurde erstellt."
				if ! [ -s ts3server_startscript.sh ]; then
				cd $Verzeichnis
				
				download
				
				tar -xjf ./latest.tar.bz2
				mv teamspeak3-server_linux_amd64/* .
				rm -r ./latest.tar.bz2
				rm -r teamspeak3-server_linux_amd64/
				chmod 775 ts3server_startscript.sh
				chmod 775 ts3server_minimal_runscript.sh
				chmod 775 ts3server
				> .ts3server_license_accepted
				echo -e "license_accepted=1" >> .ts3server_license_accepted
				LOGO
				read -p "Soll der Teamspeak Server als Screen gestartet werden(Y/N)? " STARTEN
					if [ $STARTEN = "y" ] || [ $STARTEN = "Y" ] || [ $STARTEN = "J" ] || [ $STARTEN = "j" ] || [ $STARTEN = "ja" ] || [ $STARTEN = "Ja" ] || [ $STARTEN = "Yes" ] || [ $STARTEN = "yes" ] || [ $STARTEN = "ok" ] || [ $STARTEN = "Ok" ] || [ $STARTEN = "OK" ] || [ $STARTEN = "oK" ] || [ $STARTEN = "JA" ] || [ $STARTEN = "jA" ] || [ $STARTEN = "YES" ] || [ $STARTEN = "YEs" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yeS" ] || [ $STARTEN = "YeS" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yEs" ]; then
						screen -Sdm Teamspeak ./ts3server_minimal_runscript.sh start
						echo ""
						echo "Server wurde gestartet!"
					else
						echo ""
						echo "Server wurde nicht gestartet!"
					fi
				else
					echo "Hier befindet sich Bereits ein Teamspeak-Server!"
				fi
			fi
		else
			cd $Verzeichnis
			if ! [ -s ts3server_startscript.sh ]; then
				
				download
				
				tar -xjf ./latest.tar.bz2
				mv teamspeak3-server_linux_amd64/* .
				rm -r latest.tar.bz2
				rm -r teamspeak3-server_linux_amd64/
				chmod 775 ts3server_startscript.sh
				chmod 775 ts3server_minimal_runscript.sh
				chmod 775 ts3server
				> .ts3server_license_accepted
				echo -e "license_accepted=1" >> .ts3server_license_accepted
				LOGO
				read -p "Soll der Teamspeak Server als Screen gestartet werden(Y/N)? " STARTEN
				if [ $STARTEN = "y" ] || [ $STARTEN = "Y" ] || [ $STARTEN = "J" ] || [ $STARTEN = "j" ] || [ $STARTEN = "ja" ] || [ $STARTEN = "Ja" ] || [ $STARTEN = "Yes" ] || [ $STARTEN = "yes" ] || [ $STARTEN = "ok" ] || [ $STARTEN = "Ok" ] || [ $STARTEN = "OK" ] || [ $STARTEN = "oK" ] || [ $STARTEN = "JA" ] || [ $STARTEN = "jA" ] || [ $STARTEN = "YES" ] || [ $STARTEN = "YEs" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yeS" ] || [ $STARTEN = "YeS" ] || [ $STARTEN = "yES" ] || [ $STARTEN = "yEs" ]; then
					screen -Sdm Teamspeak ./ts3server_minimal_runscript.sh start
					echo ""
					echo "Server wurde gestartet!"
				else
					echo ""
					echo "Server wurde nicht gestartet!"
				fi
			else
				echo "Hier befindet sich Bereits ein Teamspeak-Server"
			fi
		fi
	else
		echo "Teamspeak-Server wird nicht Installiert!"
	fi


	fi

	elif ! [ -s $SCRIPTPATH/$LOCK ]; then
    > $LOCK
    echo -e 'int=true\nversion="'$Version'"\n\n#Mit dieser Datei erkennt das Skript das alle notwendigen Pakete installiert worden sind.' > $SCRIPTPATH/$LOCK
    installations_packete
fi




echo "$(tput sgr0)"
}
lofentblackDEScript

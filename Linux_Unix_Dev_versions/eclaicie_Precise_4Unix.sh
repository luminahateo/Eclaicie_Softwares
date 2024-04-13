#!/bin/bash

# ECLAICIE vers. PRECISE FOR UNIX
#################################
## [EN/US] Clean up a particular folder
## [FR] Ranger un dossier spécifique

# Variables
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0                                                                  # Number of clean files, nombre de fichiers rangés

clear
read -p "Caution, please note, your folder should not be a system folder !!
Attention, le dossier ne doit pas être un dossier système !!

	[ok]
	[quit]
" choix

if [ $choix == "ok" ]; then
	ls -l
	read -p "Whats is your folder for clean up?
	Quel est le dossier à ranger" dCible
	cd ~/"$dCible"

	read -p "What do you want to call the folder where everything will be clean?
	Comment voulez-vous appeler le dossier où tout sera rangé?" dRanger

	if [ -d "$dRanger" ]; then
		echo "duplicate folder, dossier en doublon >"$dRanger
	else
		mkdir "$dRanger"
	fi
	mkdir "$dRanger/$dDate"

	if [ -f "$dRanger/eclaiciePreciseUNIX.log" ]; then                                   # Create of .log, Construction du .log
		rm "$dRanger/eclaiciePreciseUNIX.log"
		touch "$dRanger/eclaiciePreciseUNIX.log"
	else
		touch "$dRanger/eclaiciePreciseUNIX.log"
	fi


	echo "$(date)" >> "$dRanger/eclaiciePreciseUNIX.log"                                 # head of .log, Entête du .log

	for fichier in *; do
		if [ -f "$fichier" ]; then
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')                        # Recupération des extensions des fichiers pour rangement par dossier.
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')                     # Files exetnsion
			dExt="My$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})

			[ -d "$dRanger/$dDate/$dExt" ] || mkdir "$dRanger/$dDate/$dExt"          # Rangement par date
			if [ -f "$dRanger/$dDate/$dExt/$fichier" ]; then                         # Clean with date for no erase
				if [ ! -d "$dRanger/$dDate/$dExt-doublons/" ]; then
					mkdir "$dRanger/$dDate/$dExt-doublons"
				fi
				mkdir "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				mv "$fichier" "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				echo " \"$nomDuFichier\" >>>>> \"$dRanger/$dDate/$dExt-doublons/$dDateComplete\" " >> "$dRanger/eclaiciePreciseUNIX.log"
			else
				mv "$fichier" "$dRanger/$dDate/$dExt/"
				echo " \"$nomDuFichier\" >>>>> \"$dRanger/$dDate/$dExt/\" " >> "$dRanger/eclaiciePreciseUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

		echo "Number files clean, nombre de fichiers traités: $nbreFichier"
		cat "$dRanger/eclaiciePreciseUNIX.log"
fi

#!/bin/bash

# ECLAICIE vers. DESKTOP FOR UNIX
#################################
## [EN/US] Clean your desktop files on your user folders
## [FR] Ranger votre bureau dans les dossiers utilisateur

# Variables
	dRanger="BureauRangé"
	dDate=`date "+%Y-%m-%d"`
	dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
	nbreFichier=0                                                                # number files, nombre de fichiers rangés

	if [ -d "Bureau" ]; then                                                     # folders US or FR
		dBureau="Bureau"
	else
		dBureau="Desktop"
	fi

	cd ~/"$dBureau"
	clear

	if [ ! -d "$dRanger" ]; then
		mkdir "$dRanger"
	fi

	mkdir "$dRanger/$dDate"

	if [ ! -f "$dRanger/eclaicieBureauUNIX.log" ]; then                         # create LOG
		touch "$dRanger/eclaicieBureauUNIX.log"
	fi
	echo "$(date)" >> "$dRanger/eclaicieBureauUNIX.log"

	for fichier in *; do                                                         # Start script
		if [ -f "$fichier" ]; then
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
			dExt="Mes$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})
			[ -d "$dRanger/$dDate/$dExt" ] || mkdir "$dRanger/$dDate/$dExt"
			if [ -f "$dRanger/$dDate/$dExt/$fichier" ]; then
				if [ ! -d "$dRanger/$dDate/$dExt-doublons/" ]; then
					mkdir "$dRanger/$dDate/$dExt-doublons"
				fi
				mkdir "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				mv "$fichier" "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt-doublons/$dDateComplete\" " >> "$dRanger/eclaicieBureauUNIX.log"
			else
				mv "$fichier" "$dRanger/$dDate/$dExt/"
				echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt/\" " >> "$dRanger/eclaicieBureauUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

	echo "number files clean, nombre de fichiers rangés : $nbreFichier"
	cat "$dRanger/eclaicieBureauUNIX.log"

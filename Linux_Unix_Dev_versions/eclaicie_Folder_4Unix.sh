#!/bin/bash

# ECLAICIE vers. DESKTOP FOR UNIX
#################################
## [EN/US] Clean your folder on your user folders
## [FR] Ranger votre dossier dans les dossiers utilisateur

# Variables
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0 #nombre de fichiers rangés

clear
read -p "Caution, please note, your folder should not be a system folder !!
Attention, le dossier ne doit pas être un dossier système !!

	[ok]
	[quit]"
choix

if [ $choix == "ok" ]; then
	cd                                                                           # creat LOG
	dLog=`pwd`
	if [ -f "$dLog/eclaicieDossierUNIX.log" ]; then
		rm "$dLog/eclaicieDossierUNIX.log"
		touch "$dLog/eclaicieDossierUNIX.log"
	else
		touch "$dLog/eclaicieDossierUNIX.log"
	fi

	# Entête du .log
	echo "$(date)" >> "$dLog/eclaicieDossierUNIX.log"

	if [ -d "Bureau" ]; then                                                     # US or FR folder
 		dMu="Musique"
		dPic="Images"
		dMov="Vidéos"
		dGrap="Graphisme"
		dOthers="Autres"
	else
		dMu="Music"
		dPic="Pictures"
		dMov="Movies"
		dGrap="Graph"
		dOthers="Others"
	fi

	read -p "Whats is your folder for clean up?
	Quel est le dossier à ranger" dCible
	cd ~/"$dCible"

	for fichier in *; do
		if [ -f "$fichier" ]; then

			# Recupération des extensions des fichiers pour rangement par dossier.
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
			dExt="Mes$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})

			case "$ext" in
				*wav* | *mp3* | *ogg* | *flac* | *mid* | *m4a* ) dCorrespondant="$dMu" ;;
				*jpg* | *jpeg* | *png* | *bmp* | *gif* | *icns* | *ico* | *jp2* | *mac* | *raw* | *svg* | *swf* | *tif* | *tiff* ) dCorrespondant="$dPic" ;;
				*doc* | *xls* | *ods* | *txt* | *pdf* | *md* | *rtf* | *dcx* | *pages* | *numbers* | *otp* | *odf* | *odb* | *oxt* ) dCorrespondant="Documents" ;;
				*avi* | *mp4* | *mov* | *mkv* | *webm* | *mpa* | *asf* | *wma* | *wmf* | *flv* | *mp2* | *m2p* | *vob* | *moov* | *mkv* ) dCorrespondant="$dMov" ;;
				*psd* | *ai* | *blend* | *blend1* | *fla* | *afdesign* | *afphoto* ) dCorrespondant="$dGrap"; mkdir ~/"$dGrap";;
				*c* | *cpp* | *sh* | *js* | *ts* | *py* | *html* | *htm* | *json* | *bas* | *css* | *xml*) dCorrespondant="Developpement"; mkdir ~/Developpement;;
				*dmg* | *zip* | *rar* | *7z* | *iso* | *xz* ) dCorrespondant="Archives";	mkdir ~/Archives;;
				*torrent* ) dCorrespondant="Web"; mkdir ~/Web;;
				*) dCorrespondant=$dOthers; mkdir ~/"$dOthers";;
			esac

			[ -d ~/"$dCorrespondant/$dExt" ] || mkdir ~/"$dCorrespondant/$dExt"
			[ -d ~/"$dCorrespondant/$dExt/$dDate" ] || mkdir ~/"$dCorrespondant/$dExt/$dDate"
			if [ -f ~/"$dCorrespondant/$dExt/$dDate/$fichier" ]; then
				if [ ! -d ~/"$dCorrespondant/$dExt-doublons/" ]; then
					mkdir ~/"$dCorrespondant/$dExt-doublons/"
				fi
				mkdir ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				mv "$fichier" ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				echo " \"$fichier\" >>>>> \"$dCorrespondant$dExt-doublons/$dDateComplete\" " >> ~/"eclaicieDossierUNIX.log"
			else
				mv "$fichier" ~/"$dCorrespondant/$dExt/$dDate/"
				echo " \"$fichier\" >>>>> \"$dCorrespondant/$dExt/$dDate/\" " >> ~/"eclaicieDossierUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

	echo "Number files clean, Nombre de Fichiers traités: $nbreFichier .
	cat "$dLog/eclaicieDossierUNIX.log"

fi

#!/bin/sh

clear
echo "=======================================================================
 Chemin du dossier à éclaicir ?
======================================================================="
read -r chemin

#variables
dRanger="CumulusRangé"
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0 #nombre de fichiers rangés

#Creation des dossiers
cd "$chemin" 
if [ ! -d "$chemin" ]; then
  ./cumulus.sh
fi
pwd

if [ ! -d "$dRanger" ]; then
  mkdir "$dRanger"
fi
if [ ! -d "$dRanger/$dDate" ]; then
  mkdir "$dRanger/$dDate"
fi

# Construction du .log
if [ -f "$dRanger/eclaicie.log" ]; then
  rm "$dRanger/eclaicie.log"
  touch "$dRanger/eclaicie.log"
else
  touch "$dRanger/eclaicie.log"
fi

# Entête du .log
	echo "=======================================================================
 en ce $(date)
=======================================================================" >> "$dRanger/eclaicie.log"

# Traitement des fichiers à ranger.
for fichier in *; do
  if [ -f "$fichier" ]; then

    # Recupération des extensions des fichiers pour rangement par dossier.
    ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
    extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
    dExt="Mes $extMAJ"
    nomDuFichier=$(basename $fichier .${fichier##*.})

    # Rangement du fichiers dans le dossier de son extesion
      # Si celui-ci existe déjà, déplacement dans un dossier doublon avec une date complete (heures, mins, secs) afin d'évité tous écrasements.
    [ -d "$dRanger/$dDate/$dExt" ] || mkdir "$dRanger/$dDate/$dExt"
    if [ -f "$dRanger/$dDate/$dExt/$fichier" ]; then
      if [ ! -d "$dRanger/$dDate/$dExt-doublons/" ]; then
        mkdir "$dRanger/$dDate/$dExt-doublons"
      fi
      mkdir "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
      mv "$fichier" "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
      echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt-doublons/$dDateComplete\" " >> "$dRanger/eclaicie.log"
    else
      mv "$fichier" "$dRanger/$dDate/$dExt/"
      echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt/\" " >> "$dRanger/eclaicie.log"
    fi
    nbreFichier=$(($nbreFichier + 1))
  fi
done

# Affichage final, nombre de fichiers traités et le log.
echo "=======================================================================
 Vous avez éclaicie de $nbreFichier fichiers votre bureau"
cat "$dRanger/eclaicie.log"

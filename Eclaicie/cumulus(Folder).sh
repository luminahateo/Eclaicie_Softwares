#!/bin/sh

clear
echo "Chemin du dossier à éclaicir ?"
read -r chemin

#variables
dRanger="CumulusRangé"
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0
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
if [ -f "$dRanger/eclaicie.log" ]; then
  rm "$dRanger/eclaicie.log"
  touch "$dRanger/eclaicie.log"
else
  touch "$dRanger/eclaicie.log"
fi
	echo "$(date)" >> "$dRanger/eclaicie.log"
for fichier in *; do
  if [ -f "$fichier" ]; then
    ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
    extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
    dExt="Mes $extMAJ"
    nomDuFichier=$(basename $fichier .${fichier##*.})
    [ -d "$dRanger/$dDate/$dExt" ] || mkdir "$dRanger/$dDate/$dExt"
    if [ -f "$dRanger/$dDate/$dExt/$fichier" ]; then
      if [ ! -d "$dRanger/$dDate/$dExt-doublons/" ]; then
        mkdir "$dRanger/$dDate/$dExt-doublons"
      fi
      mkdir "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
      mv "$fichier" "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
      echo " \"$nomDuFichier\" >>>>> \"$dRanger/$dDate/$dExt-doublons/$dDateComplete\" " >> "$dRanger/eclaicie.log"
    else
      mv "$fichier" "$dRanger/$dDate/$dExt/"
      echo " \"$nomDuFichier\" >>>>> \"$dRanger/$dDate/$dExt/\" " >> "$dRanger/eclaicie.log"
    fi
    nbreFichier=$(($nbreFichier + 1))
  fi
done
echo "Vous avez éclaicie de $nbreFichier fichiers votre bureau"
cat "$dRanger/eclaicie.log"

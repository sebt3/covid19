#!/bin/bash

clean() {
rm data/*json data/*csv
}
# Insee
insee() {
IURL="https://www.insee.fr/fr/information/4470857"
IDATA=$(curl -sL $IURL|awk -v p=0 '/class="bloc fichiers"/{p++}p==1&&/csv\.zip/{print}'|sed 's/.*href="//;s/".*//')
curl -sL "https://www.insee.fr$IDATA"|bsdtar -C data -xvf -
}

# data covid
dcovid() {
DURL=https://www.data.gouv.fr/fr/datasets/donnees-cartographiques-concernant-lepidemie-de-covid-19/
DDATA=$(curl -sL $DURL|awk '/departements-france.zip/&&/json_ld/'|sed 's/<script[^<]*>//;s/<\/script>//'|jq -r '.distribution[1].contentUrl')
curl -sL $DDATA|bsdtar -C data -xvf -
}

clean
insee
dcovid
./scripts/aggregate_covid.js
./scripts/cleancsv.sh

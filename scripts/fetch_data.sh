#!/bin/bash

clean() {
rm data/*.json data/*.csv
}
# Insee
insee() {
IURL="https://www.insee.fr/fr/statistiques/4487988?contenu=4487854"
IDATA=$(curl -sL $IURL|awk -v p=0 '/class="bloc fichiers"/{p++}p==1&&/csv\.zip/{print}'|sed 's/.*href="//;s/".*//')
curl -sL "https://www.insee.fr$IDATA"|bsdtar -C data -xvf -
}

carte() {
	if ! [ -f data/departements-version-simplifiee.geojson ];then
		curl -sL https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/departements-version-simplifiee.geojson >data/departements-version-simplifiee.geojson
	fi
}

# data covid
dcovid() {
DURL=https://www.data.gouv.fr/fr/datasets/donnees-cartographiques-concernant-lepidemie-de-covid-19/
DDATA=$(curl -sL $DURL|awk '/departements-france.zip/&&/json_ld/'|sed 's/<script[^<]*>//;s/<\/script>//'|jq -r '.distribution[1].contentUrl')
DDATA=https://github.com/kalisio/covid-19/raw/master/departements-france/departements-france.zip
curl -sL $DDATA|bsdtar -C data -xvf -
}

clean
insee
carte
dcovid
./scripts/aggregate_covid.js
./scripts/cleancsv.sh

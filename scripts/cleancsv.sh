#!/bin/bash
src=data/2020-11-20_deces_quotidiens_departement_csv.csv
dest=data/deces_quotidiens_departement.csv
#dos2unix <$src|awk "-F;" 'NR==1{print}!/France/&&!/NA/&&NR>1{$3="\""$3"\"";$4="\""$4"\"";$5="\""$5"\"";$6="\""$6"\"";$7="\""$7"\"";$8="\""$8"\"";print $0}'|sed 's/ /;/g'>$dest
dos2unix <$src|awk "-F;" '!/France/&&!/NA/'|sed 's/;/,/g'>$dest


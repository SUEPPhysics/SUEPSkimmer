#!/bin/sh

inputFile=$1

ptbins=(
  15to30 
  30to50 
  50to80 
  80to120 
  120to170 
  170to300 
  300to470 
  470to600 
  600to800 
  800to1000 
  1000to1400 
  1400to1800
  1800to2400
  2400to3200
  3200toInf
)

for pt in ${ptbins[@]}
do
  grep ${pt} ${inputFile} > filesPerBin/files_${pt}.txt
done

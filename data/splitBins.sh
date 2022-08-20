#!/bin/sh

inputFile=$1
dataset=$2

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

if [ ! -d "filesPerBin" ]
then
  mkdir filesPerBin
fi

for pt in ${ptbins[@]}
do
  if [ -f "filesPerBin/${dataset}_${pt}.txt" ]
  then
    rm filesPerBin/${dataset}_${pt}.txt
  fi
  grep ${pt} ${inputFile} > filesPerBin/${dataset}_${pt}.txt
done

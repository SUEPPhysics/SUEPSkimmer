#!/bin/sh

dataset=$1
filesPerJob=$2

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
  iFile=0
  iCount=0
  while read p
  do
    if [ ${iCount} -eq 0 ] && [ -f "filesSplit/${dataset}_${pt}_${iFile}.txt" ]
    then
      rm filesSplit/${dataset}_${pt}_${iFile}.txt
    fi
    if [ ${iCount} -eq ${filesPerJob} ]
    then
      ((iFile+=1))
      ((iCount=0))
    fi
    echo "root://xrootd.cmsaf.mit.edu/$p" >> filesSplit/${dataset}_${pt}_${iFile}.txt
    ((iCount+=1))
  done < filesPerBin/${dataset}_${pt}.txt
done

#!/bin/sh

# Usage: ./countFilesMIT.sh datasets.txt xrootd

inputFile=$1 # datasets.txt
engine=$2 # xrootd or gfal

while read p
do
  echo -n "${p:28:-11}: "
  if [ "$engine" = xrootd ] ; then
    xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" | wc -l
  elif [ "$engine" = gfal ] ; then
    gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root" | wc -l
  else
    echo "Unknown engine: $engine"
    break
  fi
done < ${inputFile}



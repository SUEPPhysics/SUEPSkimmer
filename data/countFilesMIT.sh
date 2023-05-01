#!/bin/sh

inputFile=$1
use_xrootd=true

while read p
do
  echo -n "${p:28:-11}: "
  if [ $use_xrootd ] ; then
    xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" | wc -l
  else
    gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/${p} | grep ".root" | wc -l
  fi
done < ${inputFile}



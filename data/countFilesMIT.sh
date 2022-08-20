#!/bin/sh

inputFile=$1

while read p
do
  echo -n "${p:28:-11}: "
  xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" | wc -l
done<${inputFile}



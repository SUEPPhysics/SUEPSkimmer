#!/bin/sh

inputFile=$1
allFiles=allFIles

if [ -f "${allFiles}.txt" ]
then
  rm "${allFiles}.txt"
fi

while read p
do
  xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" >> "${allFiles}.txt"
done<${inputFile}



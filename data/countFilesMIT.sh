#!/bin/sh

inputFile=$1

while read p
do
  xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" | wc -l
done<${inputFile}



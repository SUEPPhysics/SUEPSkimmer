#!/bin/sh

inputFile=${1}
allFiles=allFIles_${inputFile:0:-4}.txt

if [ -f "${allFiles}" ]
then
  rm ${allFiles}
fi

while read p
do
  xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root" >> ${allFiles}
done < ${inputFile}


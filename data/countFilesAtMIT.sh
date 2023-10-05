#!/bin/sh

# Will count the number of files for each one of the datasets in the input file.
# Usage: ./countFilesAtMIT.sh -d datasets.dat -p xrootd

# Default values
datasets="datasets.txt"
protocol=gfal

while getopts d:p: option; do
  case "${option}" in
    d) datasets=${OPTARG};;
    p) protocol=${OPTARG};;
  esac
done

while read p; do
  echo -n "${p:28:-11}: "
  if [ "$protocol" = xrootd ] ; then
    files=( $( { xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null ) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $( { xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null ) )
    done
  elif [ "$protocol" = gfal ] ; then
    files=( $( { gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null ) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $( { gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null ) )
    done
  else
    echo "Unknown protocol: $protocol"
    break
  fi
  echo ${#files[@]}
done < ${datasets}

#!/bin/sh

# Usage: ./countFilesMIT.sh datasets.txt xrootd

inputFile=$1 # datasets.txt
protocol=$2 # xrootd or gfal

while read p; do
  echo -n "${p:28:-11}: "
  if [ "$protocol" = xrootd ] ; then
    files=( $({ xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $({ xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null) )
    done
  elif [ "$protocol" = gfal ] ; then
    files=( $({ gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $({ gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null) )
    done
  else
    echo "Unknown protocol: $protocol"
    break
  fi
  echo ${#files[@]}
done < ${inputFile}

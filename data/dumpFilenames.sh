#!/bin/sh

# Usage: ./dumpFilenames.sh datasets.txt xrootd

inputFile=$1
engine=$2

out_dir="filenames"

if [ -f "${out_dir}" ]
then
  rm ${out_dir}
fi

while read p; do
  file_out="${p:28}.txt"
  if [ "$engine" = xrootd ] ; then
    files=( $({ xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $({ xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null) )
    done
  elif [ "$engine" = gfal ] ; then
    files=( $({ gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $({ gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$p | grep ".root"; } 2> /dev/null) )
    done
  else
    echo "Unknown engine: $engine"
    break
  fi
  echo ${files[@]} > ${file_out}
done < ${inputFile}


#!/bin/sh

# Usage: ./dumpFilenames.sh datasets.txt xrootd

inputFile=$1
protocol=$2

output_dir="filenames"

if [ -f "${output_dir}" ]
then
  rm ${output_dir}
fi
mkdir ${output_dir}

while read p; do
  output_file="${output_dir}/${p:28}.txt"
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
  for element in "${files[@]}"; do
    echo "${element}" >> ${output_file}
  done
done < ${inputFile}


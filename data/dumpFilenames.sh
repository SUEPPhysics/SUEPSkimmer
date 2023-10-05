#!/bin/sh

# Usage: ./dumpFilenames.sh -d data/datasets.dat -p [protocol]
# -d: path to the file containing the list of datasets (default: data/datasets.dat)
# -p: protocol to be used (xrootd or gfal) (default: gfal)

# Default values
datasets="datasets.dat"
protocol="gfal"

while getopts 'd:p:' option; do
  case "${option}" in
    d) datasets="${OPTARG}" ;;
    p) protocol="${OPTARG}" ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done

output_dir="filenames"

if [ -f "${output_dir}" ]
then
  rm ${output_dir}
fi
mkdir ${output_dir}

# Attempt to fetch the filenames. Might need to retry many times...
while read p; do
  output_file="${output_dir}/${p:28}.txt"
  if [ "$protocol" = xrootd ] ; then
    files=( $( { xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null ) )
    while [ $PIPESTATUS -ne 0 ]; do
      sleep 1
      files=( $( { xrdfs root://xrootd.cmsaf.mit.edu/ ls $p | grep ".root"; } 2> /dev/null) )
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
  for element in "${files[@]}"; do
    echo "${element}" >> ${output_file}
  done
done < ${datasets}


#!/bin/sh

# Will just loop over the datasets and call merger.sh
# Usage: ./runMerger.sh -d data/datasets.dat -i [input_path]
# -d: path to the file containing the list of datasets (default: data/datasets.dat)
# -i: path to the input directory (default: /store/user/lpcsuep)

# Default values
datasets="data/datasets.dat"
input_path=/store/user/lpcsuep

while getopts 'd:i:' option; do
  case "${option}" in
    d) datasets="${OPTARG}" ;;
    i) input_path="${OPTARG}" ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done


while read d; do
  dataset=$(echo "$d" | awk -F'/' '{print $NF}')
  ./merger.sh -i "$input_path/SUEPNano_skimmed/$dataset" -o "$input_path/SUEPNano_skimmed_merged/$dataset"
done < "$datasets"


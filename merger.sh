#!/bin/bash

# Will merge all the files in a directory in groups of 1GB
# Usage: ./merger.sh -i /eos/path/to/directory -o /eos/path/to/output

while getopts 'i:o:' option; do
  case "${option}" in
    i) eos_dir="${OPTARG}" ;;
    o) output_dir="${OPTARG}" ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done

cwd=$(pwd)
group_size=$((1024*1024*1024)) # 1 GB in bytes
current_group=1
current_group_size=0

if [[ -z $eos_dir ]]; then
  echo "Please provide an EOS directory path."
  exit 1
fi

eos_files=$(eos root://cmseos.fnal.gov/ ls "$eos_dir")
if [[ $? -ne 0 ]]; then
  echo "The provided path is not a valid EOS directory."
  exit 1
fi

echo "Merging $eos_dir in files of 1GB. This might take a while..."

list_of_files=()
while read -r file; do
  file_path="${eos_dir}/${file}"
  file_size=$(eos root://cmseos.fnal.gov/ file info "$file_path" -m | grep -Po '(?<=size=)\d+')
  if (( current_group_size + file_size > group_size )); then
    hadd -j 4 skim_$current_group.root ${list_of_files[@]}
    xrdcp -f skim_$current_group.root root://cmseos.fnal.gov/$output_dir/skim_$current_group.root
    rm skim_$current_group.root
    current_group=$((current_group + 1))
    current_group_size=0
    list_of_files=()
  fi
  list_of_files+=("root://cmseos.fnal.gov/$eos_dir/$file")
  current_group_size=$((current_group_size + file_size))
done <<< "$eos_files"

hadd -j 4 skim_$current_group.root ${list_of_files[@]}
xrdcp -f skim_$current_group.root root://cmseos.fnal.gov/$output_dir/skim_$current_group.root
rm skim_$current_group.root


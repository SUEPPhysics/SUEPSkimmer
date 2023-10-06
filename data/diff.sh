#!/bin/bash

# Usage: ./diff.sh -i [input_path] -o [output_path] -p [protocol]
# -d: path to the file containing the list of datasets (default: datasets.dat)
# -i: path to the input directory (default: /store/user/paus/nanosu/A02)
# -o: path to the output directory (default: /store/user/lpcsuep/SUEPNano_skimmed)
# -p: protocol to be used (xrootd or gfal) (default: gfal)

datasets=datasets.dat
input_path=/store/user/paus/nanosu/A02
output_path=/store/user/lpcsuep/SUEPNano_skimmed
protocol=gfal

while getopts 'd:i:o:p:' option; do
  case "${option}" in
    d) datasets="${OPTARG}" ;;
    i) input_path="${OPTARG}" ;;
    o) output_path="${OPTARG}" ;;
    p) protocol="${OPTARG}" ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done

# Loop over all directory pairs
while read p; do
    dataset=$(echo "$p" | awk -F'/' '{print $NF}')
    echo "Processing $dataset"
    src=$input_path/$dataset
    dest=$output_path/$dataset

    # Get the file list in both directories
    if [ "$protocol" = xrootd ] ; then
        { xrdfs root://xrootd.cmsaf.mit.edu/ ls $src | grep ".root"; } 1> src_files.txt 2> /dev/null
        while [ $PIPESTATUS -ne 0 ]; do
            sleep 1
            { xrdfs root://xrootd.cmsaf.mit.edu/ ls $src | grep ".root"; } 1> src_files.txt 2> /dev/null
        done
    elif [ "$protocol" = gfal ] ; then
        { gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$src | grep ".root"; } 1> src_files.txt 2> /dev/null
        while [ $PIPESTATUS -ne 0 ]; do
            sleep 1
            { gfal-ls gsiftp://se01.cmsaf.mit.edu:2811//cms/$src | grep ".root"; } 1> src_files.txt 2> /dev/null
        done
    else
        echo "Unknown protocol: $protocol"
        break
    fi
    eos root://cmseos.fnal.gov/ ls $dest > dest_files.txt

    # Sort the file lists
    sort src_files.txt -o src_files_sorted.txt
    sort dest_files.txt -o dest_files_sorted.txt

    # Compare the sorted lists
    comm -23 src_files_sorted.txt dest_files_sorted.txt > filenames_diff/${dataset}.txt

    echo "Diff file created: ${dataset}.txt"
    #cat diff_${dataset}.txt
done < $datasets

# Clean up
rm src_files.txt dest_files.txt src_files_sorted.txt dest_files_sorted.txt

echo "Done."


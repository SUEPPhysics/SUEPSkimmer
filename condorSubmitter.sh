#!/usr/bin/sh

# Usage: ./condorSubmitter.sh -d data/datasets.dat -i [input_dir] -p [protocol] -s
# -d: path to the file containing the list of datasets (default: data/datasets.dat)
# -i: path to the input directory (default: data/filenames)
# -p: protocol to be used (xrootd or gfal) (default: gfal)
# -s: submit the jobs (will just prepare the jdl files if not specified)

# Prepare CMSSW tarball
source ${PWD}/prepareCondor.sh

# Default values
datasets="data/datasets.dat"
input_dir="data/filenames"
protocol="gfal"
sumbit=0

while getopts 'd:i:p:s' option; do
  case "${option}" in
    d) datasets="${OPTARG}" ;;
    i) input_dir="${OPTARG}" ;;
    p) protocol="${OPTARG}" ;;
    s) sumbit=1 ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done

if [ -d "condor" ] ; then
  rm -rf condor
fi
mkdir -pv condor/logs

while read p; do
  dataset=$(echo "$p" | awk -F'/' '{print $NF}')
  if [[ ! -s "${input_dir}/${dataset}.txt" ]]; then
    continue
  fi
  nfiles=$(wc -l < "${input_dir}/${dataset}.txt")
  argument="${CMSSW_VERSION} ${dataset} \$(Process) ${protocol} ${input_dir}"

  # Write jdl file
  echo "universe = vanilla" >> condor/${dataset}.jdl
  echo "Executable = condor-exec.sh" >> condor/${dataset}.jdl
  echo "Should_Transfer_Files = YES" >> condor/${dataset}.jdl
  echo "WhenToTransferOutput = ON_EXIT" >> condor/${dataset}.jdl
  echo "Transfer_Input_Files = condor-exec.sh, ${CMSSW_VERSION}.tgz" >> condor/${dataset}.jdl
  echo "Arguments = ${argument}" >> condor/${dataset}.jdl
  echo "Output = condor/logs/skimmer_${dataset}_\$(Cluster)_\$(Process).stdout" >> condor/${dataset}.jdl
  echo "Error = condor/logs/skimmer_${dataset}_\$(Cluster)_\$(Process).stderr" >> condor/${dataset}.jdl
  echo "Log = condor/logs/skimmer_${dataset}_\$(Cluster)_\$(Process).log" >> condor/${dataset}.jdl
  echo "x509userproxy = \$ENV(X509_USER_PROXY)" >> condor/${dataset}.jdl
  echo "Queue ${nfiles}" >> condor/${dataset}.jdl

  # Submit job
  if [ "${sumbit}" = 1 ] ; then
    condor_submit condor/${dataset}.jdl
  fi
done < ${datasets}

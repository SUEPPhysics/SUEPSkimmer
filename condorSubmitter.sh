#!/usr/bin/sh

# Usage: ./condorSubmitter.sh -d data/datasets.dat -p [protocol] -s
# -d: path to the file containing the list of datasets (default: data/datasets.dat)
# -p: protocol to be used (xrootd or gfal) (default: gfal)
# -s: submit the jobs (will just prepare the jdl files if not specified)

# Prepare CMSSW tarball
source ${PWD}/prepareCondor.sh

# Default values
datasets="data/datasets.dat"
protocol="gfal"
sumbit=0

while getopts 'd:p:s' option; do
  case "${option}" in
    d) datasets="${OPTARG}" ;;
    p) protocol="${OPTARG}" ;;
    s) sumbit=1 ;;
    *) echo "Unexpected option ${option}" ;;
  esac
done

suffix=${datasets:13:-4}

if [ -d "condor" ] ; then
  rm -rf condor
fi
mkdir -pv condor/logs

while read p; do
  dataset=${p:28}
  if [[ ! -s "data/filenames${suffix}/${dataset}.txt" ]]; then
    continue
  fi
  nfiles=$(wc -l < "data/filenames${suffix}/${dataset}.txt")
  argument="${CMSSW_VERSION} ${dataset} \$(Process) ${protocol} ${suffix}"

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

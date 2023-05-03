#!/usr/bin/sh

# Usage: ./condorSubmitter.sh datasets.txt protocol prepare_only

source ${PWD}/prepareCondor.sh

datasets=$1
protocol=$2
prepare_only=$3

if [ -d "condor" ] ; then
  rm -rf condor
fi
mkdir condor

while read p; do
  nfiles=$(wc -l data/filenames/${p}.txt)
  dataset=${p:28:-4}
  argument="${CMSSW_VERSION} ${dataset} \$(Process) ${protocol}"

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
  if [ "${prepare_only}" = 0 ] ; then
    condor_submit condor/${dataset}.jdl
  fi
done < ${datasets}

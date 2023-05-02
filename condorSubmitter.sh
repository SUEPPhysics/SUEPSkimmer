#!/usr/bin/sh

source ${PWD}/prepareCondor.sh

datasets=$1
protocol=$2
prepare_only=$3

if [ -f "condor" ] ; then
  rm -rf condor
fi
mkdir condor

while read p; do
  nfiles=$(wc -l data/filenames/${p}.txt)
  namestring=${p:28:-4}
  argument="${CMSSW_VERSION} ${namestring} \$(Process)"

  # Write jdl file
  echo "universe = vanilla" >> condor/${namestring}.jdl
  echo "Executable = condor-exec.sh" >> condor/${namestring}.jdl
  echo "Should_Transfer_Files = YES" >> condor/${namestring}.jdl
  echo "WhenToTransferOutput = ON_EXIT" >> condor/${namestring}.jdl
  echo "Transfer_Input_Files = condor-exec.sh, ${CMSSW_VERSION}.tgz" >> condor/${namestring}.jdl
  echo "Arguments = ${argument}" >> condor/${namestring}.jdl
  echo "Output = condor/logs/skimmer_${namestring}_\$(Cluster)_\$(Process).stdout" >> condor/${namestring}.jdl
  echo "Error = condor/logs/skimmer_${namestring}_\$(Cluster)_\$(Process).stderr" >> condor/${namestring}.jdl
  echo "Log = condor/logs/skimmer_${namestring}_\$(Cluster)_\$(Process).log" >> condor/${namestring}.jdl
  echo "x509userproxy = \$ENV(X509_USER_PROXY)" >> condor/${namestring}.jdl
  echo "Queue ${nfiles}" >> condor/${namestring}.jdl

  # Submit job
  if [ "$prepare_only" = 0 ] ; then
    condor_submit condor/${namestring}.jdl
  fi
done

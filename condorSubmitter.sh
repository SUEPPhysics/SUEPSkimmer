#!/usr/bin/sh
source ${PWD}/prepareCondor.sh

dataset=$1

ptbins=(
  15to30 
  30to50 
  50to80 
  80to120 
  120to170 
  170to300 
  300to470 
  470to600 
  600to800 
  800to1000 
  1000to1400 
  1400to1800
  1800to2400
  2400to3200
  3200toInf
)

for pt in ${ptbins[@]}
do
  nJobs=$(ls data/filesSplit/ | grep "${dataset}" | grep "${pt}" | wc -l)
  namestring=${dataset}_${pt}
  argument=${CMSSW_VERSION}\ ${namestring}\ \$\(Process\)

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
  echo "Queue ${nJobs}" >> condor/${namestring}.jdl

  # Submit job
  condor_submit condor/${namestring}.jdl
done

#!/bin/bash
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node
source /cvmfs/cms.cern.ch/cmsset_default.sh

### Input section
cmssw=$1
dataset=$2
number=$3

input=data/filesSplit/${dataset}_${number}.txt
output=${dataset}_${number}.root

tar -xf ${cmssw}.tgz
rm ${cmssw}.tgz
export SCRAM_ARCH=slc7_amd64_gcc820
cd ${cmssw}/src
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
cd SUEPSkimmer
source compile.sh

# TODO: first copy the input file to the worker, then run
./bin/skimmer ${output} $(cat $input)

xrdcp -f ${output} root://cmseos.fnal.gov//store/user/lpcsuep/QCD_skimmed/${dataset}/${output}

### remove the output file if you don't want it automatically transferred when the job ends
rm ${ouput}
cd ${_CONDOR_SCRATCH_DIR}
rm -rf ${cmssw}

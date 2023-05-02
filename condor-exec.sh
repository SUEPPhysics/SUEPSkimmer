#!/bin/bash
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node
source /cvmfs/cms.cern.ch/cmsset_default.sh

# Input section
cmssw=$1
dataset=$2
number=$3
$protocol=$4

input=data/filesSplit/${dataset}_${number}.txt
output=${dataset}_${number}.root

tar -xf ${cmssw}.tgz
rm ${cmssw}.tgz
export SCRAM_ARCH=slc7_amd64_gcc820
cd ${cmssw}/src
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
cd SUEPSkimmer
source compile.sh

# Get input files
if [ "$protocol" = xrootd ] ; then
    until xrdcp root://xrootd.cmsaf.mit.edu//store/user/paus/nanosu/A01/${input} ${input}; do
        sleep 1
    done
elif [ "$protocol" = gfal ] ; then
    until gfal-cp gsiftp://se01.cmsaf.mit.edu:2811//cms//store/user/paus/nanosu/A01/${input} ${input}; do
        sleep 1
    done
else
    echo "Unknown engine: $protocol"
    exit 1
fi

./bin/skimmer ${output} $input

until xrdcp -f ${output} root://cmseos.fnal.gov//store/user/lpcsuep/SUEPNano_skimmed/${dataset}/${output}; do
    sleep 1
done

rm ${ouput} ${input}
cd ${_CONDOR_SCRATCH_DIR}
rm -rf ${cmssw}

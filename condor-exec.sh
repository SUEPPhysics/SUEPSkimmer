#!/bin/bash
echo "Starting job on " $(date) # Date/time of start of job
echo "Running on: $(uname -a)" # Condor job is running on this node
echo "System software: $(cat /etc/redhat-release)" # Operating System on that node
source /cvmfs/cms.cern.ch/cmsset_default.sh

# Input section
cmssw=$1
dataset=$2
number=$3
protocol=$4
input_dir=$5

# Move to a tmp dir to avoid conflicts
tmp_dir=$(mktemp -d -p .)
cd ${tmp_dir}
tar -xf ../${cmssw}.tgz
rm ../${cmssw}.tgz
export SCRAM_ARCH=slc7_amd64_gcc820
cd ${cmssw}/src
eval $(scramv1 runtime -sh) # cmsenv is an alias not on the workers
cd SUEPSkimmer
source compile.sh

# Get input files
input_file=$(sed "$((number + 1))q;d" ${input_dir}/${dataset}.txt)
input_path="/store/user/paus/nanosu/A02/${dataset}/${input_file}"
if [ "${protocol}" = xrootd ] ; then
    until xrdcp root://xrootd.cmsaf.mit.edu/${input_path} .; do
        sleep 1
    done
elif [ "${protocol}" = gfal ] ; then
    until gfal-copy gsiftp://se01.cmsaf.mit.edu:2811//cms/${input_path} .; do
        sleep 1
    done
else
    echo "Unknown engine: ${protocol}"
    exit 1
fi

dataset_primary=$(echo "$dataset" | awk -F'+' '{print $1}')
output_file="output_${dataset_primary}_${number}.root"
./bin/skimmer ${output_file} ${input_file}

output_path="/store/user/lpcsuep/SUEPNano_skimmed/${dataset}/${input_file}"
until xrdcp -f ${output_file} root://cmseos.fnal.gov/${output_path}; do
    sleep 1
done

rm ${output_file} ${input_file}
cd ${_CONDOR_SCRATCH_DIR}
rm -rf ${tmp_dir}

#!/usr/bin/sh
source ${PWD}/prepareCondor.sh

while read p
do
namestring=${p:0:-4}
outputName=${p:6:-4}
argument=${CMSSW_VERSION}\ skimmed_${outputName}.root\ data/filesSplit/$p

# Write jdl file
cat > condor/skimmer_${namestring}.jdl << "EOF"
universe = vanilla
Executable = condor-exec.sh
Should_Transfer_Files = YES
WhenToTransferOutput = ON_EXIT
EOF
echo "Transfer_Input_Files = condor-exec.sh, ${CMSSW_VERSION}.tgz" >> condor/skimmer_${namestring}.jdl
echo "Arguments = ${argument}" >> condor/skimmer_${namestring}.jdl
cat >> condor/skimmer_${namestring}.jdl << "EOF"
Output = condor/logs/skimmer_$(Cluster)_$(Process).stdout
Error = condor/logs/skimmer_$(Cluster)_$(Process).stderr
Log = condor/logs/skimmer_$(Cluster)_$(Process).log
x509userproxy = $ENV(X509_USER_PROXY)
Queue 1
EOF

# Submit job
condor_submit condor/skimmer_${namestring}.jdl
done < filesForSubmission.txt

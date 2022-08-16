#!/bin/sh
USERBASE=`pwd`
rm ${CMSSW_VERSION}.tgz
cd ${CMSSW_BASE}/../
echo "Creating tarball..."
tar --exclude="*.root" --exclude-vcs -zcf ${CMSSW_VERSION}.tgz ${CMSSW_VERSION}
mv ${CMSSW_VERSION}.tgz ${USERBASE}
cd ${USERBASE}
if [ ! -f ${CMSSW_VERSION}.tgz ]; then
echo "Error: tarball doesn't exist!"
else
echo " Done!"
fi

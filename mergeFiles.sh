#!/bin/sh

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
  hadd skimmed_${pt}.root $(xrdfs root://cmseos.fnal.gov/ ls -u /store/user/lpcsuep/QCD_skimmed | grep ${pt})
  xrdcp skimmed_${pt}.root root://cmseos.fnal.gov//store/user/lpcsuep/QCD_skimmed/merged/skimmed_${pt}.root
done

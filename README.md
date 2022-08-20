# SUEPSkimmer

To get started:
1. Initialize some CMSSW (latest in `10_6_X` or greater)
2. Clone this repository in src
3. Execute the following:
```bash
cd SUEPSkimmer
mkdir -pv condor/logs
mkdir bin
```
4. Compile:
```bash
source compile.sh
```
5. The scripts in `data` can be used to create lists of files.
6. The script `condorSubmitter.sh` can submit jobs to Condor.
```bash
source condorSubmitter.sh QCD_2018
```

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

## Preparing the files for skimming

1. The datasets for skimming are defined in `data/datasets.dat`. The format is:

```
/store/user/paus/nanosu/A01/QCD_Pt_1000to1400_TuneCP5_13TeV_pythia8+RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v1+MINIAODSIM
/store/user/paus/nanosu/A01/QCD_Pt_120to170_TuneCP5_13TeV_pythia8+RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v2+MINIAODSIM
/store/user/paus/nanosu/A01/QCD_Pt_1400to1800_TuneCP5_13TeV_pythia8+RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v1+MINIAODSIM
... (and so on)
```

2. Use `data/dumpFilenames.sh` to create a list of files for each dataset:

```bash
cd data
source dumpFilenames.sh datasets.dat gfal
```

3. The output is in files named `data/filenames/<dataset name>.txt`. One file per dataset will be produced. All available input files will be listed in the file.

## Submitting jobs to Condor

1. The script `condorSubmitter.sh` can be used to submit jobs to Condor. The script takes three arguments: the file that lists the datasets, the transfer protocol to be used (gfal or xrootd), and a boolean that will only prepare but not submit if true. For example:

```bash
source condorSubmitter.sh data/datasets.dat gfal false
```

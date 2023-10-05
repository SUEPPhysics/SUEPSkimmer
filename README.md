# SUEPSkimmer

## Getting started

Will skim SUEPNano files produced by kraken at the MIT cluster. The default HLT path for skimming is `HLT_TripleMu_5_3_3*`.

To get started:

1. Initialize some CMSSW _(Note: `13_0_4` worked great for me)_
2. Clone this repository in src
3. Execute the following:

```bash
cd SUEPSkimmer
chmod +x compile.sh
./compile.sh
```

4. The scripts in `data` can be used to create lists of files. See README.md in `data` for more information.
5. The script `condorSubmitter.sh` can submit jobs to Condor. To just prepare but not submit:

   ```bash
   ./condorSubmitter.sh -d data/datasets.dat -p gfal
   ```

   To prepare and submit:

   ```bash
   ./condorSubmitter.sh -d data/datasets.dat -p gfal -s
   ```

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
./dumpFilenames.sh -d datasets.dat -p gfal
```

3. The output is in files named `data/filenames/<dataset name>.txt`. One file per dataset will be produced. All available input files will be listed in the file.

## Submitting jobs to Condor

1. The script `condorSubmitter.sh` can be used to submit jobs to Condor. The script takes three arguments: the file that lists the datasets, the transfer protocol to be used (gfal or xrootd), and a boolean that will only prepare but not submit if true. For example:

```bash
./condorSubmitter.sh -d data/datasets.dat -p gfal -s
```

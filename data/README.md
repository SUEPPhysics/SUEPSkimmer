# Data

Available datasets for the moment:
- `QCD_2016_apv`
- `QCD_2016`
- `QCD_2017`
- `QCD_2018`

First, get the files:
```bash
source dumpFilenames.sh QCD_2018.dat
```

Then, split the bins:
```bash
source splitBins.sh allFIles_QCD_2018.txt QCD_2018
```
and split files for jobs:
```bash
source splitFiles.sh QCD_2018 10
```
where `10` is the maximum number of files processed per job (use any number you want).
 

# Data

**NEW INSTRUCTIONS**
Place dataset names in a file `datasets.dat`, one per line.
Then, run

```bash
./dumpFilenames.sh -d datasets.dat -p gfal
```

where `gfal` is the protocol to use (`gfal` or `xrootd`).

If you want to check how many files exist per dataset, run

```bash
./countFilesAtMIT.sh -d datasets.dat -p gfal
```

If you are not submitting for the first time and you want to create a diff between the processed and unprocessed files, run

```bash
./diff -d datasets.dat -p gfal
```

_OLD INSTRUCTIONS_
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

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

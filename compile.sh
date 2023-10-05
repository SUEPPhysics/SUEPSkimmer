#!/bin/bash

# Create the necessary directories
if [ ! -d "condor/logs" ]; then
  mkdir -pv condor/logs
fi
if [ ! -d "bin" ]; then
  mkdir -v bin
fi

# Change the permissions of the scripts
chmod +x compile.sh condorSubmitter.sh data/dumpFilenames.sh

# Compile the C++ code
g++ Skimmer/src/skimRuns.cpp -o bin/skimRuns -march=native -O2 $(root-config --cflags --libs)
g++ Skimmer/src/skimmer.cpp -o bin/skimmer -march=native -O2 $(root-config --cflags --libs)

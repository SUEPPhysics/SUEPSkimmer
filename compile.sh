#!/bin/bash

g++ Skimmer/src/skimRuns.cpp -o bin/skimRuns -march=native -O2 `root-config --cflags --libs` -ISkimmer/include
g++ Skimmer/src/skimmer.cpp -o bin/skimmer -march=native -O2 `root-config --cflags --libs` -ISkimmer/include

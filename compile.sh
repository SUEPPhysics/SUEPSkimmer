#!/bin/bash

g++ Skimmer/src/skimmer.C -o bin/skimmer -march=native -O3 `root-config --cflags --libs` -ISkimmer/include

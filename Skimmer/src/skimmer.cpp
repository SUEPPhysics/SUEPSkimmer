#include <iostream>
#include "TBranch.h"
#include "TChain.h"
#include "TFile.h"
#include "TTree.h"

int main(int argc, char **argv)
{
    // Define variables for the trigger paths
    TBranch *branch1;
    TBranch *branch2;
    TBranch *branch3;
    Bool_t TriggerPass1 = 0;
    Bool_t TriggerPass2 = 0;
    Bool_t TriggerPass3 = 0;

    // THe input TTrees
    TChain *old_tree_Evts = new TChain("Events");
    TChain *old_tree_Lumi = new TChain("LuminosityBlocks");
    TChain *old_tree_Runs = new TChain("Runs");
    TChain *old_tree_Meta = new TChain("MetaData");
    TChain *old_tree_Para = new TChain("ParameterSets");
    for (int i = 2; i < argc; i++)
    {
        if (sizeof(argv[i]))
        {
            old_tree_Evts->Add(argv[i]);
            old_tree_Lumi->Add(argv[i]);
            old_tree_Runs->Add(argv[i]);
            old_tree_Meta->Add(argv[i]);
            old_tree_Para->Add(argv[i]);
        }
    }
    old_tree_Evts->GetEntry(0);
    old_tree_Lumi->GetEntry(0);
    old_tree_Runs->GetEntry(0);
    old_tree_Meta->GetEntry(0);
    old_tree_Para->GetEntry(0);

    // Setting branch addresses for trigger paths
    old_tree_Evts->SetBranchAddress("HLT_TripleMu_5_3_3", &TriggerPass1, &branch1);
    old_tree_Evts->SetBranchAddress("HLT_TripleMu_5_3_3_Mass3p8to60_DZ", &TriggerPass2, &branch2);
    old_tree_Evts->SetBranchAddress("HLT_TripleMu_5_3_3_Mass3p8_DZ", &TriggerPass3, &branch3);

    // Creating a new file to contain the selected events
    TFile *output_file = TFile::Open(argv[1], "RECREATE");

    // Making new tree, setting directory to new output file
    TTree *new_tree_Evts = old_tree_Evts->CloneTree(0);
    TTree *new_tree_Lumi = old_tree_Lumi->CloneTree(0);
    TTree *new_tree_Runs = old_tree_Runs->CloneTree(0);
    TTree *new_tree_Meta = old_tree_Meta->CloneTree(0);
    TTree *new_tree_Para = old_tree_Para->CloneTree(0);

    new_tree_Evts->SetName("Events");
    new_tree_Lumi->SetName("LuminosityBlocks");
    new_tree_Runs->SetName("Runs");
    new_tree_Meta->SetName("MetaData");
    new_tree_Para->SetName("ParameterSets");

    // Looping over events in old tree
    Long64_t numEntries = old_tree_Evts->GetEntries();
    std::cout << "Number of events: " << numEntries << std::endl;
    for (Long64_t event = 0; event < numEntries; ++event)
    {
        old_tree_Evts->GetEntry(event);
        if (!(event % 1000))
        {
            std::cout << "Processing: " << event << "th entry"
                      << "\n"
                      << std::flush;
            // Check if the content of trigger variables
            std::cout << "TriggerPass1: " << TriggerPass1 
                      << ", TriggerPass2: " << TriggerPass2 
                      << ", TriggerPass3: " << TriggerPass3
                      <<  "\n" << std::flush;
        }
        if (TriggerPass1 || TriggerPass2 || TriggerPass3)
        {
            new_tree_Evts->Fill();
        }
    }
    std::cout << std::endl;

    numEntries = old_tree_Lumi->GetEntries();
    for (Long64_t event = 0; event < numEntries; ++event)
    {
        old_tree_Lumi->GetEntry(event);
        new_tree_Lumi->Fill();
    }

    numEntries = old_tree_Runs->GetEntries();
    for (Long64_t event = 0; event < numEntries; ++event)
    {
        old_tree_Runs->GetEntry(event);
        new_tree_Runs->Fill();
    }

    numEntries = old_tree_Meta->GetEntries();
    for (Long64_t event = 0; event < numEntries; ++event)
    {
        old_tree_Meta->GetEntry(event);
        new_tree_Meta->Fill();
    }

    numEntries = old_tree_Para->GetEntries();
    for (Long64_t event = 0; event < numEntries; ++event)
    {
        old_tree_Para->GetEntry(event);
        new_tree_Para->Fill();
    }

    // Writing to tree
    new_tree_Evts->Write();
    new_tree_Lumi->Write();
    new_tree_Runs->Write();
    new_tree_Meta->Write();
    new_tree_Para->Write();
    output_file->Close();

    std::cout << "All done!" << std::endl;
    return 0;
}

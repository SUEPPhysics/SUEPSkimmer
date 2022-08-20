#include <iostream>
#include "TBranch.h"
#include "TChain.h"
#include "TFile.h"
#include "TTree.h"
// #include "progressbar.hpp"

int main( int argc, char **argv ) {
    TChain* old_tree_Runs = new TChain( "Runs" );
    for( int i = 2; i < argc; i++ ){
        if( sizeof(argv[i]) ){
            old_tree_Runs->Add( argv[i] );
        }
    }
    old_tree_Runs->GetEntry( 0 );

    // Creating a new file to contain the selected events
    TFile* output_file = TFile::Open( argv[1], "RECREATE" );
    
    TTree* new_tree_Runs = old_tree_Runs->CloneTree( 0 );

    new_tree_Runs->SetName( "Runs" );

    Long64_t numEntries = old_tree_Runs->GetEntries();
    for( Long64_t event = 0; event < numEntries; ++event ){
        old_tree_Runs->GetEntry( event );
        new_tree_Runs->Fill();
    }

    // Writing to tree
    new_tree_Runs->Write();
    output_file->Close();

    std::cout << "All done!" << std::endl;
    return 0;
}


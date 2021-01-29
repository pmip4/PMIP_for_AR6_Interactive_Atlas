#!/bin/bash

DATA_DIR=/data/CMIP/curated_ESGF_replica

PMIP3_MODELS="CCSM4 CNRM-CM5 COSMOS-ASO FGOALS-g2 GISS-E2-R IPSL-CM5A-LR MIROC-ESM MPI-ESM-P MRI-CGCM3"

#Pseudocode repeat for all desired variables. Making sure to select cal-adj or not appropriately
for mod_i in $PMIP3_MODELS
do
  ncclimo line
  ncremap line
done
ncecat line
ncks line to add model name as dimension

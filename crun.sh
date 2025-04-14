#!/bin/bash
#Compiles the source file and runs it 
#the compiled file is saved in the COMPILED folder
source_file=$1
output_file="${source_file%.*}"
#TODO: check if the output folder does not exist and create it.
output_file="00_COMPILED/$output_file"
# echo "Executable exported to -> " $output_file
cobc -x $source_file -o $output_file -j

#!/bin/bash
source_file=$1
output_file="${source_file%.*}"
output_file="COMPILED/$output_file"
# echo "Executable exported to -> " $output_file
cobc -x $source_file -o $output_file -j

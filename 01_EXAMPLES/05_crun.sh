#!/bin/bash

# compile the sub-program (no need to create an executable)
cobc -c 01_EXAMPLES/05_subprog.cob -o 00_COMPILED/01_EXAMPLES/05_subprog.o

# compile and create executable from main program
cobc -x 01_EXAMPLES/05_mainprog.cob 00_COMPILED/01_EXAMPLES/05_subprog.o -o 00_COMPILED/01_EXAMPLES/05_mainprog

./00_COMPILED/01_EXAMPLES/05_mainprog



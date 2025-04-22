# Cobol Sandbox Project

This project contains a small Banking Transaction simulator. And various basic Cobol examples.

## Cobol Banking System

This COBOL project simulates a **simple banking system**, allowing users to:

- View account information  
- Perform and record transactions  
- Review transaction history  

### Compile and Run

We use GnuCobol to compile and run. make sure it is installed.

Use this script to compile and run the program:

```bash
./crun.sh 02_BANKING/01_banking_with_file.cob
```

## Cobol Code Examples
The additional examples are located in the **01_EXAMPLES** directory.

### Run the Examples
```bash
./crun.sh 01_EXAMPLES/xx_example_name.cob
```

### Run Example 05

This example is an exception because it compiles a main program which calls a subprogram.

Therefore the subprogram has to be compiled before the main program.

This process can be done automatically by executing:
```bash
./01_EXAMPLES/05_crun.sh  
```

### Requirements
gnuCOBOL is used to compile and create executables.

`sudo apt-get install gnucobol`




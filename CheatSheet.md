# Cobol Notes

## History and Purpose
**COBOL**: **CO**mmon **B**usiness-**O**riented **L**anguage

Business Oriented, developed in 1959
COBOL was designed for business-oriented applications related to financial domain, defense domain, etc. 
It can handle huge volumes of data because of its advanced file handling capabilities.
Generally COBOL is not used for front-end web development, 
however it can be integrated with web services and back-end systems to support web applications.

## Program Structure

A Cobol program is structured in divisions.

1. `IDENTIFICATION DIVISION.` (Mandatory)
    - `PROGRAM-ID.` is the only mandatory paragraph. It specifies the program name that can consist 1 to 30 characters.
    - `AUTHOR.`, `INSTALLATION.`,`DATE-WRITTEN`, `DATE-COMPILED.`, `SECURITY.` (Optional)

2. `ENVIRONMENT DIVISION.`
    
    Specifies input and output files to the program. 
    
    It consists of two sections:

    - `CONFIGURATION SECTION.` provides information about the system on which the program is written and executed. 
        
        It consists of two paragraphs:
        - `SOURCE COMPUTER.` − System used to compile the program.
        - `OBJECT COMPUTER.` − System used to execute the program.
    - `INPUT-OUTPUT SECTION.` provides information about the files to be used in the program. 
    
        It consists of two paragraphs:        
        - `FILE CONTROL.` − Provides information of external data sets used in the program.
        - `I-O CONTROL.` − Provides information of files used in the program.

3. `DATA DIVISION.`
defines the variables used in the program. 

    It consists of four sections:
    - `FILE SECTION.` defines the record structure of the files used in the program.
    - `WORKING-STORAGE SECTION.` declares temporary variables and record structures which are used in the program.
    - `LOCAL-STORAGE SECTION.` is similar to `WORKING-STORAGE SECTION`. The only difference is that the variables will be allocated and initialized every time a program starts execution.
    - `LINKAGE SECTION.` describes the data variable names that are received from an external program.

4. `PROCEDURE DIVISION.`
    Procedure division is used to include the logic of the program. 
    It consists of executable statements using variables defined in the data division. 
    In this division, paragraph and section names are user-defined.

COBOL control structures
conditional statements (IF, EVALUATE)
loops (PERFORM).

## Syntax

### Characters

- `A-Z` Alphabets(Upper Case)
- `a-z` Alphabets (Lower Case)
- `0-9` Numeric
- ` ` Space
- `+ - * / $ , ; . " ( ) < > : ' =`  Signs



### Coding Sheet
COBOL programs are written on COBOL coding sheets. There are **80 character** positions on each line of a coding sheet.
Character positions are grouped into the following five fields

| Positions | Field | Example Content | Explanation |
|  :----: | :----: |  :----:| :----: |
| 1–6 | Column Numbers | 000200 | Line number |
| 7 | Indicator | (blank) | `*` -> code comment |
| 8–11 | Area A | `DATA DIVISION.` | Area A unused here (no division/section/paragraph here) |
| 12–72 | Area B | `MOVE ZERO TO TOTAL` | COBOL executable statement |
| 73–80 | Identification Area | MYPRG01 | Programmer's use 


## Variable Definition
The program variables are normally defined in the `DATA DIVISION`, specifically in the `WORKING-STORAGE SECTION`

```cobol
DATA DIVISION.
WORKING-STORAGE SECTION.

01 WS-CUSTOMER-RECORD.
    05 WS-CUSTOMER-ID         PIC 9(6).
    05 WS-CUSTOMER-NAME       PIC A(30).
    05 WS-CUSTOMER-ADDRESS    PIC X(50).
        10 WS-STREET          PIC 9(4).
        10 WSHOUSE-NUMBER     PIC 9(2).
        10 WS-CITY            PIC 9(2).

01 WS-ACCOUNT-RECORD.
    05 WS-ACCOUNT-NUMBER      PIC 9(10).
    05 WS-ACCOUNT-BALANCE     PIC S9(7)V99 COMP-3.

01 WS-TRANSACTION-COUNT        PIC 9(4) COMP VALUE 0.
01 WS-TEMP-NUMBER              PIC 9(6).
01 WS-TEMP-AMOUNT              PIC 9(7)V99.
```

### Data Types

In COBOL, the type of a variable is declared using the `PIC` (short for "PICTURE") clause, followed by a type symbol and a size specification. The main type symbols are `9` for numeric, `A` for alphabetic, and `X` for alphanumeric values. Additional characters like `S` indicates that the number is signed (positive or negative), `V` represents an implied decimal point (not physically stored), and `$` is used for currency formatting in numeric fields.

Data Type | Example | Description | Possible Values
---- | ---- | ---- | ----
PIC 9 | PIC 9(5) | Numeric data type for integers. The number inside the parentheses specifies the number of digits. | 00000-99999
PIC A | PIC A(10) | Alphabetic data type. The number inside the parentheses specifies the length of the string. | A-Z, a-z (10 alphabetic characters only)
PIC X | PIC X(10) | Alphanumeric (character) data type. The number inside the parentheses specifies the length of the string. | Any alphabetic character (A-Z, a-z), digits (0-9), and special characters.
PIC 99 | PIC 99 | A numeric field with two digits. It is used for small integer values. | 00-99
PIC 99V99 | PIC 99V99 | Numeric data with a fixed decimal point, commonly used for handling currency. | Any number from 00.00 to 99.99
FLOATING POINT | PIC 9(5)V99 | A floating-point type for values requiring a decimal point with a variable number of digits after it. | Any floating-point number (e.g., 0.0001 to 99999.99)
PIC S9 | PIC S9(5) COMP | Signed numeric data type (using a sign). The S represents the sign (positive/negative). | -99999 to 99999
COMP (Computational) | PIC 9(5) COMP | Binary format for optimized storage and fast arithmetic processing. COMP stores numbers in a compact binary form. | Any integer value (depends on the system's word size, e.g., -32768 to 32767 for 2-byte integers)
COMP-3 (Packed Decimal) | PIC S9(5) COMP-3 | A packed decimal type where two digits are stored in one byte, except for the last digit which takes half a byte. It is commonly used for efficient storage of numeric values. | Any integer value (e.g., -99999 to 99999)
PICTURE CLUSTER (COMP-5) | PIC 9(5) COMP-5 | An efficient representation for numeric data using the system's native integer format. | Depends on system architecture (e.g., -32768 to 32767 for 2-byte integers)


### Variable Declaration

A variable (or **data item**) is declared with **three main parts**:

1. **Level Number**:  
   A number indicates the variable's hierarchy or structure.  

    Level Number | Meaning
    ---- | ----
    01 | Top-level data item (can be a group or elementary
    item). Used for major structures.
    02-49 | Used for subfields (children) within a group item. Defines structure and hierarchy.
    66 | Special level for RENAMES clause (used to create alternative names for groups of fields).
    77 | Independent elementary item (not part of a group). No children allowed.
    88 | Used for Condition Names (special flags or meaningful values attached to a field).

2. **Data Name**:  
   The name of the variable (must follow COBOL naming rules:

   1. **Characters allowed**:  Only **letters (A-Z)**, **digits (0-9)**, and **hyphens (-)** are allowed.

    2. **Start with a letter**: The first character must always be a **letter** (A-Z).

    3. Use hyphens (`-`) to separate words. **No spaces**: and **No consecutive hyphens**: (like `EMP--NAME`).

    5. **No ending hyphen**:A data name **cannot end with a hyphen**.

    6. **Length limit**: The maximum length of a data name is **up to 30 characters** (some compilers allow more today).

    7. **Case insensitive**: COBOL treats uppercase and lowercase letters the **same** (`EMPLOYEE-NAME` and `employee-name` are considered identical).

    8. **Reserved words not allowed**: You can't use COBOL reserved words (like `IF`, `MOVE`, `DISPLAY`, etc.) as data names.

    Naming Prefixes: 
    - `WS-` for variables in the Working-Storage Section
    - `FD-, F-` for File Description section variables
    - `LK-` sometimes used for Linkage Section variables
    - `TEMP-, CNT-, SW- FLG` short for temporary, counter, switch and flag variables respectively.

3. **Picture Clause (`PIC`)**:  
   Defines the **type** and **length** of the data.  
   Common types:
    - `9` → Numeric digits only
    - `A` → Alphabetic characters (A-Z)
    - `X` → Alphanumeric (letters, numbers, symbols)

   The type symbol is usually followed by parentheses showing how many characters or digits are allowed.  
   Example: `PIC 9(5)` means a numeric field with 5 digits.

4. **Optional VALUE Clause**:  
   - Used to assign an **initial value** when the program starts.  
   - Example: `VALUE "HELLO"` or `VALUE ZEROES`.


Arithmetic operations: 
ADD, SUBTRACT, MULTIPLY, DIVIDE, and COMPUTE verbs.


## Strings

In COBOL, string manipulation is handled through three important verbs: **INSPECT**, **STRING**, and **UNSTRING**.  These verbs allow you to count, modify, combine, or split character data stored in variables.  
String operations can be performed on **alphanumeric**, **alphabetic**, and sometimes **numeric** fields.  

### INSPECT

The **INSPECT** verb is used to **count** or **replace** characters within a string.  
Operations are performed **from left to right** across the string.

**Example:**
```cobol
INSPECT CUSTOMER-NAME TALLYING SPACE-COUNT FOR ALL SPACES.
```
*Counts the number of spaces in `CUSTOMER-NAME` and stores the count in `SPACE-COUNT`.*

```cobol
INSPECT ADDRESS REPLACING ALL "-" BY " ".
```
*Replaces all hyphens in `ADDRESS` with spaces.*

### STRING
verb is used to **concatenate** multiple strings into a single longer string.  
It combines two or more strings into a target variable.  
The **DELIMITED BY** clause is **mandatory** to indicate where each input string ends.

**Example:**
```cobol
STRING FIRST-NAME DELIMITED BY SPACE
       LAST-NAME  DELIMITED BY SPACE
  INTO FULL-NAME.
```
*Combines `FIRST-NAME` and `LAST-NAME` into `FULL-NAME` with spaces as delimiters.*



#### UNSTRING

The **UNSTRING** verb is used to **split** a single string into multiple **substrings** based on delimiters.  
The **DELIMITED BY** clause is **mandatory** to specify the splitting point.

**Example:**
```cobol
UNSTRING FULL-NAME DELIMITED BY SPACE
   INTO FIRST-NAME LAST-NAME.
```
*Splits `FULL-NAME` into `FIRST-NAME` and `LAST-NAME` wherever a space is found.*



## Tables and records



## File Handling

A file is a collection of related records.
Where a record is a collection of fields that is used to describe an entity.
Physical record is the information that exists on the external device. It is also known as a block.
Logical record is the information used by the program. In COBOL programs, only one record can be handled at any point of time and it is called as logical record.

### File Organization

The file organization defines how the records are stored, and accessed within a file.

The possible file organizations are:

1. SEQUENTIAL
    - Records are stored one after another, in the order they are written.
    - To access a record all the previous records must be read.
    ```
    INPUT-OUTPUT SECTION.
    FILE-CONTROL.
    SELECT DATA-FILE ASSIGN TO "data.dat"
    ORGANIZATION IS SEQUENTIAL
    ACCESS MODE IS SEQUENTIAL
    ```

2. INDEXED
    - Each record has a key and can be found directly for it.
    - Allows insertion, update, deletion without affecting other records.
    - Ideal for files that behave like small databases.
    ```
    INPUT-OUTPUT SECTION.
    FILE-CONTROL.
        SELECT EMPLOYEE-FILE
            ASSIGN TO "employee_file.dat"
            ORGANIZATION IS INDEXED
            ACCESS MODE IS DYNAMIC
            RECORD KEY IS EMPLOYEE-ID
            FILE STATUS IS FILE-STATUS.
    ```
3. RELATIVE
    - Records are accessed using a relative record number (position within the file).
    - Allows direct random access to any record based on its number.
    - Useful when records are naturally numbered (like ID 1, 2, 3...).
    ```
    INPUT-OUTPUT SECTION.
    FILE-CONTROL.
        SELECT REL-FILE-NAME 
            ASSIGN TO "relative.dat"
            ORGANIZATION IS RELATIVE
            RELATIVE KEY IS rec-key
    ```




### File Access Mode

File Access Mode defines how the program will access the records in a file, that is, how it reads, writes, or navigates through the file.

The access mode types are:

1. Sequential Access
    - Records must be accessed in the order they appear in the file.
2. Random Access
    - Access any record directly, by specifying the key or record number.
3. Dynamic Access
    - Allows both sequential and random access in the same program.


### Possible File Organization and Access Modes combinations

File Organization   | Sequential Access | Random Access     | Dynamic Access
--- | --- | --- | ---
SEQUENTIAL          | ✅ Allowed        | ❌ Not allowed    | ❌ Not allowed
INDEXED             | ✅ Allowed        | ✅ Allowed        | ✅ Allowed
RELATIVE            | ✅ Allowed        | ✅ Allowed        | ✅ Allowed


BULLET PROOF COMBINATION:
File Organization **INDEXED** - Access Mode: **DYNAMIC**


### File Handling Verbs
1. **OPEN**

    The first operation is always to open the file.
    ```
    OPEN "mode" file-name.
    ```
    Mode | Purpose | Typical Usage
    --- |  --- |  --- 
    INPUT | To read from an existing file. | Reading records.
    OUTPUT | To create a new file and write to it. | Writing new records, overwriting any previous file.
    EXTEND | To add (append) records to the end of an existing file. | Adding new records without disturbing old ones.
    I-O | To read and update records. | Read, modify, and rewrite records.
     
1. **READ**

    Reads one record from the file. 
    - To perform a read operation, open the file in INPUT or I-O mode. 
    - At each read statement, the file pointer is incremented and hence the successive records are read.
    ```
    READ file-name NEXT RECORD INTO ws-file-structure
    AT END DISPLAY 'End of File'
    NOT AT END DISPLAY 'Record Details:' ws-file-structure
    END-READ.
    ```
1. **WRITE**
    - Write verb is used to insert records in a file. 
    - Once the record is written, it is no longer available in the record buffer. 
    - Before inserting records into the file, move the values into the record buffer and then perform write verb.
1. **REWRITE**
    - Rewrite verb is used to update the records. 
    - File should be opened in I-O mode for rewrite operations.
1. **DELETE**
    - Delete verb can be performed only on indexed and relative files. 
    - The file must be opened in I-O mode. In sequential file organization, records cannot be deleted. 
1. **START**
1. **CLOSE**
    - Close verb is used to close a file. 
    - After performing Close operation, the variables in the file structure will not be available for processing. 
    The link between program and file is lost.

## Compile with gnuCOBOL
Cobol Compiler:

`sudo apt-get install gnucobol`


Run `cobc` with:

**Options** | **Description**
--- | ---
`-h -help` | Manual
`-x` | build an executable program
`-j [<args>], -job[=<args>]` | run program after build, passing `<args>`
`-F, -free` | use free source format
`-d, -debug`  | enable all run-time error checking,
`-o <file> `| place the output into `<file>`
`-C` | translation only; convert **COBOL** to **C**


## References
1. https://www.tutorialspoint.com/cobol/index.htm


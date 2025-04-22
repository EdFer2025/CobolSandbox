       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUBPROG.
       
       DATA DIVISION.
       LINKAGE SECTION.
       01 LK-NAME PIC A(20).
       
       PROCEDURE DIVISION USING LK-NAME.
           DISPLAY "Hello, " LK-NAME
           EXIT PROGRAM.
           
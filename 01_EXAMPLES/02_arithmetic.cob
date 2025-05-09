       IDENTIFICATION DIVISION. 
       PROGRAM-ID. ADD_TWO_NUMBERS.
       AUTHOR.     Eduardo Feria.
       
       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUM1 PIC 9(2).
       01 WS-NUM2 PIC 9(2).
       01 WS-NUM-SUM PIC 9(2).

       PROCEDURE DIVISION.

           ACCEPT WS-NUM1
           ACCEPT WS-NUM2

           ADD WS-NUM1 TO WS-NUM2 GIVING WS-NUM-SUM
           
           DISPLAY "THE SUM OF " WS-NUM1 " AND " WS-NUM2 
           " IS " WS-NUM-SUM
       STOP RUN.
           
       END PROGRAM ADD_TWO_NUMBERS.
       
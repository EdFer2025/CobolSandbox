       IDENTIFICATION DIVISION. 
       PROGRAM-ID. HELLO_WORLD_DATE.
       AUTHOR.     Eduardo Feria.
      *This is a comment in COBOL. 

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 WS-DATE PIC X(10).

       PROCEDURE DIVISION.
           ACCEPT WS-DATE FROM DATE
      *    TODO: Format the date          
           DISPLAY "HELLO WORLD! Today is" WS-DATE
       STOP RUN.
           
       END PROGRAM HELLO_WORLD_DATE.
       
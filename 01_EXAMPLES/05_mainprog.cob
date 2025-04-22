       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAINPROG.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME PIC A(20).
       
       PROCEDURE DIVISION.
           DISPLAY "Enter your name: "
           ACCEPT WS-NAME
           CALL "SUBPROG"
               USING WS-NAME
           END-CALL
           STOP RUN.
       END PROGRAM MAINPROG.

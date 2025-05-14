       IDENTIFICATION DIVISION. 
       PROGRAM-ID. ADD_TWO_NUMBERS.
       AUTHOR.     Eduardo Feria.
       
       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-A PIC S9(2) VALUE 1.
       01 WS-B PIC S9(2) VALUE 2.
       01 WS-C PIC S9(2) VALUE 3.
       01 WS-D PIC S9(2) VALUE 4.
       01 WS-E PIC S9(2) VALUE 5.
       01 WS-RES PIC S9(2) VALUE 0.

       PROCEDURE DIVISION.           
           DISPLAY "INITIAL VALUES:"
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B 
                   ", WS-C: " WS-C 
                   ", WS-D: " WS-D 
                   ", WS-E: " WS-E 
                   ", WS-RES: " WS-RES
           
           
           DISPLAY X"0A" & "+++++++++++++++++++++++++++++++++++" & X"0A"

           DISPLAY "ADD WS-A TO WS-B GIVING WS-RES"
           ADD WS-A TO WS-B GIVING WS-RES
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B 
                   ", WS-RES: " WS-RES

           DISPLAY X"0A" & "+++++++++++++++++++++++++++++++++++" & X"0A"

           DISPLAY "ADD WS-A TO WS-B (this modifies WS-B)"
           ADD WS-A TO WS-B
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B

           DISPLAY X"0A" & "+++++++++++++++++++++++++++++++++++" & X"0A"

           DISPLAY X"0A" & "-----------------------------------" & X"0A"
           
           DISPLAY "SUBTRACT WS-A FROM WS-B (this modifies WS-B)"
           SUBTRACT WS-A FROM WS-B
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B
           
           DISPLAY X"0A" & "-----------------------------------" & X"0A"
           
           DISPLAY "SUBTRACT WS-B FROM WS-A GIVING WS-RES"
           SUBTRACT WS-B FROM WS-A GIVING WS-RES
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B 
                   ", WS-RES: " WS-RES
           
           DISPLAY X"0A" & "-----------------------------------" & X"0A"
           
           DISPLAY X"0A" & "***********************************" & X"0A"
           
           DISPLAY "MULTIPLY WS-C BY WS-D GIVING WS-RES"
           MULTIPLY WS-C BY WS-D GIVING WS-RES
           DISPLAY "WS-C: " WS-C 
                   ", WS-D: " WS-D 
                   ", WS-RES: " WS-RES
           
           DISPLAY X"0A" & "***********************************" & X"0A"

           DISPLAY "MULTIPLY WS-C BY WS-D (this modifies WS-D)"
           MULTIPLY WS-C BY WS-D
           DISPLAY "WS-C: " WS-C 
                   ", WS-D: " WS-D
           
           DISPLAY X"0A" & "***********************************" & X"0A"

           DISPLAY X"0A" & "///////////////////////////////////" & X"0A"
           
           DISPLAY "DIVIDE WS-C INTO WS-D (this modifies WS-D)"
           DIVIDE WS-C INTO WS-D
           DISPLAY "WS-C: " WS-C 
                   ", WS-D: " WS-D
           
           DISPLAY X"0A" & "///////////////////////////////////" & X"0A"

           DISPLAY "DIVIDE WS-C INTO WS-D GIVING WS-RES"
           DIVIDE WS-C INTO WS-D GIVING WS-RES
           DISPLAY "WS-C: " WS-C 
                   ", WS-D: " WS-D 
                   ", WS-RES: " WS-RES
           
           DISPLAY X"0A" & "///////////////////////////////////" & X"0A"

           DISPLAY "DIVIDE WS-C INTO WS-D GIVING WS-RES"
           DIVIDE WS-C INTO WS-D GIVING WS-RES REMAINDER WS-E
           DISPLAY "WS-C: " WS-C 
                   ", WS-D: " WS-D 
                   ", WS-E: " WS-E
                   ", WS-RES: " WS-RES
           
           DISPLAY X"0A" & "///////////////////////////////////" & X"0A"

           DISPLAY X"0A" & "<< COMPUTE >>" & X"0A"
           DISPLAY "WS-A: " WS-A 
                   ", WS-B: " WS-B 
                   ", WS-C: " WS-C 
                   ", WS-D: " WS-D 
                   ", WS-E: " WS-E

           COMPUTE WS-RES = (WS-A + WS-D) * WS-C - WS-D / WS-C
           DISPLAY "WS-RES: " WS-RES  

       STOP RUN.
           
       END PROGRAM ADD_TWO_NUMBERS.
       
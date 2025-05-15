       IDENTIFICATION DIVISION.       
       PROGRAM-ID. LOOP-EXPRESSIONS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-COUNTER       PIC S9 VALUE 3.
       
       PROCEDURE DIVISION.

      *    INLINE PERFORM
           PERFORM
               DISPLAY "PERFORM examples:"
           END-PERFORM
           
      *    SIMPLE PERFORM
           DISPLAY X"0A" & "PERFORM PARAGRAPH-1"
           PERFORM PARAGRAPH-1

           DISPLAY X"0A" & "PERFORM PARAGRAPH-2 THRU PARAGRAPH-4"
           PERFORM PARAGRAPH-2 THRU PARAGRAPH-4

      *    PERFORM TIMES
           DISPLAY X"0A" & "PERFORM 3 TIMES"
           PERFORM 3 TIMES
               DISPLAY "One loop"
           END-PERFORM

           DISPLAY X"0A" & "PERFORM PARAGRAPH-1 3 TIMES"
           PERFORM PARAGRAPH-1 3 TIMES

           DISPLAY X"0A" & "PERFORM PARAGRAPH-2 THRU PARAGRAPH-4"
               " 2 TIMES"
           PERFORM PARAGRAPH-2 THRU PARAGRAPH-3 2 TIMES

      *    PERFORM UNTIL
           DISPLAY X"0A" & "PERFORM UNTIL WS-COUNTER <= 0"
           PERFORM UNTIL WS-COUNTER <= 0
               DISPLAY "WS-COUNTER: " WS-COUNTER
               SUBTRACT 1 FROM WS-COUNTER
           END-PERFORM
           
           DISPLAY X"0A" & "PERFORM PARAGRAPH-5 UNTIL WS-COUNTER >= 3"
           MOVE 0 TO WS-COUNTER
           PERFORM PARAGRAPH-5 UNTIL WS-COUNTER >= 3

           DISPLAY X"0A" & 
               "PERFORM PARAGRAPH-5 WITH TEST BEFORE"
               " UNTIL WS-COUNTER >= 3"
           MOVE 0 TO WS-COUNTER
           PERFORM PARAGRAPH-5 WITH TEST BEFORE UNTIL WS-COUNTER >= 3

           DISPLAY X"0A" & 
               "PERFORM PARAGRAPH-5 WITH TEST AFTER"
               " UNTIL WS-COUNTER >= 3"
           MOVE 0 TO WS-COUNTER
           PERFORM PARAGRAPH-5 WITH TEST AFTER UNTIL WS-COUNTER >= 3

           DISPLAY X"0A" & 
               "PERFORM VARYING WS-COUNTER FROM 1 BY 1"
               " UNTIL WS-COUNTER = 3"
           PERFORM VARYING WS-COUNTER FROM 1 BY 1 
               UNTIL WS-COUNTER = 3
               DISPLAY "WS-COUNTER: " WS-COUNTER
           END-PERFORM

           DISPLAY X"0A" & 
               "PERFORM WITH TEST AFTER"
               " VARYING WS-COUNTER FROM 1 BY 1"
               " UNTIL WS-COUNTER = 3"
           PERFORM WITH TEST AFTER 
               VARYING WS-COUNTER FROM 1 BY 1 UNTIL WS-COUNTER = 3
               DISPLAY "WS-COUNTER: " WS-COUNTER
           END-PERFORM   
           
           STOP RUN.

       PARAGRAPH-1.
           DISPLAY "PARAGRAPH-1"
           .

       PARAGRAPH-2.
           DISPLAY "PARAGRAPH-2"
           .

       PARAGRAPH-3.
           DISPLAY "PARAGRAPH-3"
           .
       
       PARAGRAPH-4.
           DISPLAY "PARAGRAPH-4"
           .
       
       PARAGRAPH-5.
           DISPLAY "PARAGRAPH-5 -> " WITH NO ADVANCING
           DISPLAY "WS-COUNTER: " WS-COUNTER
           ADD 1 TO WS-COUNTER
           .

       END PROGRAM LOOP-EXPRESSIONS.

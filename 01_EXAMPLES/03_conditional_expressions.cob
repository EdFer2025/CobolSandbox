       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONDITIONAL-EXPRESSIONS.
       AUTHOR. EDUARDO FERIA.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NUM-1         PIC S9(2) VALUE 0.
       01 WS-VAL-1         PIC X(9).

       01 GENDER           PIC X VALUE "U".
           88 MALE     VALUE "M".
           88 FEMALE   VALUE "F".       
       
      * WS-AGE-GROUP is a CONDITIONAL VARIABLE with 4 CONDITION NAMES
       01 WS-AGE-GROUP     PIC 99.
           88 BABY     VALUE 0, 1, 2.
           88 CHILD    VALUE 3 THRU 12.
           88 TEENAGER VALUE  13 THRU 17.
           88 ADULT    VALUE 18 THRU 50 AND 50 THRU 99.

       PROCEDURE DIVISION.
           
           DISPLAY X"0A" & "**** CHECK IF CONDITION ****"     
           PERFORM CHECK-IF-CONDITION           
           MOVE "F" TO GENDER
           PERFORM CHECK-IF-CONDITION           
           SET MALE TO TRUE
           PERFORM CHECK-IF-CONDITION

           DISPLAY X"0A" & "**** CHECK EVALUATE CONDITION ****"
           PERFORM CHECK-EVALUATE-CONDITION
           ADD 15 TO WS-NUM-1
           PERFORM CHECK-EVALUATE-CONDITION

           DISPLAY X"0A" & "**** CHECK CLASS CONDITION ****"
           MOVE "HELLO" TO WS-VAL-1
           PERFORM CHECK-CLASS-CONDITION
           MOVE "hello" TO WS-VAL-1
           PERFORM CHECK-CLASS-CONDITION
           MOVE "Hello" TO WS-VAL-1
           PERFORM CHECK-CLASS-CONDITION
           MOVE 12345 TO WS-VAL-1
           PERFORM CHECK-CLASS-CONDITION
           MOVE "HELLO 1" TO WS-VAL-1
           PERFORM CHECK-CLASS-CONDITION
           
           DISPLAY X"0A" & "**** CHECK CONDITION NAME ****"
           MOVE 2 TO WS-AGE-GROUP
           PERFORM CHECK-CONDITION-NAME
           MOVE 5 TO WS-AGE-GROUP
           PERFORM CHECK-CONDITION-NAME
           MOVE 15 TO WS-AGE-GROUP
           PERFORM CHECK-CONDITION-NAME
           MOVE 51 TO WS-AGE-GROUP
           PERFORM CHECK-CONDITION-NAME
           SET TEENAGER TO TRUE
           DISPLAY "SET TEENAGER TO TRUE"
           PERFORM CHECK-CONDITION-NAME

           DISPLAY X"0A" & "**** CHECK LOGICAL OPERATORS ****"
           MOVE 1 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE 50 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE 51 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE 100 TO WS-NUM-1           
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE 0 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE -1 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS
           MOVE -51 TO WS-NUM-1
           PERFORM CHECK-LOGICAL-OPERATORS

           STOP RUN.
       
       CHECK-IF-CONDITION.           
           DISPLAY "GENDER VALUE: " GENDER " - " WITH NO ADVANCING

           IF MALE
               DISPLAY "GENDER: MALE"
           ELSE
               IF FEMALE
                   DISPLAY "GENDER: FEMALE"
               ELSE
                   DISPLAY "GENDER: " GENDER " (UNKNOWN)"
               END-IF
           END-IF 
           .

       CHECK-EVALUATE-CONDITION.
           DISPLAY "WS-NUM-1 = " WS-NUM-1 " ==> " WITH NO ADVANCING
           EVALUATE WS-NUM-1
               WHEN 0
                   DISPLAY "WS-NUM-1 = 0"
               WHEN 1 THRU 20
                   DISPLAY "WS-NUM-1 IS BETWEEN 1 AND 20"
               WHEN OTHER
                   DISPLAY "NO CONDITION WAS MET. WS-NUM-1 = " WS-NUM-1
           END-EVALUATE
           .

       CHECK-CLASS-CONDITION.
           DISPLAY X"0A" & "WS-VAL-1 = " WS-VAL-1 
           
           IF WS-VAL-1 IS ALPHABETIC
               DISPLAY "  ==> IS ALPHABETIC"
           END-IF
           IF WS-VAL-1 IS NOT ALPHABETIC
               DISPLAY "  ==> IS NOT ALPHABETIC"
           END-IF
           IF WS-VAL-1 IS ALPHABETIC-LOWER
               DISPLAY "  ==> IS ALPHABETIC-LOWER"
           END-IF
           IF WS-VAL-1 IS NOT ALPHABETIC-LOWER
               DISPLAY "  ==> IS NOT ALPHABETIC-LOWER"
           END-IF
           IF WS-VAL-1 IS ALPHABETIC-UPPER
               DISPLAY "  ==> IS ALPHABETIC-UPPER"
           END-IF
           IF WS-VAL-1 IS NOT ALPHABETIC-UPPER
               DISPLAY "  ==> IS NOT ALPHABETIC-UPPER"
           END-IF           
           IF WS-VAL-1 IS NUMERIC
               DISPLAY "  ==> IS NUMERIC"
           END-IF
           IF WS-VAL-1 IS NOT NUMERIC
               DISPLAY "  ==> IS NOT NUMERIC"
           END-IF
           .

       CHECK-CONDITION-NAME.
           DISPLAY "AGE VALUE = " WS-AGE-GROUP WITH NO ADVANCING
           EVALUATE TRUE
               WHEN BABY       DISPLAY " ==> BABY"
               WHEN CHILD      DISPLAY " ==> CHILD"
               WHEN TEENAGER   DISPLAY " ==> TEENAGER"
               WHEN ADULT      DISPLAY " ==> ADULT"
               WHEN OTHER      DISPLAY " ==> NOT IN AGE GROUPS"  
           .
       
       CHECK-LOGICAL-OPERATORS.
      * USING IS POSITIVE, NEGATIVE, ZERO, NOT, 
      * GREATER THAN, LESS THAN, EQUAL, <, <=, >, >=, =
      * NOTE: 0 IS NOT CONSIDERED EITHER POSITIOVE OR NEGATIVE

           DISPLAY "WS-NUM-1 = " WS-NUM-1 

           IF WS-NUM-1 IS NOT POSITIVE AND WS-NUM-1 IS NOT NEGATIVE
               DISPLAY "==> IS NOT POSITIVE AND NOT NEGATIVE."
           END-IF
           IF WS-NUM-1 IS ZERO
               DISPLAY "==> IS ZERO."
           END-IF
           
           IF WS-NUM-1 IS POSITIVE
               DISPLAY " ==> IS STRICTLY POSITIVE."
               IF WS-NUM-1 IS GREATER THAN 50 AND LESS THAN OR EQUAL 99
                   DISPLAY " ==> IS IN THE RANGE [51,99]"
               ELSE
                   DISPLAY " ==> IS IN THE RANGE [1,50]"
               END-IF
           END-IF
           IF WS-NUM-1 IS NEGATIVE
               DISPLAY " ==> IS STRICTLY NEGATIVE."
               IF WS-NUM-1 < -50 AND WS-NUM-1 >= -99
                   DISPLAY " ==> IS IN THE RANGE [-99,-51]"
               ELSE
                   DISPLAY " ==> IS IN THE RANGE [-50,-1]" 
               END-IF
           END-IF           
           .
           
       
           
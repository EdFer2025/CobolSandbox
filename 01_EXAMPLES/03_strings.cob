       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRINGS-HAND.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *INSPECT:    Search in the string
      *STRING:     Concatenate strings
      *UNSTRING:   Split a string

      *If a string contains spaces has to be saved in ALPHANUMERIC
       01 WS-STRING-A      PIC X(60) 
           VALUE "This is a string like no other string in the world".
       01 WS-COUNT         PIC 9(2).
       01 WS-COUNT-2       PIC 9(2).
       01 WS-COUNT-3       PIC 9(2).

       01 WS-STRING-B      PIC X(35)
           VALUE "The dog plays with the ball".
       01 WS-STRING-C      PIC X(20)
           VALUE "while the bird sings".
       01 WS-STRING-D      PIC X(55).

       01 WS-STRING-E      PIC X(40)
           VALUE "FirstWord SecondWord ThirdWord".
       01 WS-STRING-F      PIC X(20).
       01 WS-STRING-G      PIC X(20).
       01 TEMP-STRING-1    PIC X(20).



       PROCEDURE DIVISION.
       DISPLAY X"0A" & "**** INSPECT STRINGS ****"       
       PERFORM USE-INSPECT
       DISPLAY X"0A" & "**** CONCATENATING STRINGS ****"
       PERFORM USE-STRING
       DISPLAY X"0A" & "**** PARSING STRINGS WITH UNSTRING ****"
       PERFORM USE-UNSTRING

       STOP RUN.
       
       USE-INSPECT.
           DISPLAY "String to INSPECT:" WS-STRING-A
      *    FIND SUBSTRINGS 
           INSPECT WS-STRING-A TALLYING WS-COUNT FOR ALL 'i'
           DISPLAY "CHARACTER i COUNT: " WS-COUNT
    
           INSPECT WS-STRING-A TALLYING WS-COUNT-2 FOR ALL 'string'
           DISPLAY "CHARACTER i COUNT: " WS-COUNT-2
    
           INSPECT WS-STRING-A TALLYING WS-COUNT-3 FOR ALL CHARACTERS
           DISPLAY "MAX STRING SIZE: " WS-COUNT-3

           DISPLAY X"0A" & "REPLACE "
               "(the strings to replace must be the same size)"
           INSPECT WS-STRING-A REPLACING ALL "world   " BY "universe"
           DISPLAY "NEW STRING: " WS-STRING-A
           
           DISPLAY X"0A" & "REPLACE the second string by thing"
           INSPECT WS-STRING-A REPLACING FIRST "string" BY "thing "
               AFTER INITIAL "string"
           DISPLAY "NEW STRING: " WS-STRING-A
           .           

       USE-STRING.
      * STRING identifier-1 or literal-1
      *      DELIMITED BY identifier-2 or literal-2 or SIZE
      *           INTO identifier-3
      *     [WITH POINTER identifier-4]
      *     [ON OVERFLOW imperative-statement-1]
      *     [NOT ON OVERFLOW imperative-statement-2]
      * END-STRING

           DISPLAY "WS-STRING-B: " WS-STRING-B
           DISPLAY "WS-STRING-C: " WS-STRING-C

           STRING WS-STRING-B WS-STRING-C INTO WS-STRING-D
           DISPLAY X"0A" & "Concatenate strings NOT DELIMITED"
               " more than one spaces in between."
               X"0A" & "Concatenated string: " WS-STRING-D
          
           MOVE SPACES TO WS-STRING-D
           STRING WS-STRING-B WS-STRING-C DELIMITED BY SPACE
               INTO WS-STRING-D
           END-STRING
           DISPLAY X"0A" & "Concatenate strings DELIMITED BY SPACE"
               X"0A" & "Concatenated string: " WS-STRING-D

           MOVE SPACES TO WS-STRING-D
           STRING WS-STRING-B " " WS-STRING-C DELIMITED BY "  "
               INTO WS-STRING-D
           END-STRING
           DISPLAY X"0A" & "Concatenate strings DELIMITED BY 2 spaces."
               " Then adding a space in between both strings."
               X"0A" & "Concatenated string: " WS-STRING-D
           
           MOVE SPACES TO WS-STRING-D
           STRING "This is the beginning " "of the main phase."  
               INTO WS-STRING-D
           END-STRING
           DISPLAY X"0A" & "Concatenating string literals" 
               & X"0A" "Concatenated string: " WS-STRING-D
           .

       USE-UNSTRING. 
           DISPLAY X"0A" & "String TO PARSE: " WS-STRING-E
           DISPLAY "Parsing DELIMITED BY SPACE"
           UNSTRING WS-STRING-E DELIMITED BY SPACE
               INTO WS-STRING-F, WS-STRING-G
           END-UNSTRING    
           DISPLAY "SPLITTED STRING: " WS-STRING-F
           DISPLAY "SPLITTED STRING: " WS-STRING-G
           
           MOVE "NAME:EDUARDO/PHONE:05555555555" TO WS-STRING-E
           DISPLAY X"0A" & "String TO PARSE: " WS-STRING-E
           DISPLAY "Parsing DELIMITED BY SPACE"
           UNSTRING WS-STRING-E DELIMITED BY "/"
               INTO WS-STRING-F, WS-STRING-G
           END-UNSTRING
           UNSTRING WS-STRING-F DELIMITED BY ":"
               INTO TEMP-STRING-1, WS-STRING-F
           END-UNSTRING
           UNSTRING WS-STRING-G DELIMITED BY ":"
               INTO TEMP-STRING-1, WS-STRING-G
           END-UNSTRING    
           DISPLAY "Parsed Name: " WS-STRING-F
           DISPLAY "Parsed Phone: " WS-STRING-G
           .

       END PROGRAM STRINGS-HAND.

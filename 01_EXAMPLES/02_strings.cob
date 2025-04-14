       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRINGS-HAND.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *INSPECT:    Search in the string
      *STRING:     Concatenate strings
      *UNSTRING:   Split a string

      *If a string contains spaces has to be saved in ALPHANUMERIC
       01 WS-STRING-A PIC X(60) 
           VALUE "This is a string like no other string in the world".
       01 WS-COUNT PIC 9(2).
       01 WS-COUNT-2 PIC 9(2).
       01 WS-COUNT-3 PIC 9(2).

       01 WS-STRING-B PIC X(20)
           VALUE "This way it begins.".
       01 WS-STRING-C PIC X(20)
           VALUE "This way it ends.".
       01 WS-STRING-D PIC X(40).

       01 WS-STRING-E PIC X(40)
           VALUE "FirstWord SecondWord ThirdWord".
       01 WS-STRING-F PIC X(20).
       01 WS-STRING-G PIC X(20).



       PROCEDURE DIVISION.
       DISPLAY "STRING:" WS-STRING-A.

      *FIND SUBSTRINGS 
       INSPECT WS-STRING-A TALLYING WS-COUNT FOR ALL 'i'.
       DISPLAY "CHARACTER i COUNT: " WS-COUNT.

       INSPECT WS-STRING-A TALLYING WS-COUNT-2 FOR ALL 'string'.
       DISPLAY "CHARACTER i COUNT: " WS-COUNT-2.

       INSPECT WS-STRING-A TALLYING WS-COUNT-3 FOR ALL CHARACTERS.
       DISPLAY "MAX STRING SIZE: " WS-COUNT-3.

      *REPLACE (the strings to replace must be the same size)
       INSPECT WS-STRING-A REPLACING ALL "world" BY "stars".
       DISPLAY "NEW STRING: " WS-STRING-A.

      *CONCATENATE STRINGS (There is much more options to this.)
       STRING WS-STRING-B WS-STRING-C INTO WS-STRING-D.
       DISPLAY "CONCATENATED STRING: " WS-STRING-D.

      *SPLIT STRINGS (there are also more options) 
       UNSTRING WS-STRING-E DELIMITED BY SPACE
           INTO WS-STRING-F, WS-STRING-G
       END-UNSTRING.

       DISPLAY "SPLITTED STRING: " WS-STRING-F.
       DISPLAY "SPLITTED STRING: " WS-STRING-G.

     
       STOP RUN.
       END PROGRAM STRINGS-HAND.

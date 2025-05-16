       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       AUTHOR. Eduardo Feria.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GAME-START                PIC X VALUE "Y".
       01 WS-COMMAND                   PIC X VALUE " ".
       01 WS-SCREEN-ROW-INDEX          PIC 99 VALUE 0.
       78 WS-SCREEN-WIDTH VALUE 40.
       78 WS-SCREEN-HEIGHT VALUE 10.  
       78 WS-SCREEN-FILLER VALUE ".". 

       01 WS-SCREEN.
           05 WS-SCREEN-ROW            PIC X(WS-SCREEN-WIDTH) 
               VALUE ALL WS-SCREEN-FILLER 
               OCCURS WS-SCREEN-HEIGHT TIMES.
       
       01 WS-CHARACTER-SHIFT-X    PIC 9 VALUE 2.
       01 WS-CHARACTER-SHIFT-Y    PIC 9 VALUE 1.
       01 WS-CHARACTER.           
           05 WS-CHARACTER-X           PIC 99 VALUE 3.
           05 WS-CHARACTER-Y           PIC 99 VALUE 4. 
           05 WS-CHARACTER-NEW-X       PIC 99  VALUE 3. 
           05 WS-CHARACTER-NEW-Y       PIC 99  VALUE 4. 
           05 WS-CHARACTER-IMG.
               10 WS-CHARACTER-ROW-1   PIC X(3) VALUE ".O.".
               10 WS-CHARACTER-ROW-2   PIC X(3) VALUE "/|\".
               10 WS-CHARACTER-ROW-3   PIC X(3) VALUE "/.\".                   

       PROCEDURE DIVISION.

       PERFORM MAIN-PROCEDURE
       STOP RUN.
       
       MAIN-PROCEDURE.
           PERFORM DISPLAY-SCREEN
           MOVE "N" TO WS-GAME-START           

           PERFORM UNTIL WS-COMMAND = "X"
               ACCEPT WS-COMMAND
               IF WS-COMMAND = "W" OR WS-COMMAND = "D" 
                   OR WS-COMMAND = "S" OR WS-COMMAND = "A"
                   PERFORM MOVE-CHARACTER
                   PERFORM DISPLAY-SCREEN
               END-IF
               
           END-PERFORM
           .

       MOVE-CHARACTER.
       
           EVALUATE WS-COMMAND
               WHEN "A"
                   COMPUTE WS-CHARACTER-NEW-X = 
                       WS-CHARACTER-X - WS-CHARACTER-SHIFT-X
               WHEN "D"
                   COMPUTE WS-CHARACTER-NEW-X = 
                       WS-CHARACTER-X + WS-CHARACTER-SHIFT-X
               WHEN "W"
                   COMPUTE WS-CHARACTER-NEW-Y = 
                       WS-CHARACTER-Y - WS-CHARACTER-SHIFT-Y
               WHEN "S"
                   COMPUTE WS-CHARACTER-NEW-Y = 
                       WS-CHARACTER-Y + WS-CHARACTER-SHIFT-Y
           END-EVALUATE
      *    Check if the character will be out of bound
           IF WS-CHARACTER-NEW-X < 3 
               OR WS-CHARACTER-NEW-X > WS-SCREEN-WIDTH - 2
               MOVE WS-CHARACTER-X TO WS-CHARACTER-NEW-X
           end-if
           IF WS-CHARACTER-NEW-Y < 4 
               OR WS-CHARACTER-NEW-Y > WS-SCREEN-HEIGHT - 1
               MOVE WS-CHARACTER-Y TO WS-CHARACTER-NEW-Y
           end-if
           .


       DISPLAY-SCREEN.
           PERFORM DISPLAY-CHARACTER.

           PERFORM VARYING WS-SCREEN-ROW-INDEX FROM 1 BY 1 
                   UNTIL WS-SCREEN-ROW-INDEX > WS-SCREEN-HEIGHT 
               DISPLAY WS-SCREEN-ROW(WS-SCREEN-ROW-INDEX)
           END-PERFORM
           .
       
       DISPLAY-CHARACTER.
      *    Redraw the character only if the character has moved
           IF WS-GAME-START = "Y"
               OR (NOT WS-CHARACTER-NEW-X = WS-CHARACTER-X) 
               OR (NOT WS-CHARACTER-NEW-Y = WS-CHARACTER-Y) 
               
      *     Erase the character from the screen    
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y)
                       (WS-CHARACTER-X - 1:3)
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 1)
                       (WS-CHARACTER-X - 1:3)
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 2)
                       (WS-CHARACTER-X - 1:3)

      *    Update the character's location
           MOVE WS-CHARACTER-NEW-X TO WS-CHARACTER-X
           MOVE WS-CHARACTER-NEW-Y TO WS-CHARACTER-Y

      *     Draw the character 
               MOVE WS-CHARACTER-ROW-3 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y)
                       (WS-CHARACTER-X - 1:3)
               MOVE WS-CHARACTER-ROW-2 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 1)
                       (WS-CHARACTER-X - 1:3)
               MOVE WS-CHARACTER-ROW-1 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 2)
                       (WS-CHARACTER-X - 1:3)
           END-IF
           .

       END PROGRAM GAME.
       
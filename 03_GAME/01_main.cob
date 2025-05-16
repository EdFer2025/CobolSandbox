       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       AUTHOR. Eduardo Feria.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GAME-START                PIC X VALUE "Y".
       01 WS-GAME-FRAMES               PIC 9(8) VALUE 0.
       01 WS-GAME-POINTS               PIC 9(8) VALUE 0.

      * MOVE WITH WASD OR wasd 
       01 WS-COMMAND                   PIC 9 VALUE 0 USAGE COMP-5.
           88 MOVE-LEFT                VALUE 65, 97.
           88 MOVE-RIGHT               VALUE 68, 100.
           88 MOVE-UP                  VALUE 87, 119.
           88 MOVE-DOWN                VALUE 83, 115.
           88 EXIT-COMMAND             VALUE 88, 120.
       01 WS-SCREEN-ROW-INDEX          PIC 99 VALUE 0.
       78 WS-SCREEN-WIDTH VALUE 40.
       78 WS-SCREEN-HEIGHT VALUE 10.  
       78 WS-SCREEN-FILLER VALUE ".". 
       78 WS-FOOD-COUNT VALUE 10.

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

       01 WS-FOOD.
           05 WS-FOOD-IMG              PIC X VALUE "O".
           05 WS-FOOD-Y            PIC 99 OCCURS WS-FOOD-COUNT TIMES.                 
           05 WS-FOOD-X            PIC 99 OCCURS WS-FOOD-COUNT TIMES.                 

       PROCEDURE DIVISION.

       PERFORM MAIN-PROCEDURE
       STOP RUN.
       
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-FOOD

           PERFORM DISPLAY-SCREEN
           MOVE "N" TO WS-GAME-START           

           PERFORM UNTIL EXIT-COMMAND               
      *        ACCEPT is blocking therefore use C
               PERFORM GET_CHAR
               
               PERFORM MOVE-CHARACTER                
                                 
               PERFORM DISPLAY-SCREEN
      *        Wait some time to set the frame frequency to 10 fps         
               CALL "usleep" USING BY VALUE 100000
      *         CALL "sleep" USING BY VALUE 1
           END-PERFORM
           .

       INITIALIZE-FOOD.
           CONTINUE
           .

       MOVE-CHARACTER.
       
           EVALUATE TRUE
      *        When "A" is pressed
               WHEN MOVE-LEFT
                   COMPUTE WS-CHARACTER-NEW-X = 
                       WS-CHARACTER-X - WS-CHARACTER-SHIFT-X
      *        When "D" is pressed
               WHEN MOVE-RIGHT
                   COMPUTE WS-CHARACTER-NEW-X = 
                       WS-CHARACTER-X + WS-CHARACTER-SHIFT-X
      *        When "W" is pressed
               WHEN MOVE-UP
                   COMPUTE WS-CHARACTER-NEW-Y = 
                       WS-CHARACTER-Y - WS-CHARACTER-SHIFT-Y
      *        When "S" is pressed
               WHEN MOVE-DOWN
                   COMPUTE WS-CHARACTER-NEW-Y = 
                       WS-CHARACTER-Y + WS-CHARACTER-SHIFT-Y
           END-EVALUATE
      *    Check if the character will be out of bound
           IF WS-CHARACTER-NEW-X < 3 
               OR WS-CHARACTER-NEW-X > WS-SCREEN-WIDTH - 2
               MOVE WS-CHARACTER-X TO WS-CHARACTER-NEW-X
           END-IF
           IF WS-CHARACTER-NEW-Y < 4 
               OR WS-CHARACTER-NEW-Y > WS-SCREEN-HEIGHT - 1
               MOVE WS-CHARACTER-Y TO WS-CHARACTER-NEW-Y
           END-IF
           .

       DISPLAY-SCREEN.
           PERFORM CLEAR-SCREEN
           ADD 1 TO WS-GAME-FRAMES
           DISPLAY "COMMAND: " WS-COMMAND
           MOVE "FRAME: " TO WS-SCREEN-ROW(1)(2:7)
           MOVE WS-GAME-FRAMES TO WS-SCREEN-ROW(1)(9:8)
           MOVE "POINTS: " TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 16:8)
           MOVE WS-GAME-POINTS 
               TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 8:8)
           
           PERFORM DRAW-CHARACTER

           PERFORM VARYING WS-SCREEN-ROW-INDEX FROM 1 BY 1 
                   UNTIL WS-SCREEN-ROW-INDEX > WS-SCREEN-HEIGHT 
               DISPLAY WS-SCREEN-ROW(WS-SCREEN-ROW-INDEX)
           END-PERFORM
           .
       
       DRAW-CHARACTER.
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
       GET_CHAR.
      * Gets a char from the terminal with out blocking the execution
      * Uses an external C library
           CALL "getchar_nonblock" RETURNING WS-COMMAND
           .

       CLEAR-SCREEN.
           CALL "SYSTEM" USING "clear"
           .

       END PROGRAM GAME.
       
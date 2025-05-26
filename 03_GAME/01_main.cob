       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       AUTHOR. Eduardo Feria.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GAME-START                PIC X VALUE "Y".
       01 WS-GAME-FRAMES               PIC 9(8) VALUE 0.
       01 WS-GAME-POINTS               PIC 9(8) VALUE 0.
       01 WS-OBJECTS-MOVE-ZIG-ZAG      PIC X VALUE "Y".

      * move with "WASD" OR "wasd" 
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
       78 WS-OBJECT-COUNT VALUE 5.
       78 WS-BOMB-COUNT VALUE 1.

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

       01 WS-RANDOM-X                  PIC 99   VALUE 0.
       01 WS-RANDOM-Y                  PIC 99   VALUE 0.
       01 WS-OBJECT-INDEX                PIC 99   VALUE 0.
       01 WS-OBJECT.
           05 WS-OBJECT-IMG         PIC X OCCURS WS-OBJECT-COUNT TIMES 
                                           VALUE "O".                 
           05 WS-OBJECT-X           PIC 99 OCCURS WS-OBJECT-COUNT TIMES. 
           05 WS-OBJECT-Y           PIC 99 OCCURS WS-OBJECT-COUNT TIMES. 
           05 WS-OBJECT-DX          PIC S9 OCCURS WS-OBJECT-COUNT TIMES
                                       VALUE -2. 
           05 WS-OBJECT-DY           PIC S9 OCCURS WS-OBJECT-COUNT TIMES
                                       VALUE 0. 

       PROCEDURE DIVISION.

       PERFORM MAIN-PROCEDURE
       STOP RUN.
       
       MAIN-PROCEDURE.
             
           PERFORM INITIALIZE-OBJECT
           
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

       INITIALIZE-OBJECT.
           PERFORM VARYING WS-OBJECT-INDEX FROM 1 BY 1 
                   UNTIL WS-OBJECT-INDEX > WS-OBJECT-COUNT
               PERFORM SET-OBJECT-POSITION

      *        Set the bombs character
               IF WS-OBJECT-INDEX <= WS-BOMB-COUNT
                   MOVE '*' TO WS-OBJECT-IMG(WS-OBJECT-INDEX)
               END-IF

      *        Initialize WS-OBJECT-DY if MOVE-ZIG-ZAG is active
               IF WS-OBJECTS-MOVE-ZIG-ZAG = "Y"
                   COMPUTE WS-OBJECT-DY(WS-OBJECT-INDEX)
                       = FUNCTION MOD (WS-OBJECT-INDEX, 2)
                   EVALUATE WS-OBJECT-DY(WS-OBJECT-INDEX)
                       WHEN 0
                           MOVE 1 TO WS-OBJECT-DY(WS-OBJECT-INDEX)
                       WHEN 1
                           MOVE -1 TO WS-OBJECT-DY(WS-OBJECT-INDEX)
                   END-EVALUATE
               END-IF
           END-PERFORM
           .
       
       SET-OBJECT-POSITION.
           PERFORM GET-RANDOM-POINT
           MOVE WS-RANDOM-X TO WS-OBJECT-X(WS-OBJECT-INDEX)
           MOVE WS-RANDOM-Y TO WS-OBJECT-Y(WS-OBJECT-INDEX)
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
               OR WS-CHARACTER-NEW-Y > WS-SCREEN-HEIGHT
               MOVE WS-CHARACTER-Y TO WS-CHARACTER-NEW-Y
           END-IF
           .

       DISPLAY-SCREEN.
           PERFORM CLEAR-SCREEN
           ADD 1 TO WS-GAME-FRAMES
           DISPLAY "COMMAND: " WS-COMMAND
           PERFORM VARYING WS-OBJECT-INDEX FROM 1 BY 1 
                   UNTIL WS-OBJECT-INDEX = WS-OBJECT-COUNT + 1
               DISPLAY "(X, Y): (" WS-OBJECT-X(WS-OBJECT-INDEX)
                   ", " WS-OBJECT-Y(WS-OBJECT-INDEX) ")"
                   " DX: " WS-OBJECT-DX(WS-OBJECT-INDEX)
                   " DY: " WS-OBJECT-DY(WS-OBJECT-INDEX)
           END-PERFORM
           
           MOVE "FRAME: " TO WS-SCREEN-ROW(1)(2:7)
           MOVE WS-GAME-FRAMES TO WS-SCREEN-ROW(1)(9:8)
           MOVE "POINTS: " TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 16:8)
           MOVE WS-GAME-POINTS 
               TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 8:8)
           
           PERFORM DRAW-CHARACTER
           PERFORM DRAW-OBJECT

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
               
      *        Erase the character from the screen    
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y)
                       (WS-CHARACTER-X - 1:3)
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 1)
                       (WS-CHARACTER-X - 1:3)
               MOVE "..." 
                   TO WS-SCREEN-ROW(WS-CHARACTER-Y - 2)
                       (WS-CHARACTER-X - 1:3)

      *        Update the character's location
               MOVE WS-CHARACTER-NEW-X TO WS-CHARACTER-X
               MOVE WS-CHARACTER-NEW-Y TO WS-CHARACTER-Y

      *        Draw the character 
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
           PERFORM CHECK-OBJECT-COLLISIONS
           .
       
       CHECK-OBJECT-COLLISIONS.
      *    Check for character and OBJECT collisions
           PERFORM VARYING WS-OBJECT-INDEX FROM 1 BY 1 
                       UNTIL WS-OBJECT-INDEX > WS-OBJECT-COUNT 
               PERFORM CHECK-OBJECT-COLLISION
           END-PERFORM
           .

       CHECK-OBJECT-COLLISION.
           IF WS-OBJECT-X(WS-OBJECT-INDEX) <= WS-CHARACTER-X + 1
               AND WS-OBJECT-X(WS-OBJECT-INDEX) >= WS-CHARACTER-X - 1
               AND WS-OBJECT-Y(WS-OBJECT-INDEX) <= WS-CHARACTER-Y
               AND WS-OBJECT-Y(WS-OBJECT-INDEX) >= WS-CHARACTER-Y - 2
  
               EVALUATE WS-OBJECT-IMG(WS-OBJECT-INDEX)
      *            If FOOD Earn 1 point and respawn OBJECT
                   WHEN 'O'
                       ADD 1 TO WS-GAME-POINTS
                       PERFORM SET-OBJECT-POSITION
      *            If BOMB -> Game Over
                   WHEN "*"
                       MOVE "*************** GAME OVER ***************" 
                           TO WS-SCREEN-ROW(6)
                       SET EXIT-COMMAND TO TRUE 
               END-EVALUATE
           END-IF
           .           

       DRAW-OBJECT.      
           PERFORM VARYING WS-OBJECT-INDEX FROM 1 BY 1 
                       UNTIL WS-OBJECT-INDEX > WS-OBJECT-COUNT  
      *        Delete the OBJECT draw if it is on the screen 
               IF WS-OBJECT-X(WS-OBJECT-INDEX) < WS-SCREEN-WIDTH
                       AND WS-OBJECT-X(WS-OBJECT-INDEX) > 0
                   MOVE WS-SCREEN-FILLER 
                       TO WS-SCREEN-ROW(WS-OBJECT-Y(WS-OBJECT-INDEX))
                           (WS-OBJECT-X(WS-OBJECT-INDEX):1)
               END-IF
                             
      *        If the OBJECT has reached the left border of the screen
      *        Assign a new position for the OBJECT (respawn)
               IF WS-OBJECT-X(WS-OBJECT-INDEX) + 
                       WS-OBJECT-DX(WS-OBJECT-INDEX) < 1
                   PERFORM SET-OBJECT-POSITION
               ELSE
      *            Decrease the X position of all the OBJECT
      *            to make it closer to the character 
                   ADD WS-OBJECT-DX(WS-OBJECT-INDEX) 
                       TO WS-OBJECT-X(WS-OBJECT-INDEX)
      *            If WS-OBJECT-DY is not zero then the character moves
      *            vertically as well
                   IF WS-OBJECT-DY(WS-OBJECT-INDEX) IS NOT ZERO
                       ADD WS-OBJECT-DY(WS-OBJECT-INDEX)
                           TO WS-OBJECT-y(WS-OBJECT-INDEX)
      *                If the object is out of the screen the Y position 
      *                is reset to the border
                       IF WS-OBJECT-Y(WS-OBJECT-INDEX) <= 1 
                           MOVE 1 TO WS-OBJECT-Y(WS-OBJECT-INDEX)
                           MULTIPLY -1 BY WS-OBJECT-DY(WS-OBJECT-INDEX)
                       END-IF
                       IF WS-OBJECT-Y(WS-OBJECT-INDEX) 
                               >= WS-SCREEN-HEIGHT - 1
                           COMPUTE WS-OBJECT-Y(WS-OBJECT-INDEX) 
                               = WS-SCREEN-HEIGHT - 1                            
                           MULTIPLY -1 BY WS-OBJECT-DY(WS-OBJECT-INDEX)
                       END-IF
                   END-IF
               END-IF

               PERFORM CHECK-OBJECT-COLLISION
               
      *        Draw the OBJECT image
               IF WS-OBJECT-X(WS-OBJECT-INDEX) < WS-SCREEN-WIDTH
                   AND NOT WS-OBJECT-X(WS-OBJECT-INDEX) = 1
                   MOVE WS-OBJECT-IMG(WS-OBJECT-INDEX) 
                       TO WS-SCREEN-ROW(WS-OBJECT-Y(WS-OBJECT-INDEX))
                           (WS-OBJECT-X(WS-OBJECT-INDEX):1)
               END-IF      
           END-PERFORM
           .

       GET_CHAR.
      * Gets a char from the terminal with out blocking the execution
      * Uses an external C library
           CALL "getchar_nonblock" RETURNING WS-COMMAND
           .

       GET-RANDOM-POINT.
           CALL "random_range2" 
               USING WS-SCREEN-WIDTH
               RETURNING WS-RANDOM-X
           CALL "random_range" 
               USING 2, WS-SCREEN-HEIGHT
               RETURNING WS-RANDOM-Y           
           .

       CLEAR-SCREEN.
           CALL "SYSTEM" USING "clear"
           .

       END PROGRAM GAME.
       
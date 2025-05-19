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
       78 WS-FOOD-COUNT VALUE 5.

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
       01 WS-FOOD-INDEX                PIC 99   VALUE 0.
       01 WS-FOOD.
           05 WS-FOOD-IMG              PIC X VALUE "O".                 
           05 WS-FOOD-X            PIC 99 OCCURS WS-FOOD-COUNT TIMES. 
           05 WS-FOOD-Y            PIC 99 OCCURS WS-FOOD-COUNT TIMES. 
           05 WS-FOOD-DX           PIC S9 OCCURS WS-FOOD-COUNT TIMES
                                       VALUE -2. 
           05 WS-FOOD-DY           PIC S9 OCCURS WS-FOOD-COUNT TIMES
                                       VALUE 0. 

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
           PERFORM VARYING WS-FOOD-INDEX FROM 1 BY 1 
                   UNTIL WS-FOOD-INDEX > WS-FOOD-COUNT
               PERFORM SET-FOOD-POSITION

      *        Initialize WS-FOOD-DY if MOVE-ZIG-ZAG is active
               IF WS-OBJECTS-MOVE-ZIG-ZAG = "Y"
                   COMPUTE WS-FOOD-DY(WS-FOOD-INDEX)
                       = FUNCTION MOD (WS-FOOD-INDEX, 2)
                   EVALUATE WS-FOOD-DY(WS-FOOD-INDEX)
                       WHEN 0
                           MOVE 1 TO WS-FOOD-DY(WS-FOOD-INDEX)
                       WHEN 1
                           MOVE -1 TO WS-FOOD-DY(WS-FOOD-INDEX)
                   END-EVALUATE
               END-IF
           END-PERFORM
           .
       
       SET-FOOD-POSITION.
           PERFORM GET-RANDOM-POINT
           MOVE WS-RANDOM-X TO WS-FOOD-X(WS-FOOD-INDEX)
           MOVE WS-RANDOM-Y TO WS-FOOD-Y(WS-FOOD-INDEX)
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
           PERFORM VARYING WS-FOOD-INDEX FROM 1 BY 1 
                   UNTIL WS-FOOD-INDEX = WS-FOOD-COUNT + 1
               DISPLAY "(X, Y): (" WS-FOOD-X(WS-FOOD-INDEX)
                   ", " WS-FOOD-Y(WS-FOOD-INDEX) ")"
                   " DX: " WS-FOOD-DX(WS-FOOD-INDEX)
                   " DY: " WS-FOOD-DY(WS-FOOD-INDEX)
           END-PERFORM
           
           MOVE "FRAME: " TO WS-SCREEN-ROW(1)(2:7)
           MOVE WS-GAME-FRAMES TO WS-SCREEN-ROW(1)(9:8)
           MOVE "POINTS: " TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 16:8)
           MOVE WS-GAME-POINTS 
               TO WS-SCREEN-ROW(1)(WS-SCREEN-WIDTH - 8:8)
           
           PERFORM DRAW-CHARACTER
           PERFORM DRAW-FOOD

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
           perform CHECK-OBJECT-COLLISIONS
           .
       
       CHECK-OBJECT-COLLISIONS.
      *    Check for character and food collisions
           PERFORM VARYING WS-FOOD-INDEX FROM 1 BY 1 
                       UNTIL WS-FOOD-INDEX > WS-FOOD-COUNT 
               perform CHECK-OBJECT-COLLISION
           END-PERFORM
           .

       CHECK-OBJECT-COLLISION.
           IF WS-FOOD-X(WS-FOOD-INDEX) <= WS-CHARACTER-X + 1
               AND WS-FOOD-X(WS-FOOD-INDEX) >= WS-CHARACTER-X - 1
               AND WS-FOOD-Y(WS-FOOD-INDEX) <= WS-CHARACTER-Y
               AND WS-FOOD-Y(WS-FOOD-INDEX) >= WS-CHARACTER-Y - 2
      *       Earn 1 point and repawn food 
              ADD 1 TO WS-GAME-POINTS
              PERFORM SET-FOOD-POSITION
           END-IF
           .           

       DRAW-FOOD.      
           PERFORM VARYING WS-FOOD-INDEX FROM 1 BY 1 
                       UNTIL WS-FOOD-INDEX > WS-FOOD-COUNT  
      *        Delete the food draw if it is on the screen 
               IF WS-FOOD-X(WS-FOOD-INDEX) < WS-SCREEN-WIDTH
                       and WS-FOOD-X(WS-FOOD-INDEX) > 0
                   MOVE WS-SCREEN-FILLER 
                       TO WS-SCREEN-ROW(WS-FOOD-Y(WS-FOOD-INDEX))
                           (WS-FOOD-X(WS-FOOD-INDEX):1)
               END-IF
                             
      *        If the food has reached the left border of the screen
      *        Assign a new position for the food (respawn)
               IF WS-FOOD-X(WS-FOOD-INDEX) + 
                       WS-FOOD-DX(WS-FOOD-INDEX) < 1
                   PERFORM SET-FOOD-POSITION
               else
      *            Decrease the X position of all the food
      *            to make it closer to the character 
                   ADD WS-FOOD-DX(WS-FOOD-INDEX) 
                       TO WS-FOOD-X(WS-FOOD-INDEX)
      *            If WS-FOOD-DY is not zero then the character moves
      *            vertically as well
                   IF WS-FOOD-DY(WS-FOOD-INDEX) IS NOT ZERO
                       ADD WS-FOOD-DY(WS-FOOD-INDEX)
                           TO WS-FOOD-y(WS-FOOD-INDEX)
      *                If the object is out of the screen the Y position 
      *                is reset to the border
                       IF WS-FOOD-Y(WS-FOOD-INDEX) <= 1 
                           MOVE 1 TO WS-FOOD-Y(WS-FOOD-INDEX)
                           MULTIPLY -1 BY WS-FOOD-DY(WS-FOOD-INDEX)
                       END-IF
                       IF WS-FOOD-Y(WS-FOOD-INDEX) 
                               >= WS-SCREEN-HEIGHT - 1
                           COMPUTE WS-FOOD-Y(WS-FOOD-INDEX) 
                               = WS-SCREEN-HEIGHT - 1                            
                           MULTIPLY -1 BY WS-FOOD-DY(WS-FOOD-INDEX)
                       END-IF
                   END-IF
               END-IF

               perform CHECK-OBJECT-COLLISION
               
      *        Draw the food image
               IF WS-FOOD-X(WS-FOOD-INDEX) < WS-SCREEN-WIDTH
                   AND NOT WS-FOOD-X(WS-FOOD-INDEX) = 1
                   MOVE WS-FOOD-IMG 
                       TO WS-SCREEN-ROW(WS-FOOD-Y(WS-FOOD-INDEX))
                           (WS-FOOD-X(WS-FOOD-INDEX):1)
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
       
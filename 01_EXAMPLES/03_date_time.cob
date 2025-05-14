       IDENTIFICATION DIVISION. 
       PROGRAM-ID. HELLO_WORLD_DATE.
       AUTHOR.     EDUARDO FERIA.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *DATA STRUCTURE FOR FUNCTION CURRENT-DATE
       01 WS-CURRENT-DATE-TIME.
           05 WS-CURRENT-DATE.
               10 WS-YEAR      PIC 9(4).
               10 WS-MONTH     PIC 9(2).
               10 WS-DAY       PIC 9(2).
           05 WS-CURRENT-TIME.
               10 WS-HOUR      PIC 9(2).
               10 WS-MINUTE    PIC 9(2).
               10 WS-SECOND    PIC 9(2).
               10 WS-MS        PIC 9(2).

       01 WS-DATE-1            PIC 9(8).
       01 WS-DATE-2            PIC 9(8).
       01 WS-DAYS-GAP          PIC 9(3) VALUE 30.
       01 TEMP-INTEGER-OF-DATE PIC 9(9).
       
           
       

       PROCEDURE DIVISION.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-TIME

           PERFORM DISPLAY-CURRENT-DATE
           PERFORM DISPLAY-CURRENT-TIME
           PERFORM DISPLAY-CURRENT-DATETIME

      * GET A DATE IN THE FUTURE
           PERFORM DISPLAY-CURRENT-DATE
           MOVE WS-CURRENT-DATE-TIME TO WS-DATE-1
           
      * INTEGER-OF-DATE: RESULTS IN AN INTEGER [1-3,067,671]           
           COMPUTE TEMP-INTEGER-OF-DATE =  
               FUNCTION INTEGER-OF-DATE(WS-DATE-1) + WS-DAYS-GAP
           COMPUTE WS-DATE-2 =  
               FUNCTION DATE-OF-INTEGER(TEMP-INTEGER-OF-DATE) 
           MOVE WS-DATE-2 TO WS-CURRENT-DATE
           
           DISPLAY "Date " WS-DAYS-GAP " days in the future:"
           PERFORM DISPLAY-CURRENT-DATE
      *    COMPUTE THE DIFFERENCE BETWEEN TWO DATES
           COMPUTE WS-DAYS-GAP = FUNCTION INTEGER-OF-DATE(WS-DATE-1)
               - FUNCTION INTEGER-OF-DATE(WS-DATE-2)
           DISPLAY "The difference between date " WS-DATE-1 " and "
               WS-DATE-2 " is of " WS-DAYS-GAP " days."
       STOP RUN.

       DISPLAY-CURRENT-DATE.           
           DISPLAY"Current date: " WS-DAY "/" WS-MONTH "/" WS-YEAR
           .

       DISPLAY-CURRENT-TIME.
           DISPLAY "Current time: " WS-HOUR ":" WS-MINUTE ":" WS-SECOND 
               "." WS-MS
           .

       DISPLAY-CURRENT-DATETIME.
           DISPLAY "Current datetime: " WS-DAY "/" WS-MONTH "/" WS-YEAR
           " " WS-HOUR ":" WS-MINUTE ":" WS-SECOND "." WS-MS
           .

           
       END PROGRAM HELLO_WORLD_DATE.
       
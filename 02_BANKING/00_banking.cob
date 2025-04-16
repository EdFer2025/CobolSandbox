       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKING.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-ACCOUNT-TABLE.
           05 ACCOUNT OCCURS 5 TIMES.
               10 ACCOUNT-NUMBER PIC 9(5).
               10 ACCOUNT-HOLDER-FN PIC A(20).
               10 ACCOUNT-HOLDER-LN PIC A(20).
               10 ACCOUNT-BALANCE PIC 9(5) VALUE 10000.

       01 TRANSACTION-TABLE.
           05 WS-TRANSACTION OCCURS 10000 TIMES.
               10 FROM-ACCOUNT PIC 9(5).
               10 TO-ACCOUNT PIC 9(5).
               10 TRANSACTION-AMOUNT PIC 9(5).
      *        TODO: STORE DATE AND TIME         
               10 TRANSACTION-DATE PIC 9(6).

      *USED TO ITERATE THE TABLE
       01 WS-ACCOUNT-INDEX PIC 9(1) VALUE 1.
      *ACCOUNT-CODE USED FOR SEARCH 
       01 WS-SEARCH-CODE PIC 9(5) VALUE 00000.
      *"N" IF THE CODE WAS NOT FOUND "Y" OTHERWISE
       01 WS-FOUND-CODE PIC X VALUE "N".
      *TRANSACTION INDEXES
       01 WS-TRANSACTION-INDEX PIC 9(4).
       01 WS-LAST-TRANSACTION-INDEX PIC 9(4) VALUE 0.

      *TRANSACTION VARIABLES
       01 WS-TRANSACTION-SENDER-NUMBER PIC 9(5).
       01 WS-TRANSACTION-SENDER-INDEX PIC 9(5).
       01 WS-TRANSACTION-RECEIVER-NUMBER PIC 9(5).
       01 WS-TRANSACTION-RECEIVER-INDEX PIC 9(5).
       01 WS-TRANSACTION-AMOUNT PIC 9(5). 

      * FOR THE OPTION MENU
       01 WS-OPTION PIC 9.


       PROCEDURE DIVISION.
       MOVE
           "00001John                Smith               10000" &
           "00002Alice               Johnson             10000" &
           "00003Carlos              Martinez            10000" &
           "00004Emma                Brown               10000" &
           "00005David               Mueller             10000"
           TO WS-ACCOUNT-TABLE.           

       PERFORM MAIN-PROCESS.
       STOP RUN.

       MAIN-PROCESS.
           
           PERFORM UNTIL WS-OPTION = 4
               DISPLAY " "
               DISPLAY "SELECT AN OPTION:"
               DISPLAY "   1. ACCOUNT INFORMATION"       
               DISPLAY "   2. TRANSACTION INFORMATION" 
               DISPLAY "   3. EXECUTE TRANSACTION"
               DISPLAY "   4. TERMINATE"
    
               ACCEPT WS-OPTION
               EVALUATE WS-OPTION
                   WHEN 1
                       DISPLAY "INPUT THE ACCOUNT NUMBER"
                       ACCEPT WS-SEARCH-CODE
                       PERFORM FIND-ACCOUNT-BY-CODE
                   WHEN 2
                       EVALUATE TRUE
                           WHEN WS-LAST-TRANSACTION-INDEX = 0
                               DISPLAY "THERE ARE NO TRANSACTIONS "
                               "RECORDED"
                           WHEN OTHER
                               DISPLAY "INPUT THE TRANSACTION INDEX"
                               ACCEPT WS-TRANSACTION-INDEX
                               EVALUATE TRUE
                                   WHEN WS-TRANSACTION-INDEX > 
                                   WS-LAST-TRANSACTION-INDEX
                                       DISPLAY "THE LAST TRANSACTION " &
                                       "IS THE "
                                       WS-LAST-TRANSACTION-INDEX 
                                   WHEN OTHER
                                       PERFORM TRANSACTION-DATA 
                               END-EVALUATE
                       END-EVALUATE                  
                   WHEN 3
                       PERFORM EXECUTE-TRANSACTION
                   WHEN 4
                       DISPLAY "BIS DANN!!!"
                       STOP RUN
                   WHEN OTHER 
                       DISPLAY "---INVALID OPTION---"
               END-EVALUATE
           END-PERFORM.

       EXECUTE-TRANSACTION.
           DISPLAY " ".
           DISPLAY "---INPUT THE TRANSACTION DATA---".
           
           DISPLAY " ".
           DISPLAY "SENDER ACCOUNT NUMBER:".
           ACCEPT WS-TRANSACTION-SENDER-NUMBER.
           MOVE WS-TRANSACTION-SENDER-NUMBER TO WS-SEARCH-CODE.
           PERFORM FIND-ACCOUNT-BY-CODE.
           EVALUATE WS-FOUND-CODE
               WHEN "Y"                   
                   MOVE WS-ACCOUNT-INDEX TO WS-TRANSACTION-SENDER-INDEX
               WHEN "N"
                   STOP RUN
               WHEN "OTHER"
                   DISPLAY "UNKNOWN VALUE FOR WS-FOUND-CODE"
           END-EVALUATE.


           DISPLAY " ".           
           DISPLAY "RECEIVER ACCOUNT NUMBER:".
           ACCEPT WS-TRANSACTION-RECEIVER-NUMBER.
           MOVE WS-TRANSACTION-RECEIVER-NUMBER TO WS-SEARCH-CODE.
           PERFORM FIND-ACCOUNT-BY-CODE.
           EVALUATE WS-FOUND-CODE
               WHEN "Y"                   
                   MOVE WS-ACCOUNT-INDEX 
                       TO WS-TRANSACTION-RECEIVER-INDEX
               WHEN "N"
                   STOP RUN
               WHEN "OTHER"
                   DISPLAY "UNKNOWN VALUE FOR WS-FOUND-CODE"
           END-EVALUATE.

           DISPLAY " ".
           DISPLAY "TRANSACTION AMOUNT:".
           ACCEPT WS-TRANSACTION-AMOUNT.
           EVALUATE TRUE
               WHEN WS-TRANSACTION-AMOUNT > 
               ACCOUNT-BALANCE (WS-TRANSACTION-SENDER-INDEX)
                   DISPLAY "THE TRANSACTION SENDER DOES NOT HAVE " &
                   "ENOUGH FUNDS TO PERFORM THE TRANSACTION."
               WHEN OTHER
      *            PERFORM THE TRANSACTION
      *            MOVE BALANCE IN THE ACCOUNTS 
                   SUBTRACT WS-TRANSACTION-AMOUNT FROM 
                       ACCOUNT-BALANCE(WS-TRANSACTION-SENDER-INDEX)
                   ADD WS-TRANSACTION-AMOUNT TO
                       ACCOUNT-BALANCE(WS-TRANSACTION-RECEIVER-INDEX)
      
      *            CREATE A TRANSACTION RECORD
                   ADD 1 TO WS-LAST-TRANSACTION-INDEX
                   MOVE WS-TRANSACTION-SENDER-NUMBER 
                       TO FROM-ACCOUNT(WS-LAST-TRANSACTION-INDEX)
                   MOVE WS-TRANSACTION-RECEIVER-NUMBER
                       TO TO-ACCOUNT(WS-LAST-TRANSACTION-INDEX)
                   MOVE WS-TRANSACTION-AMOUNT
                       TO TRANSACTION-AMOUNT(WS-LAST-TRANSACTION-INDEX)
                   ACCEPT TRANSACTION-DATE(WS-LAST-TRANSACTION-INDEX) 
                       FROM DATE
      
      *            DISPLAY THE TRANSACTION DATA
                   MOVE WS-LAST-TRANSACTION-INDEX 
                       TO WS-TRANSACTION-INDEX
                   PERFORM TRANSACTION-DATA
      
      *            DISPLAY THE UPDATED ACCOUNTS DATA
                   MOVE WS-TRANSACTION-SENDER-INDEX 
                       TO WS-ACCOUNT-INDEX
                   PERFORM ACCOUNT-SUMMARY
                   MOVE WS-TRANSACTION-RECEIVER-INDEX 
                       TO WS-ACCOUNT-INDEX
                   PERFORM ACCOUNT-SUMMARY
                         
           END-EVALUATE.

       
       FIND-ACCOUNT-BY-CODE.
      *FINDS AN ACCOUNT GIVEN AN ACCOUNT-NUMBER STORED IN WS-SEARCH-CODE
      *THE ACCOUNT TABLE INDEX REMAINS IN WS-ACCOUNT-INDEX 
           MOVE "N" TO WS-FOUND-CODE.

           PERFORM VARYING WS-ACCOUNT-INDEX FROM 1 BY 1 
               UNTIL WS-ACCOUNT-INDEX > 5 OR WS-FOUND-CODE = "Y"
               
               IF ACCOUNT-NUMBER (WS-ACCOUNT-INDEX) = WS-SEARCH-CODE
                   PERFORM ACCOUNT-SUMMARY
                   MOVE  "Y" TO WS-FOUND-CODE
               END-IF
           END-PERFORM.
           SUBTRACT 1 FROM WS-ACCOUNT-INDEX.

           IF WS-FOUND-CODE = "N"
               DISPLAY "!!!! THE ACCOUNT " WS-SEARCH-CODE
               " WAS NOT FOUND !!!!"
           END-IF.
       
       
       
       ACCOUNT-SUMMARY.           
           DISPLAY " "
           DISPLAY "---ACCOUNT SUMMARY---".
           DISPLAY "ACCOUNT NUMBER: " ACCOUNT-NUMBER
               (WS-ACCOUNT-INDEX).
      *    TODO: TRIM THE LEADING SPACES
           DISPLAY "ACCOUNT HOLDER: " 
           ACCOUNT-HOLDER-LN (WS-ACCOUNT-INDEX) ", "
           ACCOUNT-HOLDER-FN (WS-ACCOUNT-INDEX) ", ".
           DISPLAY "ACCOUNT BALANCE: " ACCOUNT-BALANCE
               (WS-ACCOUNT-INDEX).

       TRANSACTION-DATA.
           DISPLAY " ".
           DISPLAY "---TRANSACTION WITH INDEX " WS-TRANSACTION-INDEX
               "---".
           DISPLAY "FROM " FROM-ACCOUNT(WS-TRANSACTION-INDEX)
               " TO " TO-ACCOUNT(WS-TRANSACTION-INDEX).
           DISPLAY "AMOUNT: $" TRANSACTION-AMOUNT(WS-TRANSACTION-INDEX).
           DISPLAY "DATE: " TRANSACTION-DATE(WS-TRANSACTION-INDEX).

       END PROGRAM BANKING.
       

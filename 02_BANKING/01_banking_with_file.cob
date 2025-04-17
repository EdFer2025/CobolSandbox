       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKING.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "02_BANKING/banking.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACCOUNT-NUMBER
               FILE STATUS IS WS-STATUS.

           SELECT TRANSACTION-FILE
               ASSIGN TO "02_BANKING/transaction.dat"
               ORGANIZATION IS SEQUENTIAL.


       DATA DIVISION.
       FILE SECTION.
      *FILE DESCRIPTION AND RECORD LAYOUT
       FD ACCOUNT-FILE. 
       01 ACCOUNT-RECORD.
           05 ACCOUNT-NUMBER PIC 9(5).
           05 ACCOUNT-HOLDER-FN PIC A(20).
           05 ACCOUNT-HOLDER-LN PIC A(20).
           05 ACCOUNT-BALANCE PIC 9(5) VALUE 10000.

       FD TRANSACTION-FILE.
       01 TRANSACTION-RECORD.
           05 FROM-ACCOUNT PIC 9(5).
           05 TO-ACCOUNT PIC 9(5).
           05 TRANSACTION-AMOUNT PIC 9(5).  
           05 TRANSACTION-DATE PIC 9(6).
           05 TRANSACTION-TIME PIC 9(6).
       
       WORKING-STORAGE SECTION.
       01 WS-STATUS PIC XX.
       01 WS-TRANSACTION-FILE-EOF PIC X VALUE "N".

       01 SENDER-ACCOUNT.
           05 SENDER-ACCOUNT-NUMBER PIC 9(5).
           05 SENDER-ACCOUNT-BALANCE PIC 9(5) VALUE 10000.

       01 RECEIVER-ACCOUNT.
           05 RECEIVER-ACCOUNT-NUMBER PIC 9(5).
           05 RECEIVER-ACCOUNT-BALANCE PIC 9(5) VALUE 10000.

       

      *USED TO ITERATE THE TABLE
      * 01 WS-ACCOUNT-INDEX PIC 9(1) VALUE 1.
      *ACCOUNT-CODE USED FOR SEARCH 
       01 WS-SEARCH-CODE PIC 9(5) VALUE 00000.
      *"N" IF THE CODE WAS NOT FOUND "Y" OTHERWISE
       01 WS-FOUND-CODE PIC X VALUE "N".      

      *TRANSACTION VARIABLES
       01 WS-TRANSACTION-SENDER-NUMBER PIC 9(5).
      * 01 WS-TRANSACTION-SENDER-INDEX PIC 9(5).
       01 WS-TRANSACTION-RECEIVER-NUMBER PIC 9(5).
      * 01 WS-TRANSACTION-RECEIVER-INDEX PIC 9(5).
       01 WS-TRANSACTION-AMOUNT PIC 9(5). 

      *TRANSACTION INDEXES
       01 WS-TRANSACTION-INDEX PIC 9(4).
       01 WS-LAST-TRANSACTION-INDEX PIC 9(4) VALUE 0.

      * FOR THE OPTION MENU
       01 WS-OPTION PIC 9.

       PROCEDURE DIVISION.
       MAIN-PROCESS.

           OPEN I-O ACCOUNT-FILE
           
           PERFORM UNTIL WS-OPTION = 6
               DISPLAY " "
               DISPLAY "SELECT AN OPTION:"
               DISPLAY "   1. ACCOUNT INFORMATION"
               DISPLAY "   2. ADD ACCOUNT"
               DISPLAY "   3. UPDATE ACCOUNT"
               DISPLAY "   4. TRANSACTION INFORMATION" 
               DISPLAY "   5. EXECUTE TRANSACTION"
               DISPLAY "   6. TERMINATE"
    
               ACCEPT WS-OPTION
               EVALUATE WS-OPTION
                   WHEN 1
                       PERFORM ACCOUNT-INFORMATION
                   WHEN 2
                       PERFORM ADD-ACCOUNT
                   WHEN 3
                       PERFORM UPDATE-ACCOUNT
                   WHEN 4
                       PERFORM TRANSACTION-INFORMATION              
                   WHEN 5
                       PERFORM EXECUTE-TRANSACTION
                   WHEN 6
                       DISPLAY "BIS DANN!!!"
                   WHEN OTHER 
                       DISPLAY "---INVALID OPTION---"
               END-EVALUATE
           END-PERFORM.
           CLOSE ACCOUNT-FILE
       STOP RUN.

       ACCOUNT-INFORMATION.
           DISPLAY "INPUT THE ACCOUNT NUMBER"
           ACCEPT ACCOUNT-NUMBER
           READ ACCOUNT-FILE
               INVALID KEY 
                   DISPLAY "THERE IS NO ACCOUNT WITH NUMBER " 
                       ACCOUNT-NUMBER
               NOT INVALID KEY
                   DISPLAY "ACCOUNT NUMBER:                " 
                       ACCOUNT-NUMBER
                   DISPLAY "ACCOUNT HOLDER FIRST NAME:     " 
                       ACCOUNT-HOLDER-FN
                   DISPLAY "ACCOUNT HOLDER LAST NAME:      " 
                       ACCOUNT-HOLDER-LN
                   DISPLAY "ACCOUNT BALANCE:               " 
                       ACCOUNT-BALANCE
       .

       ADD-ACCOUNT.
           DISPLAY "CREATING NEW ACCOUNT"
           DISPLAY "INPUT THE ACCOUNT NUMBER:              " 
               WITH NO ADVANCING
           ACCEPT ACCOUNT-NUMBER
           READ ACCOUNT-FILE     
               INVALID KEY
                   DISPLAY "INPUT THE ACCOUNT HOLDER DATA"
                   DISPLAY "FIRST NAME:                    " 
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-HOLDER-FN
                   DISPLAY "LAST NAME:                     " 
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-HOLDER-LN
                   DISPLAY "INPUT THE ACCOUNT BALANCE:     " 
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-BALANCE
                   WRITE ACCOUNT-RECORD
               NOT INVALID KEY
                   DISPLAY "THE ACCOUNT NUMBER " ACCOUNT-NUMBER
                       " ALREADY EXISTS"
           END-READ                            
       .

       UPDATE-ACCOUNT.
           DISPLAY "UPDATING ACCOUNT"
           DISPLAY "INPUT THE ACCOUNT NUMBER               "
           ACCEPT ACCOUNT-NUMBER
           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "THE ACCOUNT NUMBER " ACCOUNT-NUMBER
                       " DOES NOT EXISTS"
               NOT INVALID KEY
                   DISPLAY "CURRENT ACCOUNT HOLDER FIRST NAME: "
                       ACCOUNT-HOLDER-FN
                   DISPLAY "NEW ACCOUNT HOLDER FIRST NAME:     "
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-HOLDER-FN
                   DISPLAY "CURRENT ACCOUNT HOLDER LAST NAME:  "
                       ACCOUNT-HOLDER-LN
                   DISPLAY "NEW ACCOUNT HOLDER LAST NAME:      "
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-HOLDER-LN
                   DISPLAY "CURRENT ACCOUNT BALANCE:           "
                       ACCOUNT-BALANCE
                   DISPLAY "NEW ACCOUNT BALANCE:               "
                       WITH NO ADVANCING
                   ACCEPT ACCOUNT-BALANCE
                   REWRITE ACCOUNT-RECORD
           END-READ
       .

       TRANSACTION-INFORMATION.
           DISPLAY "--------- TRANSACTION LIST ---------"
           OPEN INPUT TRANSACTION-FILE
           DISPLAY "FROM-ACCOUNT  TO-ACCOUNT" 
               "  TRANSACTION-AMOUNT  TRANSACTION-DATE"
               "  TRANSACTION-TIME"

           MOVE "N" TO WS-TRANSACTION-FILE-EOF
           PERFORM UNTIL WS-TRANSACTION-FILE-EOF = "Y"
               READ TRANSACTION-FILE
                   AT END
                       MOVE "Y" TO WS-TRANSACTION-FILE-EOF
                   NOT AT END
                       DISPLAY "       " FROM-ACCOUNT 
                           "       " TO-ACCOUNT 
                           "               " TRANSACTION-AMOUNT 
                           "            " TRANSACTION-DATE
                           "            " TRANSACTION-TIME
               END-READ
           END-PERFORM           
           CLOSE TRANSACTION-FILE
       .

    
       EXECUTE-TRANSACTION.
           DISPLAY " "
           DISPLAY "---INPUT THE TRANSACTION DATA---"
           
           DISPLAY " "
           DISPLAY "SENDER ACCOUNT NUMBER:"
               WITH NO ADVANCING
           ACCEPT ACCOUNT-NUMBER
           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "THE ACCOUNT NUMBER     " ACCOUNT-NUMBER
                       " DOES NOT EXIST"
                   EXIT
               NOT INVALID KEY
                   MOVE ACCOUNT-NUMBER TO SENDER-ACCOUNT-NUMBER
                   MOVE ACCOUNT-BALANCE TO SENDER-ACCOUNT-BALANCE
                   DISPLAY "ACCOUNT HOLDER:        "
                       ACCOUNT-HOLDER-FN " " ACCOUNT-HOLDER-LN
                   DISPLAY "ACCOUNT BALANCE:       "
                       ACCOUNT-BALANCE

           DISPLAY " "           
           DISPLAY "RECEIVER ACCOUNT NUMBER:"
               WITH NO ADVANCING
           ACCEPT ACCOUNT-NUMBER
           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY  "THE ACCOUNT NUMBER    " ACCOUNT-NUMBER
                       " DOES NOT EXIST"
               NOT INVALID KEY
                   MOVE ACCOUNT-NUMBER TO RECEIVER-ACCOUNT-NUMBER
                   MOVE ACCOUNT-BALANCE TO RECEIVER-ACCOUNT-BALANCE
                   DISPLAY "ACCOUNT HOLDER:        "
                       ACCOUNT-HOLDER-FN " " ACCOUNT-HOLDER-LN
                   DISPLAY "ACCOUNT BALANCE:       "
                       ACCOUNT-BALANCE

           DISPLAY " "
           DISPLAY "TRANSACTION AMOUNT:            "
               WITH NO ADVANCING

           ACCEPT WS-TRANSACTION-AMOUNT
           EVALUATE TRUE
               WHEN WS-TRANSACTION-AMOUNT > 
               SENDER-ACCOUNT-BALANCE
                   DISPLAY "THE TRANSACTION SENDER DOES NOT HAVE " &
                   "ENOUGH FUNDS TO PERFORM THE TRANSACTION."
               WHEN OTHER
      *            PERFORM THE TRANSACTION
      *            MOVE BALANCE IN THE ACCOUNTS 
                   SUBTRACT WS-TRANSACTION-AMOUNT FROM 
                       SENDER-ACCOUNT-BALANCE
                   ADD WS-TRANSACTION-AMOUNT TO
                       RECEIVER-ACCOUNT-BALANCE

                   MOVE SENDER-ACCOUNT-NUMBER TO ACCOUNT-NUMBER
                   READ ACCOUNT-FILE
                       INVALID KEY
                           DISPLAY "FAILED TO READ THE SENDER RECORD"
                           EXIT
                       NOT INVALID KEY
                           MOVE SENDER-ACCOUNT-BALANCE 
                               TO ACCOUNT-BALANCE
                           REWRITE ACCOUNT-RECORD
                   
                   MOVE RECEIVER-ACCOUNT-NUMBER TO ACCOUNT-NUMBER
                   READ ACCOUNT-FILE
                       INVALID KEY
                           DISPLAY "FAILED TO READ THE RECEIVER RECORD"
                           EXIT
                       NOT INVALID KEY
                           MOVE RECEIVER-ACCOUNT-BALANCE 
                               TO ACCOUNT-BALANCE
                           REWRITE ACCOUNT-RECORD
      
      *            CREATE A TRANSACTION RECORD
                   
                   OPEN EXTEND TRANSACTION-FILE
                   MOVE SENDER-ACCOUNT-NUMBER TO FROM-ACCOUNT
                   MOVE RECEIVER-ACCOUNT-NUMBER TO TO-ACCOUNT
                   MOVE WS-TRANSACTION-AMOUNT TO TRANSACTION-AMOUNT
                   ACCEPT TRANSACTION-DATE FROM DATE
                   ACCEPT TRANSACTION-TIME FROM TIME
                   WRITE TRANSACTION-RECORD  
                   CLOSE TRANSACTION-FILE                       
           END-EVALUATE
           CONTINUE.
*
     
       END PROGRAM BANKING.
       

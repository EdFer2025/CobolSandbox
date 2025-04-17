       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANSFER.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO "ACCOUNTS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACCOUNT-NUMBER
               FILE STATUS IS WS-FILE-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       01 ACCOUNTS-RECORD.
          05 ACCOUNT-NUMBER      PIC 9(5).
          05 ACCOUNT-NAME        PIC A(20).
          05 ACCOUNT-BALANCE     PIC 9(7).
       
       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS        PIC XX.
       
       01 WS-SENDER-ACCOUNT.
          05 WS-SENDER-NUMBER    PIC 9(5).
          05 WS-SENDER-NAME      PIC A(20).
          05 WS-SENDER-BALANCE   PIC 9(7).
       
       01 WS-RECEIVER-ACCOUNT.
          05 WS-RECEIVER-NUMBER  PIC 9(5).
          05 WS-RECEIVER-NAME    PIC A(20).
          05 WS-RECEIVER-BALANCE PIC 9(7).
       
       01 WS-TRANSFER-AMOUNT     PIC 9(7).
       
       PROCEDURE DIVISION.
       MAIN-LOGIC.
       
           OPEN I-O ACCOUNTS-FILE.
       
           DISPLAY "Enter Sender Account Number: ".
           ACCEPT WS-SENDER-NUMBER.
       
           MOVE WS-SENDER-NUMBER TO ACCOUNT-NUMBER.
           READ ACCOUNTS-FILE
               INVALID KEY DISPLAY "Sender account not found." 
               STOP RUN.
       
           MOVE ACCOUNT-NUMBER   TO WS-SENDER-NUMBER.
           MOVE ACCOUNT-NAME     TO WS-SENDER-NAME.
           MOVE ACCOUNT-BALANCE  TO WS-SENDER-BALANCE.
       
           DISPLAY "Enter Receiver Account Number: ".
           ACCEPT WS-RECEIVER-NUMBER.
       
           MOVE WS-RECEIVER-NUMBER TO ACCOUNT-NUMBER.
           READ ACCOUNTS-FILE
               INVALID KEY DISPLAY "Receiver account not found." 
               STOP RUN.
       
           MOVE ACCOUNT-NUMBER   TO WS-RECEIVER-NUMBER.
           MOVE ACCOUNT-NAME     TO WS-RECEIVER-NAME.
           MOVE ACCOUNT-BALANCE  TO WS-RECEIVER-BALANCE.
       
           DISPLAY "Enter amount to transfer: ".
           ACCEPT WS-TRANSFER-AMOUNT.
       
           IF WS-TRANSFER-AMOUNT > WS-SENDER-BALANCE
               DISPLAY "Not enough funds. Transfer cancelled."
               CLOSE ACCOUNTS-FILE
               STOP RUN
           END-IF.
       
      * Update balances
           SUBTRACT WS-TRANSFER-AMOUNT FROM WS-SENDER-BALANCE.
           ADD WS-TRANSFER-AMOUNT TO WS-RECEIVER-BALANCE.
       
      * Save sender
           MOVE WS-SENDER-NUMBER TO ACCOUNT-NUMBER.
           MOVE WS-SENDER-NAME   TO ACCOUNT-NAME.
           MOVE WS-SENDER-BALANCE TO ACCOUNT-BALANCE.
           REWRITE ACCOUNTS-RECORD.
       
      * Save receiver
           MOVE WS-RECEIVER-NUMBER TO ACCOUNT-NUMBER.
           MOVE WS-RECEIVER-NAME   TO ACCOUNT-NAME.
           MOVE WS-RECEIVER-BALANCE TO ACCOUNT-BALANCE.
           REWRITE ACCOUNTS-RECORD.
       
           DISPLAY "Transfer completed successfully!".
       
           CLOSE ACCOUNTS-FILE.
       
           STOP RUN.
       
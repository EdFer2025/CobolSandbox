       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTOMER-DB.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE 
               ASSIGN TO "01_EXAMPLES/04_customers.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CUSTOMER-ID
               FILE STATUS IS WS-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD CUSTOMER-FILE.
       01 CUSTOMER-RECORD.
           05 CUSTOMER-ID        PIC 9(5).
           05 CUSTOMER-NAME      PIC A(30).
           05 CUSTOMER-BALANCE   PIC 9(6).

       WORKING-STORAGE SECTION.
       01 WS-STATUS              PIC XX.
       01 WS-OPTION              PIC 9.
       01 WS-EXIT-FLAG           PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN-PROCESS.
           OPEN I-O CUSTOMER-FILE

           PERFORM UNTIL WS-EXIT-FLAG = "Y"
               DISPLAY "1. ADD  2. VIEW  3. UPDATE  4. DELETE  5. EXIT"
      *         DISPLAY WS-STATUS
               ACCEPT WS-OPTION

               EVALUATE WS-OPTION
                   WHEN 1
                       PERFORM ADD-CUSTOMER
                   WHEN 2
                       PERFORM VIEW-CUSTOMER
                   WHEN 3
                       PERFORM UPDATE-CUSTOMER
                   WHEN 4
                       PERFORM DELETE-CUSTOMER
                   WHEN 5
                       MOVE "Y" TO WS-EXIT-FLAG
                   WHEN OTHER
                       DISPLAY "INVALID OPTION"
               END-EVALUATE
           END-PERFORM

           CLOSE CUSTOMER-FILE
           STOP RUN.

       ADD-CUSTOMER.
           DISPLAY "Enter ID: " ACCEPT CUSTOMER-ID
           DISPLAY "Enter Name: " ACCEPT CUSTOMER-NAME
           DISPLAY "Enter Balance: " ACCEPT CUSTOMER-BALANCE

           WRITE CUSTOMER-RECORD INVALID KEY
               DISPLAY "Customer already exists."
           END-WRITE.

       VIEW-CUSTOMER.
           DISPLAY "Enter ID to view: " ACCEPT CUSTOMER-ID

           READ CUSTOMER-FILE
               INVALID KEY DISPLAY "Not found."
               NOT INVALID KEY
                   DISPLAY "Name: " CUSTOMER-NAME
                   DISPLAY "Balance: " CUSTOMER-BALANCE
           END-READ.

       UPDATE-CUSTOMER.
           DISPLAY "Enter ID to update: " ACCEPT CUSTOMER-ID

           READ CUSTOMER-FILE
               INVALID KEY DISPLAY "Not found."
               NOT INVALID KEY
                   DISPLAY "Enter New Name: " ACCEPT CUSTOMER-NAME
                   DISPLAY "Enter New Balance: " ACCEPT CUSTOMER-BALANCE
                   REWRITE CUSTOMER-RECORD
                   DISPLAY "Updated."
           END-READ.

       DELETE-CUSTOMER.
           DISPLAY "Enter ID to delete: " ACCEPT CUSTOMER-ID

           READ CUSTOMER-FILE
               INVALID KEY DISPLAY "Not found."
               NOT INVALID KEY
                   DELETE CUSTOMER-FILE
                   DISPLAY "Deleted."
           END-READ.
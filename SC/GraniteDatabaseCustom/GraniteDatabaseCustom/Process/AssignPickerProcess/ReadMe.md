# Process Print ship label 

This process will ask the user to scan Document (Picking) and enter qty.
The prescripts setup for the steps will show the user document information and insert a record into the table LabelPrintQueue.
This will in return print a ship label.


# Setup and install

Note the script will create all the data and objects needed, this script is not setup for alterations.

- Open Create.sql
- Change to SQL CMD mode
- Edit variables: GraniteDatabaseName and ERPDatabaseName
- Execute / Run
  
- After successful execution, ensure that your Bartender label and setup is done.
- Setup the process for your users and members that will use the process
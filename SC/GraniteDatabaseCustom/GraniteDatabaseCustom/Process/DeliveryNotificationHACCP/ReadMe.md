# Process DeliveryNotificationHACCP

This process is used to create a Notification of a delivery -recording the arrival of the delivery in a TAKEON transaction.
The Process extends the DeliveryNotification process to also capture a HACCP record for the delivery (and hence for the Receiving document)


The TrackingEntity DELIVERY is increased in Qty (Takeon to it)
The Location is specified in the first Step (but could be defaulted to DELIVERY -ensure the location exists)
The process will also Queue an integration record to update the PO on the truck if the flag @ERPAvailable is Set to 1 in the Prescript on Document Step
Finally -the Step200 step will send an email as well -set up the email respondents or remove this step if DBMAIL is not setup.
DBMAIL Setup is in the COMMON section of the DatabaseCustom project

# Setup and install

Note the script will create all the data and objects needed, this script is not setup for alterations.

- Open Create.sql
- Change to SQL CMD mode
- Edit variables: GraniteDatabaseName and ERPDatabaseName
- Execute / Run
  
- Setup the process for your users and members that will use the process
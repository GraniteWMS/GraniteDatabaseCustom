 
# Process Print ship label 

This process will ask the user to scan Document (Picking) and enter qty.
The prescripts setup for the steps will show the user document information and insert a record into the table LabelPrintQueue.
This will in return print a ship label.


# Setup and install

Note the script will create all the data and objects needed, this script is not setup for alterations.

- Open CreateShipLabelProcess.sql
- Change to SQL CMD mode
- Edit variables: GraniteDatabaseName and ERPDatabaseName
- Execute / Run
  
- After successful execution, ensure that your Bartender label and setup is done.
- Setup the process for your users and members that will use the process


## List of all data and objects used by process

- Custom Process:       PRINTSHIPLABELS, Steps: Document, Qty
- Custom Scripts:       PrescriptPrintShipLabelsDocument, PrescriptPrintShipLabelsQty
- Custom View:          Label_ShipLabel (Label_ShipLabel_EVO view for Sage EVO)
- Custom Label format:  SHIPLABEL.BTW
- Standard Table:       LabelPrintQueue

## Custom SQL view Label_ShipLabel

The view is currently implemented to look at Sage EVO, this view need to be changed if you have different ERP.
Use the same column names to utilize the Label Format and PreScripts.

## Bartender Label

The label use the custom SQL view to map the data displayed on the label, the label can be re-used for any ERP as long as you keep the column names in 
the view (Label_ShipLabel) the same.

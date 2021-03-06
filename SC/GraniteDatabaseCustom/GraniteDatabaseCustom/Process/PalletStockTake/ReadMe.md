# Process Pallet Stock Take

This process allows users to enter a qty per MasterItem on a pallet during a stocktake session. 
If the entered count matches what we have on hand, they will be able to go to the PalletConfirm step. 
If it does not match, the user will be forced to scan the TEs on the pallet.

# Setup and install

Note the script will create all the data and objects needed, this script is not setup for alterations.

- Open Create.sql
- Change to SQL CMD mode
- Edit variables: GraniteDatabaseName and ERPDatabaseName
- Execute / Run
  
- Setup the process for your users and members that will use the process


## List of all data and objects used by process

- Custom Process:       PALLETSTOCKTAKE, Steps: Session, Count, Location, TrackingEntity, PalletConfirmation, Qty
- Custom Scripts:       PrescriptPalletStockTakeTrackingEntity, PrescriptPalletStockTakePalletConfirmation
- Custom Table:			Custom_Pallet_Counted

## Custom Table Custom_Pallet_Counted

The table is used to record the Pallet, StockTake Session, and Count combination on which a pallet was incorrectly counted.
If there is a record in this table for the given combination, the user will be forced to scan the TrackingEntities on the pallet
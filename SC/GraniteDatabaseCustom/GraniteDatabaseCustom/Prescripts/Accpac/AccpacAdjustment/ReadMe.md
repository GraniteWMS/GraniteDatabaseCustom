# UpdateAccpacJournal

-- Sage300 Accpac Tables:
-- Update Table:  ICADED
-- Use Tables: ICILOC, ICADEH
-- Description:	
--   Purpose is to change the Journal entry created to BothIncrease or BothDecrease and update the cost column.
--   The prescripts use STEP200 (silent) to change the Granite QtyOnly Journal on Adjustment and Reclassify to also support Qty and Cost (Both) and it calculates the Extended cost (from STDCost) but can be changed to RECENT or LASTCOST.
-- Requirements:
--   IntegrationPost must be FALSE (You cannot update the Journal after posting)
--   The ACCPACDATABASE, ERPLOCATION, JOURNAL NUMBERS must be modified.
--   Ensure that the IntegrationReference is either entered - in which case get it from the ProcessSteps, or it can be queried from the last Journal entry as below. 

- ScriptName: PreScriptAdjustmentSilentStep_UpdateAccpacJournal
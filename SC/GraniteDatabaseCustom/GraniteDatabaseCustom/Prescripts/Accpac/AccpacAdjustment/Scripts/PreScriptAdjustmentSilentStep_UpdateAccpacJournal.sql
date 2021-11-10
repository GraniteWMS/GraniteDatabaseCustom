CREATE PROCEDURE  [dbo].[PreScriptAdjustmentSilentStep_UpdateAccpacJournal] (
   @input dbo.ScriptInputParameters READONLY 
)
AS

DECLARE @Output TABLE(
  Name varchar(max), 
  Value varchar(max) 
  )

SET NOCOUNT ON;

DECLARE @valid bit =1
DECLARE @message varchar(MAX) =''
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' --This could be a barcode or stock code

-- Requirement: Journal codes to the correct Writeoff and Stock GL Accounts for the customer
DECLARE @WOFFACCT varchar(20)
DECLARE @ORIGACCT varchar(20)
SELECT @WOFFACCT = '5370'
SELECT @ORIGACCT = '5370'
DECLARE @STDCOST decimal
DECLARE @ADJENSEQ int

DECLARE @AdjustmentType varchar(20)
DECLARE @MasterItem_id bigint
DECLARE @MasterItemCode varchar(50)
DECLARE @FormattedMasterItemCode varchar(50)
DECLARE @TrackingEntityBarcode varchar(50)
DECLARE @IntegrationReference varchar(50)
DECLARE @User varchar(30)
SELECT @User = Value from @input WHERE Name = 'User'
DECLARE @ERPLocation varchar(20)

-- Important Requirement: Get the IntegrationReference either from Granite Process or from SAGE ICADEH header table.
-- SELECT @IntegrationReference = UPPER(Value) FROM @input WHERE Name = 'IntegrationReference' -- Granite Process
SELECT @IntegrationReference = (SELECT TOP 1 DOCNUM FROM [ACCPAC].dbo.ICADEH WHERE ENTEREDBY = 'ADMIN' ORDER BY ADJENSEQ DESC) -- Accpac ICADEH Table

SELECT @TrackingEntityBarcode = Value FROM @input WHERE Name = 'TrackingEntity'
SELECT @AdjustmentType = Value FROM @input WHERE Name = 'Type'

SELECT @ERPLocation = ERPLocation, @MasterItem_id = MasterItem_id 
  FROM TrackingEntity INNER JOIN Location on Location.ID = TrackingEntity.Location_id 
  WHERE TrackingEntity.Barcode = @TrackingEntityBarcode

SELECT @MasterItemCode = Code, @FormattedMasterItemCode = FormattedCode From MasterItem WHERE ID = @MasterItem_id

-- Customer specific: Also can update the costing from STDCOST to LASTCOST or RECENTCOST depending on the SAGE consultant OR accountant
SELECT @STDCOST = (SELECT TOP 1 STDCOST FROM [$(AccpacDatabase)].dbo.ICILOC WHERE ITEMNO = @MasterItemCode AND LOCATION = @ERPLocation)

SELECT @ADJENSEQ = (SELECT TOP 1 ADJENSEQ FROM [$(AccpacDatabase)].dbo.ICADEH WHERE DOCNUM = UPPER(@IntegrationReference))

-- ACCPAC Update
UPDATE [$(AccpacDatabase)].dbo.ICADED 
SET TRANSTYPE = CASE @AdjustmentType WHEN 'QtyDecrease' THEN 6 WHEN 'QtyIncrease' THEN 5 END,
WOFFACCT = @WOFFACCT,                     -- AS per variable Declaration  
ORIGACCT = @ORIGACCT,                     -- AS per variable Declaration 
EXTCOST = ROUND(QUANTITY  * @STDCOST, 2)  -- AS per above requirement and specification (calc: qty * cost)
WHERE ADJENSEQ = @ADJENSEQ 
AND ITEMNO = @FormattedMasterItemCode 
AND TRANSTYPE < 5

SELECT @message = 'Custom Journal Update for Costs and Type Successfull'
INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output

GO
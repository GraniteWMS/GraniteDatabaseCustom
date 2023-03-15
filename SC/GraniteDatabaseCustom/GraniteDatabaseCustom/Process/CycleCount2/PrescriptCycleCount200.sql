

/****** Object:  StoredProcedure [dbo].[PreScriptPickingDocument]    Script Date: 7/5/2022 9:05:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PrescriptCycleCount200] (
   @input dbo.ScriptInputParameters READONLY
)
AS

DECLARE @Output TABLE(
  Name varchar(max),
  Value varchar(max)
  )

SET NOCOUNT ON;

DECLARE @valid bit = 1
DECLARE @message varchar(MAX) = ''
DECLARE @User varchar(50)  =(SELECT  Value FROM @input WHERE Name = 'User')
DECLARE @stepInput varchar(MAX)  =(SELECT Value FROM @input WHERE Name = 'StepInput')
DECLARE @TrackingEntity varchar(50)  =(SELECT Value FROM @input WHERE Name = 'TrackingEntity')
DECLARE @CycleCountSession varchar(50)  =(SELECT Value FROM @input WHERE Name = 'CycleCountSession')
DECLARE @CountLocationBarcode varchar(50)  =(SELECT Value FROM @input WHERE Name = 'Location')
DECLARE @Batch varchar(50)  =(SELECT Value FROM @input WHERE Name = 'Batch')
DECLARE @ExpiryDate varchar(20)  =(SELECT Value FROM @input WHERE Name = 'ExpiryDate')
DECLARE @ManufactureDate varchar(20)  =(SELECT Value FROM @input WHERE Name = 'ManufactureDate')
DECLARE @SerialNumber varchar(MAX)  =(SELECT Value FROM @input WHERE Name = 'SerialNumber')
DECLARE @CountQty varchar(20)  =(SELECT Value FROM @input WHERE Name = 'Qty')
DECLARE @TEQty bigint
DECLARE @MasterItemCode varchar(50)
DECLARE @MasterItem_id BIGINT
DECLARE @TrackingEntity_id BIGINT
DECLARE @Location_id BIGINT
DECLARE @LocationBarcode varchar(50)
DECLARE @CountLocation_id BIGINT
DECLARE @ERPQty Decimal(19,4)
DECLARE @MasterItemQty Decimal(19,4)
DECLARE @Status varchar(30) = 'COUNT1'
DECLARE @ERPLocation varchar(30) 

if exists(select id from TrackingEntity WHERE Barcode = @TrackingEntity)
BEGIN
--Get the TrackingEntity information for Snapshop at count time.
	SELECT @TrackingEntity_id = TE.ID, @MasterItem_id = TE.MasterItem_id, 	@TEQty = TE.Qty,
	@Location_id = TE.Location_id, @LocationBarcode = LOC.Barcode, @ERPLocation = LOC.ERPLocation,
	@MasterItemCode = MI.Code
	FROM TrackingEntity TE INNER JOIN 
	MasterItem MI ON TE.MasterItem_id = MI.ID INNER JOIN
	Location LOC ON TE.Location_id = LOC.ID
	WHERE TE.Barcode = @TrackingEntity
	--Get @ERPQty and @MasterItemQty
	SELECT @CountLocation_id = ID FROM Location WHERE Barcode = @CountLocationBarcode --Location of TE, not the scanned location

	SELECT @ERPQty = QTYONHAND FROM ERP_StockOnHand WHERE ITEMNO = @MasterItemCode AND Location = @ERPLocation

	IF NOT EXISTS(SELECT ID FROM CycleCountAction WHERE CycleCountSession = @CycleCountSession AND TrackingEntity_id = @TrackingEntity_id )
	BEGIN
		INSERT INTO CycleCountAction (CycleCountSession,ScanDate,ERPQty, MasterItem_id, MasterItemCode,MasterItemQty, 
		TrackingEntity_id, TrackingEntity,Location_id, LocationBarcode,CountLocation_id, CountLocationBarcode, Count1Qty, Count1User,Status,AuditDate, AuditUser)
		SELECT @CycleCountSession,getdate(), @ERPQty, @MasterItem_id, @MasterItemCode, @MasterItemQty,
		@TrackingEntity_id,@TrackingEntity,@Location_id, @LocationBarcode, @CountLocation_id, @CountLocationBarcode,@CountQty,@User, @Status,getdate(), @User
		SELECT @message = 'Cyclecount COUNT 1 Action Captured'

	END
	ELSE 
	BEGIN
		SELECT @Status = 'COUNT2'
		UPDATE CycleCountAction SET Count2Qty = @CountQty, Count2User = @User, AuditDate = getdate(), AuditUser = @User, Status = 'COUNT2'
		WHERE CycleCountSession = @CycleCountSession AND TrackingEntity_id = @TrackingEntity_id 
		SELECT @message = 'Cyclecount COUNT 2 Action Captured'
	END
	

	--Optionally Adjust immediately
	--SELECT @Status = 'PROCESSED'

	--Optionally Integrate the Adjustment Immediately
	--SELECT @Status = 'POSTED'

	--If this count was due to a CycleCountRequirement -Update the Requirement.

	/*
	In the WebDesktop UI I expect to be able to see the Table CycleCountAction.
	MultiSelect Records and then either process Count 1 or Count 2 as Adjustment to Granite or AdjustGranite and ERP.
	The  Adjustment must take into Account the Difference between the Counted Qty and the Snapshot Qty (at time of Count) and calculate (do this in the display view) the Qty to Adjust by on Granite and ERP at the time of adjustment.
	After Adjustment, update Status to ADJGRANITE-COUNT1, ADJGRANITE-COUNT2, ADJBOTH-COUNT1, ADJBOTH-COUNT2, CANCEL, 
	Also write a Transaction for this adjustment with  IntegrationReference if it was integrated.
	*/

	SELECT @valid = 1
END
ELSE
BEGIN
	SELECT @message = 'TrackingEntity Not found'
	SELECT @valid = 0

END


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output
GO



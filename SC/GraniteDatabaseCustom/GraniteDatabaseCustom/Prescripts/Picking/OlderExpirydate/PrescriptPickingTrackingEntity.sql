
/****** Object:  StoredProcedure [dbo].[PrescriptPickingTrackingEntity]    Script Date: 5/30/2022 8:09:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Prevent pick of older expiry date.  If they specifically want to override this they need to put the older pallet on HOLD


CREATE PROCEDURE [dbo].[PrescriptPickingTrackingEntity] (
   @input dbo.ScriptInputParameters READONLY --List of [Name, Value]
)
AS

DECLARE @Output TABLE(
  Name varchar(max),  --Name represents the stepname
  Value varchar(max)  --Value the value of the step
  )

SET NOCOUNT ON;

DECLARE @valid bit =1
DECLARE @message varchar(MAX) =''
DECLARE @user varchar(30) = (SELECT Value from @input WHERE Name = 'User')
DECLARE @site varchar(30) = (SELECT Site from [Users] WHERE Name = @user)
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' 

DECLARE @Document varchar(50) = (SELECT Value FROM @input WHERE Name = 'Document')
DECLARE @DocumentID BIGINT 
DECLARE @ScannedExpiryDate DateTime
DECLARE @FromERPLocation varchar(50)    --May need to actually get the FROMERPLocation from the DocumentDetail line for the item scanned as Picking checks From Lines.
DECLARE @MasterItemID BIGINT
DECLARE @SuggestedTE varchar(50)
DECLARE @SuggestedExpiry DateTime
DECLARE @SuggestedLocationBarcode varchar(50)
DECLARE @ExpiryToleranceDays INT = 3


SELECT @DocumentID = ID, @FromERPLocation = ERPLocation FROM Document WHERE Number = @Document
SELECT @ScannedExpiryDate = ExpiryDate, @MasterItemID = MasterItem_id FROM TrackingEntity WHERE Barcode=  @stepInput

IF @ScannedExpiryDate is not null
BEGIN
	SELECT TOP 1 @SuggestedTE = TE.Barcode, @SuggestedExpiry = ExpiryDate, @SuggestedLocationBarcode = L.Barcode FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID
	WHERE TE.InStock = 1 AND TE.OnHold = 0 AND TE.Qty > 0 AND TE.MasterItem_id= @MasterItemID
	AND L.ERPLocation = @FromERPLocation
--	AND L.Site = @site
--	AND isnull(L.Category,'') <> 'NOPICK' or isnull(L.Category,'') = 'PICKING'
	AND  DATEDIFF(DAY,TE.ExpiryDate,@ScannedExpiryDate) > @ExpiryToleranceDays
	AND TE.ExpiryDate > getdate()
	ORDER BY TE.ExpiryDate

	IF isnull(@SuggestedTE,'') <> ''
	BEGIN		
		SELECT @Valid=0
		SELECT @message = 'OLDER EXPIRY IN WAREHOUSE. Barcode:' + @SuggestedTE + ' with Expiry:' + CONVERT(varchar(10), @SuggestedExpiry) + ' in Location:' + @SuggestedLocationBarcode

	END
END
ELSE
BEGIN
		SELECT @Valid=1
		SELECT @message = 'The item scanned has no expiry date captured - check the date'

END






INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

----return values Output
SELECT * FROM @Output

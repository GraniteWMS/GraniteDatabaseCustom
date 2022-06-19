
/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyConfirmation]    Script Date: 6/18/2022 4:15:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyConfirmation] (
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
DECLARE @User varchar(50) =  (SELECT Value FROM @input WHERE Name = 'User')
DECLARE @stepInput varchar(MAX)  = (SELECT Value FROM @input WHERE Name = 'StepInput' )

DECLARE @Carrier varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Carrier' )
DECLARE @Truck varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Truck' )
DECLARE @Driver varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Driver' )
DECLARE @DeliveryReference varchar(50)  = (SELECT Value FROM @input WHERE Name = 'Reference' )


INSERT INTO @Output
SELECT 'Instruction', 
CONCAT('<h4>Delivery Details</h4><hr>','<h4><b>Carrier:</b>  ',@Carrier,'<br><b>Truck:</b>    ',@Truck,'<br><b>Driver:</b>   ',@Driver,'<br><b>Waybill:</b>  ',@DeliveryReference,'</h4>')


DECLARE @Location varchar(50)  = (SELECT Value FROM @input WHERE Name = 'Location' )
DECLARE @Location_id varchar(50) = (SELECT ID FROM Location WHERE Barcode = @Location)

DECLARE @Document varchar(50) = (SELECT Value from @input WHERE Name = 'Document')
DECLARE @Comment varchar(MAX)


--Add MasterItem
DECLARE @MasterItemCode varchar(50) = 'DELIVERY'
DECLARE @MasterItem_id BIGINT
SELECT @MasterItem_id = ID FROM MasterItem with (nolock) WHERE Code = @MasterItemCode
IF isnull(@MasterItem_id,0) = 0
BEGIN
	INSERT INTO MasterItem (Code, FormattedCode,isActive,Description)
	SELECT @MasterItemCode, @MasterItemCode, 1, @MasterItemCode
END
------------------------------------------------------------------------------------

IF UPPER(@stepInput) IN ('Y','YES')
BEGIN

	--Set the comment for the Transaction
	SELECT @Comment = CONCAT(@Carrier,'|', @Truck, '|', @Driver,'|',@DeliveryReference)
	SELECT @DeliveryReference = CONCAT(@DeliveryReference,'|', @Document)
	--Write to DocumentTrackingLog
	INSERT INTO custom_DocumentTrackingLog(Document,Version,TrackingStatus,[User],ActivityDate,Comment,DocumentReference)
	SELECT @Document,1,'DELIVERY',@User,getdate(),@Comment,@DeliveryReference

	INSERT INTO @Output	SELECT 'Reference', LEFT(@DeliveryReference,50)
	INSERT INTO @Output	SELECT 'Comment', LEFT(@Comment,250)
	INSERT INTO @Output	SELECT 'MasterItem', @MasterItemCode

	SELECT @valid = 1
	SELECT @message = 'Delivery Notification Captured'
END


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output


/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPConfirmation]    Script Date: 6/19/2022 7:37:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyHACCPConfirmation] (
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
DECLARE @stepInput varchar(MAX)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'StepInput' )

DECLARE @Carrier varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Carrier' )
DECLARE @Truck varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Truck' )
DECLARE @Driver varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Driver' )

DECLARE @ConditionClean varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPConditionClean' )
DECLARE @ConditionDamage varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPConditionDamage' )
DECLARE @ConditionOdor varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPConditionOdor' )
DECLARE @ConditionPests varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPConditionPests' )

DECLARE @TruckEnvironment varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPTruckEnvironment' )
DECLARE @TruckTemperature varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPTruckTemperature' )
DECLARE @TruckTransitDuration varchar(50)  = (SELECT Value FROM @input WHERE Name = 'HACCPTruckTransitDuration' )

DECLARE @DeliveryReference varchar(50)  = (SELECT Value FROM @input WHERE Name = 'Reference' )
INSERT INTO @Output
SELECT 'Instruction', 
CONCAT('<h4>Delivery Details</h4><hr>','<h4><b>Carrier:</b>  ',@Carrier,'<br><b>Truck:</b>    ',@Truck,'<br><b>Driver:</b>   ',@Driver,'<br><b>Waybill:</b>  ',@DeliveryReference,
'<br><b>Condition :</b>    ',@ConditionClean,'|',@ConditionDamage,'|',@ConditionOdor,'|',@ConditionPests,
'<br><b>Truck info:</b>    ',@TruckEnvironment,'|Temp: ',@TruckTemperature,'|Transit Duration',@TruckTransitDuration,
'</h4>')


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

	INSERT INTO HACCPheader(Carrier, Truck, Driver, DeliveryReference, [DateTimeStamp], ConditionClean, ConditionDamage, ConditionOdor, ConditionPests, TruckEnvironment, TruckTemperature, TruckTransitDuration, [User],ReviewedBy,Document)
	SELECT @Carrier, @Truck, @Driver,@DeliveryReference,getdate(),@ConditionClean, @ConditionDamage, @ConditionOdor, @ConditionPests, @TruckEnvironment, @TruckTemperature, @TruckTransitDuration, @User, @User, @Document

	--Validate the Document - If not in Granite -Queue Integration

	--Set the comment for the Transaction
	SELECT @Comment = CONCAT(@Carrier,'|', @Truck, '|', @Driver,'|', @ConditionClean,',',@ConditionDamage,',',@ConditionOdor, ',', @ConditionPests,'|',@TruckEnvironment, ',', @TruckTemperature, ',', @TruckTransitDuration)
	SELECT @DeliveryReference = CONCAT(@DeliveryReference,'|', @Document)
	--Write to DocumentTrackingLog (Note comment field is 200, not 250 -need to expand in database project.
	INSERT INTO custom_DocumentTrackingLog(Document,Version,TrackingStatus,[User],ActivityDate,Comment,DocumentReference)
	SELECT @Document,1,'DELIVERY',@User,getdate(),LEFT(@Comment,200),@DeliveryReference

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


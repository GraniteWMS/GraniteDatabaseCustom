
/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPReference]    Script Date: 6/19/2022 7:38:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyHACCPReference] (
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



INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output


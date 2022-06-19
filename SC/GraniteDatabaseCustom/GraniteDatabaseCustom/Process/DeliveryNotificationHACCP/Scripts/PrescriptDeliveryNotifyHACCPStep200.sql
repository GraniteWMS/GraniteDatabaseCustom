
/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPStep200]    Script Date: 6/19/2022 7:23:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyHACCPStep200] (
   @input dbo.ScriptInputParameters READONLY
)
AS

DECLARE @Output TABLE(
  Name varchar(max),
  Value varchar(max)
  )

SET NOCOUNT ON;
DECLARE @ERPAvailable bit = 0		--

DECLARE @valid bit = 1
DECLARE @message varchar(MAX) = ''
DECLARE @User varchar(50) =  (SELECT Value FROM @input WHERE Name = 'User')
DECLARE @stepInput varchar(MAX)  = (SELECT Value FROM @input WHERE Name = 'StepInput' )
DECLARE @Carrier varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Carrier' )
DECLARE @Truck varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Truck' )
DECLARE @Driver varchar(50)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'Driver' )

DECLARE @ConditionClean varchar(50)  = (SELECT Value FROM @input WHERE Name = 'ConditionClean' )
DECLARE @ConditionDamage varchar(50)  = (SELECT Value FROM @input WHERE Name = 'ConditionDamage' )
DECLARE @ConditionOdor varchar(50)  = (SELECT Value FROM @input WHERE Name = 'ConditionOdor' )
DECLARE @ConditionPests varchar(50)  = (SELECT Value FROM @input WHERE Name = 'ConditionPests' )

DECLARE @TruckEnvironment varchar(50)  = (SELECT Value FROM @input WHERE Name = 'TruckEnvironment' )
DECLARE @TruckTemperature varchar(50)  = (SELECT Value FROM @input WHERE Name = 'TruckTemperature' )
DECLARE @TruckTransitDuration varchar(50)  = (SELECT Value FROM @input WHERE Name = 'TruckTransitDuration' )

DECLARE @DeliveryReference varchar(50)  = (SELECT Value FROM @input WHERE Name = 'Reference' )


DECLARE @html varchar(max)
DECLARE @EmailSubject varchar(100)

	
SELECT @EmailSubject = 'Delivery Notification with HACCP'						
					
SELECT @html = CONCAT('<body><h1><b>',@EmailSubject,'</h1></b>','<h4>Delivery Details</h4><hr>',
'<h4><b>Carrier:</b>  ',@Carrier,'<br><b>Truck:</b>    ',@Truck,'<br><b>Driver:</b>   ',@Driver,'<br><b>Waybill:</b>  ',@DeliveryReference,
'<br><b>Condition :</b>    ',@ConditionClean,'|',@ConditionDamage,'|',@ConditionOdor,'|',@ConditionPests,
'<br><b>Truck info:</b>    ',@TruckEnvironment,'|',@TruckTemperature,'|',@TruckTransitDuration,
'</h4>')
	--Send a mail
EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
		@recipients = 'craigc@granitewms.com',		--Separate email recipients with ;
		@subject = @EmailSubject,
		@Body = @html,
		@body_format = 'HTML'


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output


GO



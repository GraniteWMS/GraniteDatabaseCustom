
/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPReference]    Script Date: 6/19/2022 7:20:10 PM ******/
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
DECLARE @DeliveryReference varchar(50)  = (SELECT Value FROM @input WHERE Name = 'Reference' )
INSERT INTO @Output
SELECT 'Instruction', 
CONCAT('<h4>Delivery Details</h4><hr>','<h4><b>Carrier:</b>  ',@Carrier,'<br><b>Truck:</b>    ',@Truck,'<br><b>Driver:</b>   ',@Driver,'<br><b>Waybill:</b>  ',@DeliveryReference,'</h4>')


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output

GO




/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPLocation]    Script Date: 6/19/2022 7:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyHACCPLocation] (
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

--Add Loction
DECLARE @LocationBarcode varchar(50) = @StepInput
DECLARE @Location_id BIGINT
SELECT @Location_id = ID FROM Location with (nolock) WHERE Barcode = @LocationBarcode
IF isnull(@Location_id,0) = 0
BEGIN
	SELECT @message = 'You must define the Delivery location first'
END

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output

GO



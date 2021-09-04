CREATE PROCEDURE [dbo].[PrescriptPrintShipLabelsQty] (
   @input [dbo].ScriptInputParameters READONLY
)
AS
DECLARE @Output TABLE(
  Name varchar(max),  
  Value varchar(max)  
  )

SET NOCOUNT ON;

DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) = (UPPER(Value) FROM @input WHERE Name = 'StepInput') 
DECLARE @User varchar(30) = (SELECT VALUE FROM @input WHERE NAME = 'User')
	
DECLARE @Document varchar(50) =	(SELECT VALUE FROM @input WHERE Name = 'Document')
DECLARE @Printer varchar(20)
	SELECT @Printer = UPPER(Value) FROM @input WHERE Name = 'PrinterName' 
	IF ISNULL(@Printer,'') = '' SET @Printer = 'Z2'
	
IF ISNUMERIC(@stepInput) = 1
	IF CONVERT(Int,@stepInput) <=50
	BEGIN
		SELECT @valid = 1
		SELECT @message = 'Label inserted into Printing Queue'
		INSERT INTO [$(GraniteDatabase)].[dbo].LabelPrintQueue (DateQueued, LabelFormat, LabelParameter1, LabelParameter2, QuantityofLabels, Printer, Status, [User])
		SELECT getdate(),'SHIPLABEL.BTW', @Document,'', CONVERT(INT,@stepInput), @Printer, 'ENTERED', @User
	END
	ELSE
	BEGIN
		SELECT @valid = 0
		SELECT @message = 'Number of Labels must be less than 50'
	END
ELSE
BEGIN
	SELECT @valid = 0
	SELECT @message = 'Number of Labels must be a number'
END	
	
	INSERT INTO @Output
	SELECT 'Instruction', '<br>'
	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output

GO
PRINT '############### [PrescriptPrintShipLabelsQty] Created ###################'
GO

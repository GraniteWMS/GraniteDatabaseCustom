CREATE PROCEDURE [dbo].[PrescriptOrderCheckNumberOfLabels] (
   @input dbo.ScriptInputParameters READONLY 
)
AS
DECLARE @Output TABLE(
  Name varchar(max),  
  Value varchar(max)  
  )

SET NOCOUNT ON;

DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
	SELECT @stepInput = UPPER(Value) FROM @input WHERE Name = 'StepInput' 
DECLARE @User varchar(30)
	SELECT @User = VALUE FROM @input WHERE NAME = 'User'
Declare @Instruction VARCHAR(MAX)
SELECT @Instruction = '<head><title>Scan Next Order to Check and print labels</title></head>'
DECLARE @Document varchar(50)
	SELECT @Document = VALUE FROM @input WHERE Name = 'Document'
DECLARE @Printer varchar(20)
	SELECT @Printer = UPPER(Value) FROM @input WHERE Name = 'PrinterName'         
	IF isnull(@Printer,'') = '' OR @Printer = 'ZD' SET @Printer = 'ZDISPATCH'
	
IF isnumeric(@stepInput) = 1
	IF CONVERT(Int,@stepInput) <=50
	BEGIN
		SELECT @valid = 1
		SELECT @message = ''
		INSERT INTO LabelPrintQueue (DateQueued,LabelFormat,LabelParameter1,LabelParameter2,QuantityofLabels,Printer,Status, [User])
		SELECT getdate(),'ShipLabel.btw',@Document,'SHIPLABEL',CONVERT(INT,@stepInput),@Printer,'ENTERED',@User
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
	SELECT 'Instruction', @Instruction
	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output

GO
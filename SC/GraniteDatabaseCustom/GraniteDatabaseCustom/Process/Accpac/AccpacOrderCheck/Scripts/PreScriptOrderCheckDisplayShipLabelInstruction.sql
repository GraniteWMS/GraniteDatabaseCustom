CREATE PROCEDURE [dbo].[PreScriptOrderCheckDisplayShipLabelInstruction] (
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

DECLARE @Instruction VARCHAR(MAX)
SELECT @Instruction = '<head><title>Scan Next Order to Check and print labels</title></head>'
		
SELECT @valid = 1
SELECT @message = ''

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
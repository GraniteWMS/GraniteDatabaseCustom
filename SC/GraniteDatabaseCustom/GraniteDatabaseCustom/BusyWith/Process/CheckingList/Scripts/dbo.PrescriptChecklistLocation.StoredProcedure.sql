CREATE PROCEDURE [dbo].[PrescriptChecklistLocation] (
   @input dbo.ScriptInputParameters READONLY 
AS

DECLARE @Output TABLE(
  Name varchar(max), 
  Value varchar(max)  
  )

SET NOCOUNT ON;


DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @Location varchar(MAX) 
SELECT @Location = Value FROM @input WHERE Name = 'StepInput' 


IF EXISTS(SELECT * FROM [$(GraniteDatabase)].dbo.[Location] WHERE Barcode = @Location OR [Name] = @Location)
BEGIN
	SELECT @valid = 1
END
ELSE
BEGIN
	SELECT @valid = 0
	SELECT @message = CONCAT('Location ', @Location, ' not found')
END

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @Location

	SELECT * FROM @Output
GO




CREATE PROCEDURE  [dbo].[PrescriptPickingPickMethod] (
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
DECLARE @Document varchar(50)
DECLARE @SelectionTimeDifferenceMINUTES int = 15	

--Clear the list so no spurious data
DELETE FROM ProcessStepLookupDynamic WHERE UserName = @User

--Clear any selection list so that the User enters or scans the Document
IF (@StepInput = 'ENTERDOC') 
BEGIN
--Clear the ProcessStepLookupTable for the user so that the Document prompt is entered.
	SELECT @Document = ''
	DELETE FROM ProcessStepLookupDynamic WHERE UserName = @User
	SELECT @message = ''
	SELECT @valid = 1
END

--Select the Next Document in the available picking documents
IF (@StepInput = 'NEXTDOC')	
BEGIN
	SELECT TOP 1 @Document  = Number FROM Document 
	WHERE Status = 'RELEASED' and isActive = 1 
	ORDER BY Priority, ExpectedDate, CreateDate

	SELECT @message = ''
	SELECT @valid = 1

END

--Populate the ProcessStepLookup with a list of Released documents to select from.  Exclude Documents that are busy being picked (Transaction in last 15minutes)
IF (@StepInput = 'SELECTDOC') 
BEGIN
	SELECT @Document = ''
	INSERT INTO ProcessStepLookupDynamic (Value, Description, Process, ProcessStep, UserName)
	SELECT Number, Number + ' ' + TradingPartnerDescription, 'PICKING', 'Document', @User
	FROM Document
	WHERE Status = 'RELEASED' and isActive = 1
	AND Number NOT IN	
	--This query returns Document numbers that have pick transactions in last XX minutes
	(SELECT Number FROM [Transaction] INNER JOIN Document 
	ON [Transaction].Document_id = Document.ID
	WHERE [Transaction].Type = 'PICKING' 
	AND DATEDIFF(MINUTE,[Transaction].Date, getdate())  < @SelectionTimeDifferenceMINUTES )
	ORDER BY Priority, ExpectedDate, CreateDate
	--May need to exclude Assigned orders if Picker Assignment is also used. (STILL TO DO)

	SELECT @message = ''
	SELECT @valid = 1
END
IF (@StepInput = 'ASSIGNEDDOC')
BEGIN
	SELECT @Document = ''
	INSERT INTO ProcessStepLookupDynamic (Value, Description, Process, ProcessStep, UserName)
	SELECT Number, Number + ' ' + TradingPartnerDescription, 'PICKING', 'Document', @User
	FROM Document
	WHERE Status = 'RELEASED' and isActive = 1 and CHARINDEX(@User,AssignedTo,1) > 0		--The User Name is in the AssignedTo field
	ORDER BY Priority, ExpectedDate, CreateDate
	
	SELECT @message = ''
	SELECT @valid = 1
END


INSERT INTO @Output
SELECT 'Document', @Document

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output
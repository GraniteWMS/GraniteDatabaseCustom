USE [GraniteDatabaseTest]
GO

/****** Object:  StoredProcedure [dbo].[FunctionOrderProgressAssignPicker]    Script Date: 6/27/2022 8:03:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[FunctionOrderProgressAssignPicker] (
   @input dbo.ScriptInputParameters READONLY, -- inputs
   @JsonInput nvarchar(max)                   -- selected records (grid)
)
AS

DECLARE @Output TABLE(
  Name varchar(max),  
  Value varchar(max)  
  )

SET NOCOUNT ON;
	DECLARE @valid bit = 1
	DECLARE @message varchar(MAX) = ''
	DECLARE @PickerName varchar(30)
	DECLARE @User varchar(30) = ''
	DECLARE @Document varchar(50)
	
	SELECT @PickerName = Value FROM @input WHERE Name = 'PickerName'
	SELECT @message = @PickerName

	IF @PickerName = 'CLEAR PICKER'
	BEGIN
		DELETE FROM Custom_DocumentPicker WHERE DocNumber IN 
		(SELECT SELECTEDNUMBER FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number'))

		DELETE FROM ProcessStepLookupDynamic WHERE [Value] IN 
		(SELECT SELECTEDNUMBER FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number'))

		INSERT INTO custom_DocumentTrackingLog (Document, TrackingStatus, [User], ActivityDate,Comment, DocumentReference)
		SELECT SELECTEDNUMBER, Document.[Status], @PickerName, GETDATE(),'CLEAR ASSIGNMENT FROM WEBDESKTOP', ''
		FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number') 
		INNER JOIN 
		Document On SELECTEDNUMBER = Document.Number
		WHERE Document.[Status] IN ('ENTERED','RELEASED') 

	END
	ELSE
	BEGIN 


		INSERT INTO Custom_DocumentPicker 
		SELECT SELECTEDNUMBER, GETDATE(), @PickerName FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number') 
		INNER JOIN 
		Document On SELECTEDNUMBER = Document.Number
		WHERE Document.[Status] IN ('ENTERED','RELEASED')
		AND SELECTEDNUMBER NOT IN (SELECT DocNumber FROM Custom_DocumentPicker WHERE Picker = @PickerName)

		INSERT INTO ProcessStepLookupDynamic(Value,Description,Process,ProcessStep,UserName) 
		SELECT SELECTEDNUMBER, 
		SELECTEDNUMBER,'PICKING', 'Document', @PickerName
		FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number')
		INNER JOIN 
		Document On SELECTEDNUMBER = Document.Number
		WHERE Document.[Status] IN ('ENTERED','RELEASED')
		AND SELECTEDNUMBER NOT IN (SELECT [Value] FROM ProcessStepLookupDynamic WHERE UserName = @PickerName)

		INSERT INTO custom_DocumentTrackingLog (Document, TrackingStatus, [User], ActivityDate,Comment, DocumentReference)
		SELECT SELECTEDNUMBER, Document.[Status], @PickerName, GETDATE(),'ASSIGNED FROM WEBDESKTOP', ''
		FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number') 
		INNER JOIN 
		Document On SELECTEDNUMBER = Document.Number
		WHERE Document.[Status] IN ('ENTERED','RELEASED') 


	END

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid

	SELECT * FROM @Output
GO



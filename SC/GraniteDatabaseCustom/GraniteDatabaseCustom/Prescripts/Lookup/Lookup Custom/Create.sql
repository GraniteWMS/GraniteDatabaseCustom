
INSERT INTO [dbo].[Process]
           ([isActive],[Name],[Description],[Type],[IntegrationMethod],[IntegrationIsActive],[IntegrationPost])
     VALUES
           (1,'LOOKUPCUSTOM','Lookup Custom','CUSTOM',NULL,0,0)
GO


INSERT INTO [dbo].[ProcessStep]
           ([Name],[Description],[ProcessIndex] ,[isActive] ,[Required],[NextIndex] ,[Process] ,[PreScript] ,[Version])
VALUES
           ('LookupType','Lookup Type',0,1,1,1,'LOOKUPCUSTOM',NULL,1)

INSERT INTO [dbo].[ProcessStep]
           ([Name],[Description],[ProcessIndex] ,[isActive] ,[Required],[NextIndex] ,[Process] ,[PreScript] ,[Version])
VALUES
           ('LookupValue','Lookup Value',0,1,1,1,'LOOKUPCUSTOM','PrescriptLookupCustomLookupValue',1)

INSERT INTO [dbo].[ProcessStepLookup]
           ([Value],[Description],[Process],[ProcessStep],[UserName])
     VALUES
           ('MASTERITEM', 'Master Item', 'LOOKUPCUSTOM','LookupType',NULL)
INSERT INTO [dbo].[ProcessStepLookup]
           ([Value],[Description],[Process],[ProcessStep],[UserName])
     VALUES
           ('LOCATION', 'Location Barcode', 'LOOKUPCUSTOM','LookupType',NULL)
INSERT INTO [dbo].[ProcessStepLookup]
           ([Value],[Description],[Process],[ProcessStep],[UserName])
     VALUES
           ('TRACKINGENTITY', 'Tracking Entity', 'LOOKUPCUSTOM','LookupType',NULL)

GO


INSERT INTO [dbo].[ProcessMembers]
			([Process],[UserGroup],[ProcessIndex])
     VALUES
           ('LOOKUPCUSTOM','DEFAULT',900)
GO



/****** Object:  StoredProcedure [dbo].[PrescriptLookupCustomLookupValue]    Script Date: 10/31/2022 4:07:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PrescriptLookupCustomLookupValue]
    (
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

DECLARE @LookupType varchar(50) = (SELECT Value FROM @input WHERE Name = 'LookupType')
DECLARE @StepInput varchar(50) = (SELECT Value FROM @input WHERE Name = 'StepInput')

DECLARE @excludeLocation varchar(10) = '%REC%'
DECLARE @sql varchar(max)
DECLARE @OrderBy varchar(max)
DECLARE @html varchar(max)

IF @LookupType = 'LOCATION'
BEGIN
	IF EXISTS(SELECT ID FROM [Location] WHERE Barcode = @StepInput)
	BEGIN

		SELECT @sql = CONCAT('SELECT TE.Barcode, MI.Code, CONVERT(varchar(20),TE.Qty) as Qty, TE.Batch, CONVERT(varchar(12),ISNULL(TE.ExpiryDate,''''),7) as Expiry, 
		''LightYellow'' as RowColor
				FROM TrackingEntity TE INNER JOIN 
				MasterItem MI on TE.MasterItem_id = MI.ID INNER JOIN
				[Location] L on TE.Location_ID = L.ID
				WHERE  L.Barcode= ''',@StepInput, ''' and TE.InStock = 1 and TE.Qty > 0 and L.NonStock = 0')

		SELECT @OrderBy = 'ORDER BY Code Asc'

		EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT
		SELECT @Message = 'Location lookup'

	END
	ELSE
	BEGIN
		SELECT @Valid = 0
		SELECT @Message = 'Location Does not Exist'
	END


END
IF @LookupType = 'MASTERITEM'
BEGIN
	IF EXISTS(SELECT ID FROM MasterItem WHERE Code = @StepInput)
	BEGIN

		SELECT @sql = CONCAT('SELECT TE.Barcode, L.Name, CONVERT(varchar(20),TE.Qty) as Qty, TE.Batch, CONVERT(varchar(12),ISNULL(TE.ExpiryDate,''''),7) as Expiry, ''LightYellow'' as RowColor
				FROM TrackingEntity TE INNER JOIN 
				MasterItem MI on TE.MasterItem_id = MI.ID INNER JOIN
				[Location] L on TE.Location_ID = L.ID
				WHERE MI.Code= ''',@StepInput, ''' and L.Barcode NOT LIKE ''', @excludeLocation, ''' and TE.InStock = 1 and TE.Qty > 0 and L.NonStock = 0')

		SELECT @OrderBy = 'ORDER BY Name Asc'

		EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT
		SELECT @Message = 'MasterItem lookup'


	END
	ELSE
	BEGIN
		SELECT @Valid = 0
		SELECT @Message = 'MasterItem Does not Exist'
	END


END
IF @LookupType = 'TRACKINGENTITY'
BEGIN
	IF EXISTS(SELECT ID FROM TrackingEntity WHERE Barcode = @StepInput)
	BEGIN

		SELECT @sql = CONCAT('SELECT TE.Barcode, MI.Code, L.Name, CONVERT(varchar(20),TE.Qty) as Qty, TE.Batch, CONVERT(varchar(12),ISNULL(TE.ExpiryDate,''''),7) as Expiry, 
				CASE TE.Instock WHEN 1 THEN ''INSTOCK'' ELSE ''SCRAPPED'' END AS Status, CASE TE.Instock WHEN 1 THEN ''Grey'' ELSE ''LightYellow'' END AS RowColor
				FROM TrackingEntity TE INNER JOIN 
				MasterItem MI on TE.MasterItem_id = MI.ID INNER JOIN
				[Location] L on TE.Location_ID = L.ID
				WHERE TE.Barcode= ''',@StepInput, '''')

		SELECT @OrderBy = 'ORDER BY Barcode Asc'

		EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT
		SELECT @Message = 'Tracking Entity lookup'


	END
	ELSE
	BEGIN
		SELECT @Valid = 0
		SELECT @Message = 'MasterItem Does not Exist'
	END


END

INSERT INTO @Output
SELECT 'Instruction', @html

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT *
FROM @Output


GO


GO



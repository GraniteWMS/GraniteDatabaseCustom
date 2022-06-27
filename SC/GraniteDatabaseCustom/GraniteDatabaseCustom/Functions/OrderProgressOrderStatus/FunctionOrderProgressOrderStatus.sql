

/****** Object:  StoredProcedure [dbo].[FunctionOrderProgressOrderStatus]    Script Date: 6/27/2022 8:04:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FunctionOrderProgressOrderStatus] (
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
	DECLARE @status varchar(30)
	DECLARE @User varchar(30) = ''
	DECLARE @Document varchar(50)

	SELECT @status = Value FROM @input WHERE Name = 'Status'
	SELECT @message = @status

	UPDATE Document SET [Status] = @status WHERE Number IN  (SELECT  Number FROM OpenJson(@JsonInput) WITH (NUMBER varchar(50) '$.Number'))
	INSERT INTO custom_DocumentTrackingLog (Document,[Version],TrackingStatus,[User],ActivityDate,Comment)
	SELECT  Number,1,@status,@User,getdate(),'Status Changed from Desktop Function' 
	FROM OpenJson(@JsonInput) WITH (NUMBER varchar(50) '$.Number')

	IF @status <> 'RELEASED'
	BEGIN

		DELETE FROM ProcessStepLookupDynamic WHERE [Value] IN 
		(SELECT SELECTEDNUMBER FROM OpenJson(@JsonInput) WITH (SELECTEDNUMBER varchar(50) '$.Number'))

	END

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid

	SELECT * FROM @Output
GO


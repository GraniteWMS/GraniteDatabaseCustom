
/****** Object:  StoredProcedure [dbo].[PreScriptPickingDocument]    Script Date: 7/10/2022 2:03:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[PrescriptManufactureDocument] (
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
DECLARE @stepInput varchar(MAX)  = (SELECT Value FROM @input WHERE Name = 'StepInput')
DECLARE @Document varchar(50)
DECLARE @User varchar(50) = (SELECT Value from @input WHERE Name = 'User')
DECLARE @Printer varchar(50) = (SELECT Value from @input WHERE Name = 'PrinterName')
DECLARE @MasterItemid bigint
DECLARE @MasterItemcode bigint
DECLARE @DocumentStatus varchar(50)

SELECT @DocumentStatus = Document.[Status] FROM Document WHERE Number = @stepInput

IF isnull(@DocumentStatus,'') IN ('RELEASED')
BEGIN
	SELECT TOP 1 @MasterItemid = MasterItem.ID, @MasterItemCode = Code FROM Document INNER JOIN
	DocumentDetail ON Document.ID = DocumentDetail.Document_id INNER JOIN
	MasterItem On DocumentDetail.Item_id = MasterItem.ID
	WHERE Document.Number = @stepInput and DocumentDetail.[Type] = 'OUTPUT'
    ORDER BY DocumentDetail.LineNumber 

	INSERT INTO @Output
	SELECT 'MasterItem',@MasterItemcode
	SELECT @valid = 1
END
ELSE
BEGIN
	IF isnull(@DocumentStatus,'')= ''		--Document Not found
		SELECT @message = 'Document is not found.'
	ELSE
		SELECT @message = 'Document is not in Status RELEASED'
	
	SELECT @valid = 0
END


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output
GO



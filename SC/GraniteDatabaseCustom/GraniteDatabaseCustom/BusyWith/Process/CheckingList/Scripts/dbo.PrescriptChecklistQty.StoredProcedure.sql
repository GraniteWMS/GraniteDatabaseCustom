CREATE PROCEDURE [dbo].[PrescriptChecklistQty] (
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
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' 

DECLARE @User varchar(30)
DECLARE @User_id bigint
DECLARE @Document varchar(30)
DECLARE @Document_id bigint
DECLARE @sql varchar(max)
DECLARE @html varchar(max)
DECLARE @htmlheader varchar(max)
DECLARE @htmldetail varchar(max)
DECLARE @OrderBy varchar(max)
DECLARE @MasterItem varchar(50)
DECLARE @Location varchar(30)
DECLARE @MasterItem_id bigint

DECLARE @url varchar(500) = 'http://josh-laptop:40086/outbound/pack'
DECLARE @Body varchar(max)
DECLARE @HttpStatus varchar(60)
DECLARE @HttpStatusText varchar(60)
DECLARE @HttpResponseText varchar(max)

SELECT @User = [Value] FROM @input WHERE [Name] = 'User'
SELECT @User_id = ID FROM [$(GraniteDatabase)].dbo.Users WHERE Name = @User
SELECT @Document = [Value] FROM @input WHERE [Name] = 'Document'
SELECT @Location = [Value] FROM @input WHERE [Name] = 'Location'
SELECT @Document_id = ID FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @Document
SELECT @MasterItem = [Value] FROM @input WHERE [Name] = 'MasterItem'
SELECT @MasterItem_id = ID FROM [$(GraniteDatabase)].dbo.MasterItem WHERE Code = @MasterItem

IF ISNUMERIC(@stepInput) = 0 
BEGIN
	SELECT @valid = 0
	SELECT @message = 'Qty must be a number'
END
ELSE
BEGIN
	SELECT @valid = 1

	--Uncomment this for no transaction:

	--UPDATE DocumentDetail
	--SET PackedQty = ISNULL(PackedQty, 0) + @stepInput
	--WHERE ID = (SELECT TOP 1 ID 
	--		FROM DocumentDetail 
	--		WHERE Item_id = @MasterItem_id AND Document_id = @Document_id)
	
	--OR uncomment this to use webservice to create Pack transactions:

	--SELECT @Body = 
	--(SELECT @Document as DocumentNumber, @Location as LocationBarcode, @Document as CarryingEntityBarcode, @MasterItem as IdentifierCode, @stepInput as Qty, @User_id as UserID, 'CHECKLIST' as ProcessName FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

	--EXEC dbo.HTTP_POST_JSON @url, @Body, @HttpStatus OUTPUT, @HttpStatusText OUTPUT, @HttpResponseText OUTPUT

	--SELECT @HttpStatus, @HttpStatusText, @HttpResponseText

	--IF @HttpStatus <> 200
	--BEGIN
	--	SELECT @message = [value]
	--	FROM OPENJSON((SELECT [value] 
	--					FROM OPENJSON(@HttpResponseText)
	--					WHERE [key] = 'ResponseStatus'))
	--	WHERE [key] = 'Message'
		
	--	SELECT @valid = 0
	--END
	--ELSE
	--BEGIN
	--	SELECT @message = 'Successful'
	--END


	DELETE FROM [$(GraniteDatabase)].dbo.ProcessStepLookupDynamic
	WHERE Process = 'CHECKLIST' AND ProcessStep = 'MasterItem' AND UserName = @User

	INSERT INTO [$(GraniteDatabase)].dbo.ProcessStepLookupDynamic (Value, Description, Process, ProcessStep, UserName)
	SELECT MasterItem.Code, CONCAT('Item: ',Code, ' ', MasterItem.Description, ' Qty: ', SUM(ISNULL(ActionQty, 0)) - SUM(ISNULL(PackedQty, 0))), 'CHECKLIST', 'MasterItem', @User
	FROM [$(GraniteDatabase)].dbo.DocumentDetail INNER JOIN
	[$(GraniteDatabase)].dbo.MasterItem ON DocumentDetail.Item_id = MasterItem.ID
	WHERE Document_id = @Document_id
	GROUP BY Code, Description
	HAVING SUM(ISNULL(ActionQty, 0)) - SUM(ISNULL(PackedQty, 0)) > 0

	SELECT @sql = CONCAT('SELECT Number as Document, TradingPartnerDescription as Customer, '''' as RowColor
								FROM Document
								WHERE ID = ', @Document_id)

	EXEC dbo.SqlToHtml @sql, NULL, @htmlheader OUTPUT

	SELECT @sql = CONCAT('SELECT MasterItem.Description, SUM(ISNULL(ActionQty, 0)) as Picked, SUM(ISNULL(PackedQty, 0)) as Checked,
							CASE WHEN SUM(ISNULL(PackedQty, 0)) = SUM(ISNULL(ActionQty, 0)) THEN ''green''
								ELSE ''orange'' END as RowColor
							FROM DocumentDetail INNER JOIN
							MasterItem ON DocumentDetail.Item_id = MasterItem.ID
							WHERE Document_id = ',@Document_id,'
							GROUP BY MasterItem.Description')


	EXEC dbo.SqlToHtml @sql, NULL, @htmldetail OUTPUT

	SELECT @html = CONCAT(@htmlheader, @htmldetail)

	INSERT INTO @Output
	SELECT 'Instruction', @html
END


	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output
GO

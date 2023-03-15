CREATE PROCEDURE [dbo].[PrescriptChecklistDocument] (
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
DECLARE @Document_id bigint
DECLARE @sql varchar(max)
DECLARE @html varchar(max)
DECLARE @htmlheader varchar(max)
DECLARE @htmldetail varchar(max)
DECLARE @OrderBy varchar(max)

SELECT @User = [Value] FROM @input WHERE [Name] = 'User'

IF EXISTS(SELECT * FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @stepInput)
BEGIN
	SELECT @Document_id = ID FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @stepInput
	
	IF EXISTS(SELECT * FROM [$(GraniteDatabase)].dbo.DocumentDetail WHERE Document_id = @Document_id AND ISNULL(ActionQty, 0) > ISNULL(PackedQty, 0))
	BEGIN
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

		SELECT @valid = 1
	END
	ELSE
	BEGIN
		SELECT @valid = 0
		SELECT @message = 'No picked lines that have not been confirmed'
	END
END
ELSE
BEGIN
	SELECT @valid = 0
	SELECT @message = 'Document not found'
END

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output
GO
CREATE PROCEDURE [dbo].[PrescriptChecklistMasterItem] (
   @input dbo.ScriptInputParameters READONLY --List of [Name, Value]
)
AS
--##START dont modify
--Return table. Table containing stepnames and values.
--NOTE: also include variable @valid, @message and @stepInput, with there values.
--The Output table is same structure as the ScriptInputParameters the @input
DECLARE @Output TABLE(
  Name varchar(max),  --Name represents the stepname
  Value varchar(max)  --Value the value of the step
  )

SET NOCOUNT ON;

--declare standard variables to be set in return table
DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' --set your variable to the incoming step input value 
--##END

--##your logic goes here
DECLARE @User varchar(30)
DECLARE @Document varchar(30)
DECLARE @Document_id bigint
DECLARE @sql varchar(max)
DECLARE @html varchar(max)
DECLARE @htmlheader varchar(max)
DECLARE @htmldetail varchar(max)
DECLARE @OrderBy varchar(max)

SELECT @User = [Value] FROM @input WHERE [Name] = 'User'
SELECT @Document = [Value] FROM @input WHERE [Name] = 'Document'
SELECT @Document_id = ID FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @Document

SELECT @valid = 1

IF @stepInput = 'REFRESH'
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

	SELECT @valid = 0
	SELECT @message = 'REFRESHED'
END

--##your logic ends here

--DONT MODIFY - these values are not optional and should always be in your @Output table
----set standard output values for @message, @valid and @stepInput
	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

----return values Output
	SELECT * FROM @Output
GO

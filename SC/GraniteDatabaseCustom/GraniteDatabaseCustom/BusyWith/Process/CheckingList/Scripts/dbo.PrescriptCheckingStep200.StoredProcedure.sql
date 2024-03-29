CREATE PROCEDURE [dbo].[PrescriptCheckingStep200] (
   @input dbo.ScriptInputParameters READONLY 
)
AS

DECLARE @Output TABLE(
  Name varchar(max), 
  Value varchar(max)  
  )

SET NOCOUNT ON;

DECLARE @valid bit = 1
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput'

DECLARE @Document varchar(30)
DECLARE @Document_id bigint
DECLARE @sql varchar(max)
DECLARE @html varchar(max)
DECLARE @htmlheader varchar(max)
DECLARE @htmldetail varchar(max)

SELECT @Document = [Value] FROM @input WHERE [Name] = 'Document'
SELECT @Document_id = ID FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @Document

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


	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output
GO

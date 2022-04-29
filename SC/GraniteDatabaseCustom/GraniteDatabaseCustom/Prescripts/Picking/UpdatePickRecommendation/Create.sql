CREATE PROCEDURE  [dbo].[PreScriptPickingDocument_UpdatePickRecommendation] (
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
DECLARE @stepInput varchar(MAX) 
DECLARE @Document varchar(50)


SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' 

IF (SELECT Document.[Status] FROM Document WHERE Number = @stepInput) IN ('ENTERED', 'RELEASED')
BEGIN

	UPDATE DocumentDetail SET Comment = isnull('Pick from:' + (SELECT TOP 1  L.Barcode + ' - TE:' +  TE.Barcode
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID
	WHERE TE.InStock = 1 AND TE.OnHold = 0 AND TE.Qty > 0 AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	ORDER BY L.[Type],TE.ExpiryDate,TE.CreatedDate),'ZZZ-No Stock')
	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
	WHERE Document.Number = @stepInput


	SELECT @message = 'Document pick locations updated'
	SELECT @valid = 1
END
ELSE
BEGIN
	SELECT @message = 'Document is not in Status ENTERED or RELEASED'
	SELECT @valid = 0
END

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output
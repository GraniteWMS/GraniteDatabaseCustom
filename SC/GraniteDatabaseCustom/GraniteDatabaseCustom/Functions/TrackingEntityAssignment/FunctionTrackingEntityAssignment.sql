


CREATE PROCEDURE [dbo].[FunctionTrackingEntityReserve] (
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
	DECLARE @status varchar(30) = 'ALLOCATION'
	DECLARE @User varchar(30) = ''
	DECLARE @Document varchar(50)
	DECLARE @Document_id bigint
	DECLARE @QtyString varchar(20)
	DECLARE @Qty Decimal(19,6)

	SELECT @Document = Value FROM @input WHERE Name = 'Document'
	SELECT @Document_id = ID FROM Document WHERE Number = @Document
	SELECT @QtyString = Value FROM @input WHERE Name = 'Qty'
	SELECT @Qty = CONVERT(Decimal(19,4),@QtyString)
	SELECT @message = @Document + 'Qty' + @QtyString

	--For each Item_id
	--Insert into allocation Table custom_TrckingEntityAllocation
	--INSERT INTO Custom_TrackingEntityAllocation (Date,Document_id, DocumentLine_id, TrackingEntity_id, Qty,Status)
	SELECT @message = Barcode
	--SELECT  getdate(),@Document_id, 1, ID, @Qty, @status
	FROM TrackingEntity WHERE Barcode IN
	 (SELECT  Barcode FROM OpenJson(@JsonInput) WITH (Barcode varchar(50) '$.Barcode'))
	
	UPDATE DocumentDetail SET Comment = 'Allocated:' 
	WHERE Document_id  = @Document_id

	INSERT INTO custom_DocumentTrackingLog (Document,[Version],TrackingStatus,[User],ActivityDate,Comment)
	SELECT  @Document,1,@status,@User,getdate(),'Added to Allocation from Desktop App.' 



	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid

	SELECT * FROM @Output


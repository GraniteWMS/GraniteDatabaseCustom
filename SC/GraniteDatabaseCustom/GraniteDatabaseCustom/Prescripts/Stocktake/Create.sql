

/****** Object:  StoredProcedure [dbo].[PrescriptStocktakeCountTrackingEntity]    Script Date: 2022/11/10 17:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Script to prevent scanning a TrackingEntity Twice in StoctakeCount process.  Add to TrackingEntity step.


CREATE PROCEDURE [dbo].[PrescriptStocktakeCountTrackingEntity] (
   @input dbo.ScriptInputParameters READONLY --List of [Name, Value]
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
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' --set your variable to the incoming step input value 


DECLARE @Qty INT
DECLARE @Session_id bigint
DECLARE @Count int
DECLARE @Location_id bigint
DECLARE @CarryingEntity_id bigint

SELECT @Location_id = ID FROM Location WHERE Barcode = (SELECT [Value] FROM @input WHERE [Name] = 'Location')
SELECT @Session_id = ID FROM StockTakeSession WHERE Name = (SELECT [Value] FROM @input WHERE [Name] = 'Session')
SELECT @Count = [Value] FROM @input WHERE [Name] = 'Count'

IF EXISTS(SELECT ID FROM TrackingEntity WHERE Barcode = @stepInput)
BEGIN
	IF EXISTS(SELECT ID FROM StockTakeLines WHERE Barcode = @stepInput AND StockTakeSession_id = @Session_id)
	BEGIN

			IF @Count = 1 AND (SELECT ISNULL(Count1Qty,0) FROM StockTakeLines WHERE Barcode = @stepInput AND StockTakeSession_id = @Session_id) > 0
			BEGIN
				SELECT @valid = 0
				SELECT @message = CONCAT(@stepInput, ' has already been scanned on count ', @Count)
			END

			IF @Count = 2 AND (SELECT ISNULL(Count2Qty,0) FROM StockTakeLines WHERE Barcode = @stepInput AND StockTakeSession_id = @Session_id) > 0
			BEGIN
				SELECT @valid = 0
				SELECT @message = CONCAT(@stepInput, ' has already been scanned on count ', @Count)
			END

			IF @Count = 3 AND (SELECT ISNULL(Count3Qty,0) FROM StockTakeLines WHERE Barcode = @stepInput AND StockTakeSession_id = @Session_id) > 0
			BEGIN
				SELECT @valid = 0
				SELECT @message = CONCAT(@stepInput, ' has already been scanned on count ', @Count)
			END


	END
END
ELSE IF EXISTS(SELECT * FROM CarryingEntity WHERE Barcode = @stepInput)
BEGIN
	SELECT @CarryingEntity_id = ID FROM CarryingEntity WHERE Barcode = @stepInput

	IF EXISTS(SELECT ID FROM TrackingEntity WHERE BelongsToEntity_id = @CarryingEntity_id AND Barcode NOT IN (SELECT Barcode FROM StockTakeLines WHERE StockTakeSession_id = @Session_id))
	BEGIN
		INSERT INTO StockTakeLines (OpeningQty, Barcode, Location_id, StockTakeSession_id)
		SELECT Qty, Barcode, Location_id, @Session_id
		FROM TrackingEntity 
		WHERE BelongsToEntity_id = @CarryingEntity_id AND Barcode NOT IN (SELECT Barcode FROM StockTakeLines WHERE StockTakeSession_id = @Session_id)
	END

	IF @Count = 1 AND EXISTS(SELECT ID
							FROM StockTakeLines 
							WHERE ISNULL(Count1Qty,0) > 0 AND Barcode IN (SELECT Barcode FROM TrackingEntity WHERE BelongsToEntity_id = @CarryingEntity_id) AND StockTakeSession_id = @Session_id)
	BEGIN
		SELECT @valid = 0
		SELECT @message = CONCAT(@stepInput, ' contains a barcode that has already been scanned on count ', @Count)
	END

	IF @Count = 2 AND EXISTS(SELECT ID
							FROM StockTakeLines 
							WHERE ISNULL(Count2Qty,0) > 0 AND Barcode IN (SELECT Barcode FROM TrackingEntity WHERE BelongsToEntity_id = @CarryingEntity_id) AND StockTakeSession_id = @Session_id)
	BEGIN
		SELECT @valid = 0
		SELECT @message = CONCAT(@stepInput, ' contains a barcode that has already been scanned on count ', @Count)
	END

	IF @Count = 3 AND EXISTS(SELECT ID
							FROM StockTakeLines 
							WHERE ISNULL(Count3Qty,0) > 0 AND Barcode IN (SELECT Barcode FROM TrackingEntity WHERE BelongsToEntity_id = @CarryingEntity_id) AND StockTakeSession_id = @Session_id)
	BEGIN
		SELECT @valid = 0
		SELECT @message = CONCAT(@stepInput, ' contains a barcode that has already been scanned on count ', @Count)
	END
END


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output

GO


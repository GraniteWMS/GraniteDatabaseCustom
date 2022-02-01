
CREATE PROCEDURE [dbo].[PRESCRIPT_STOCKTAKECOUNT_PALLETCONFIRM] (
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
DECLARE @valid bit = 1
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' --set your variable to the incoming step input value 
--##END

--##your logic goes here
	DECLARE @session varchar(30) = (SELECT VALUE FROM @input WHERE Name = 'Session')
	DECLARE @count bigint = (SELECT VALUE FROM @input WHERE Name = 'Count')
	DECLARE @pallet varchar(30) = (SELECT VALUE FROM @input WHERE Name = 'TrackingEntity')
	DECLARE @session_ID bigint = (SELECT TOP 1 ID FROM StockTakeSession WHERE Name = @session)
	DECLARE @pallet_ID bigint = (SELECT TOP 1 ID FROM CarryingEntity WHERE [Barcode] = @pallet)
	
	IF (@stepInput = 'NO')
	BEGIN
		INSERT INTO [Custom_Pallet_Counted] ([AuditDate], [StocktakeSession_id], [CarryEntity_id], [Count]) 
		VALUES (GETDATE(), @session_ID, @pallet_ID, @count)

		SELECT @message = 'Entered count did not match on hand. Please scan each bale on the pallet individually'
	END

	INSERT INTO @Output
		SELECT 'Instruction', '<br>
			<script>
				$("#divDetail").css("display", "");
				$("#textBox").css("display", "");
				$(".form-control").css("display", "");
			</script>
			'

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


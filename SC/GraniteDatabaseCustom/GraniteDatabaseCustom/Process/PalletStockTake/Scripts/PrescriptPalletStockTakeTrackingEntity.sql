
CREATE PROCEDURE [dbo].[PRESCRIPT_STOCKTAKECOUNT_TRACKINGENTITY] (
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
	DECLARE @pallet varchar(30)
	DECLARE @palletID bigint
	DECLARE @StocktakeSession varchar(50)
	DECLARE @StocktakeSessionID bigint
	DECLARE @StocktakeCount bigint
	DECLARE @StocktakeLocation varchar(30)
	SELECT @StocktakeCount = Value FROM @input WHERE Name = 'Count'

	DECLARE @rows varchar(MAX)
	DECLARE @barcode varchar(30)
	DECLARE @qty float
	DECLARE @masterItem varchar(30)
	DECLARE @masterItemID bigint
	DECLARE @masterItemDescrip varchar(50)

	DECLARE @User_id bigint
	DECLARE @Session_id bigint
	DECLARE @Count int

	SELECT @User_id = ID FROM Users WHERE Name = (SELECT [Value] FROM @input WHERE [Name] = 'User')
	SELECT @Session_id = ID FROM StockTakeSession WHERE Name = (SELECT [Value] FROM @input WHERE [Name] = 'Session')
	SELECT @Count = [Value] FROM @input WHERE [Name] = 'Count'
	
	IF EXISTS(SELECT * FROM StockTakeLines WHERE StockTakeSession_id = @Session_id AND Barcode = @stepInput) OR 
		EXISTS(SELECT * FROM StockTakeLines WHERE StockTakeSession_id = @Session_id AND Barcode IN 
																		(SELECT Barcode FROM TrackingEntity WHERE BelongsToEntity_id = (SELECT ID FROM CarryingEntity WHERE Barcode = @stepInput)))
	BEGIN
		IF @Count = 1
		BEGIN
			IF EXISTS(SELECT * FROM StockTakeLines WHERE StockTakeSession_id = @Session_id AND ISNULL(Count1Qty, 0) > 0 AND Barcode = @stepInput)
			BEGIN
				SELECT @valid = 0
				SELECT @message = 'This barcode has already been counted on count 1'
			END
		END
		ELSE IF @Count = 2
		BEGIN
			IF EXISTS(SELECT * FROM StockTakeLines WHERE StockTakeSession_id = @Session_id AND ISNULL(Count2Qty, 0) > 0 AND Barcode = @stepInput)
			BEGIN
				SELECT @valid = 0
				SELECT @message = 'This barcode has already been counted on count 2'
			END
		END
		ELSE IF @Count = 3
		BEGIN
			IF EXISTS(SELECT * FROM StockTakeLines WHERE StockTakeSession_id = @Session_id AND ISNULL(Count3Qty, 0) > 0 AND Barcode = @stepInput)
			BEGIN
				SELECT @valid = 0
				SELECT @message = 'This barcode has already been counted on count 3'
			END
		END

		IF EXISTS (SELECT TOP 1 ID FROM CarryingEntity WHERE Barcode = @stepInput) AND @valid <> 0
		BEGIN
			IF EXISTS(SELECT * FROM TrackingEntity WHERE Qty > 0 AND InStock = 1 AND BelongsToEntity_id = (SELECT ID FROM CarryingEntity WHERE Barcode = @stepInput))
			BEGIN
				SELECT @pallet = @stepInput
				SELECT TOP 1 @palletID = ID FROM CarryingEntity WHERE Barcode = @pallet
				SELECT @StocktakeSession = Value FROM @input WHERE Name = 'Session'
				SELECT @StocktakeCount = Value FROM @input WHERE Name = 'Count'
				SELECT @StocktakeLocation = Value FROM @input WHERE Name = 'Location'
				SELECT @StocktakeSessionID = ID FROM StockTakeSession WHERE Name = @StocktakeSession

				IF EXISTS (SELECT TOP 1 ID FROM Custom_Pallet_Counted WHERE CarryEntity_id = @palletID AND StocktakeSession_id = @StocktakeSessionID AND [Count] = @StocktakeCount)
				BEGIN
					SELECT @valid = 0
					SELECT @message = CONCAT(@pallet,' HAS ALREADY BEEN SCANNED WRONG FOR COUNT: ',@StocktakeCount)
				END
				ELSE
				BEGIN
					DECLARE @counter int = 0

					DECLARE tmp CURSOR LOCAL FOR
					--SELECT FROM StockTakeLines WHERE StockTakeSession_id = @StocktakeSessionID
					SELECT SUM(Qty) AS Qty, MasterItem_id FROM TrackingEntity WHERE BelongsToEntity_id = @palletID AND InStock = 1 AND OnHold = 0 GROUP BY MasterItem_id
					OPEN tmp
					FETCH NEXT FROM tmp INTO @qty, @masterItemID

					WHILE @@FETCH_STATUS = 0

					BEGIN
						SELECT @masterItem = FormattedCode, @masterItemDescrip = [Description] FROM MasterItem WHERE ID = @masterItemID
						SELECT @rows = CONCAT(@rows, '<tr>
														<td style="padding:2px 0px 2px 5px"><div>', @masterItem, '</div>
															<div style="font-size:12px;padding:0px 0px 0px 12px;margin:0px 0px 0px 0px">',@masterItemDescrip,'</div></td>
														<td class="doc" value="',@qty,'" style="width:35%;padding:0px;margin:0px;"><input style="width:100%;height:100%;padding:12px;" value = "0" type="text" name="InputQty',@counter,'"></td>
												</tr>')
						set @counter = @counter+1
						FETCH NEXT FROM tmp INTO @qty, @masterItemID
					END
					CLOSE tmp
					DEALLOCATE tmp	

					INSERT INTO @Output
						SELECT 'Instruction', CONCAT('<style>
							table, input {width: 100%;}
							input {outline: none; border: none;}
							table, th, td {border: 1px solid black;}
							.empty { background-color: rgb(255,173,102); }
							.doc:hover, .doc:hover * { cursor: pointer; background-color: lightblue;}
							#docInput {
									background-image: url("https://cdn2.iconfinder.com/data/icons/font-awesome/1792/search-512.png");
									background-position: -2px -2px;
									background-size: contain;
									background-repeat: no-repeat;
								  width: 100%;
								  font-size: 16px;
								  padding: 12px 20px 12px 42px;
								  border: 1px solid #ddd;
								  margin-bottom: 12px;
								}
						</style>
						<head><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
														<br>
														<a href="http://192.168.1.80:40087/STOCKTAKECOUNT?processName=STOCKTAKECOUNT" class="btn btn-primary" role="button" style="float: right; background-color:grey;">Back to Session <i class="fa fa-refresh"></i></a>
														<br><br>
														<table id="myTable" class="table table-bordered"><tr><th>Item Code</th><th>Input Qty</th></tr>',
														@rows, 
														'</table>
														<button type="button" class="btn btn-success" onclick="verify()" style="width:80%; margin-left:10%">Verify QTY</button>
														<br><br>
								<script>
									function verify()
									{
										var accept = 1;
										var inputElem, givenQty, table, tr, td, i;
										table = document.getElementById("myTable");
										tr = table.getElementsByTagName("tr");
										for (i = 0; i < tr.length; i++) 
										{
											td = tr[i].getElementsByTagName("td")[1];
											if (td) 
											{
												givenQty = td.getAttribute("value");
												var txtValue = td.getElementsByTagName("input")[0].value;
												if (txtValue == givenQty) 
												{
													tr[i].style.display = "none";
												} 
												else 
												{
													accept = 0;
													//tr[i].style.display = "";
													//tr[i].style.backgroundColor = "red";
												}
											}
										}

										if (accept==0)
										{
											alert("NOT ALL QTY MATCHED THE BARCODE");
											Confirmation("No");
										}
										else
										{
											alert("ALL QTYS CORRECT - PALLET COUNTED");
											Confirmation("Yes");
										}
									}
									function notAllowed()
									{
										alert("Cannot Click NEXT For This Step");
									}
									$(document).ready(function() {
										$("#divDetail").css("display", "none");
										//$("#textBox").css("display", "none");
										$("#btnYes").css("display", "none");
										$("#btnNo").css("display", "none");
										//$(".glyphicon-circle-arrow-left").removeAttr("onclick");
										//$(".glyphicon-circle-arrow-left").attr("onclick", "notAllowed()");
										$(".glyphicon-circle-arrow-right").removeAttr("onclick");
										$(".glyphicon-circle-arrow-right").attr("onclick", "notAllowed()");
									});
								</script>')
					SELECT @message = 'CONFIRM QTY FOR EACH ITEM TO CONTINUE'
				END
			END
			ELSE
			BEGIN
				SELECT @valid = 0
				SELECT @message = CONCAT('No TrackingEntities on pallet ', @stepInput)
			END
		END
	END
	ELSE
	BEGIN
		SELECT @valid = 0
		SELECT @message = CONCAT(@stepInput, ' not found in stock take session')
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


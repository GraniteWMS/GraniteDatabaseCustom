CREATE PROCEDURE [dbo].[PrescriptAllocatePickerLoad] (
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

	DECLARE @docNum varchar(30)
	DECLARE @picker varchar(30)
	DECLARE @date datetime
	DECLARE @customer varchar(30)
	DECLARE @rows varchar(MAX)
	DECLARE @counter int = 0

	DELETE FROM ProcessStepLookup WHERE Process = 'ALLOCATEPICKER' AND ProcessStep = 'Picker'
	
	DECLARE tmp CURSOR LOCAL FOR
	SELECT Number, Picker, [Date], TradingPartnerCode FROM Custom_AllocatePickerDocument_View WHERE [Status] = 'RELEASED'
	OPEN tmp
	FETCH NEXT FROM tmp INTO @docNum, @picker, @date, @customer

	WHILE @@FETCH_STATUS = 0

	BEGIN
		SELECT @counter = @counter+1
		IF (ISNULL(@picker, '') = '')
		BEGIN
			SELECT @rows = CONCAT(@rows, '<tr class="empty">
										<td class="doc">', @docNum, '</td><td>', @customer, '</td><td>', @date, '</td><td id="picker',@counter,'">', @picker, '</td>
									</tr>')
		END
		ELSE
		BEGIN
			SELECT @rows = CONCAT(@rows, '<tr>
										<td class="doc">', @docNum, '</td><td>', @customer, '</td><td>', @date, '</td><td id="picker',@counter,'">', @picker, '</td>
									</tr>')
		END
		
		FETCH NEXT FROM tmp INTO @docNum, @picker, @date, @customer
	END
	CLOSE tmp
	DEALLOCATE tmp	

	INSERT INTO @Output
		SELECT 'Instruction', CONCAT('<style>
			table, input {width: 100%;}
			input {outline: none; border: none;}
			table, th, td {border: 1px solid black;}
			.empty { background-color: rgb(255,173,102); }
			.doc:hover { cursor: pointer; background-color: lightblue;}
		</style>
		<head><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>
										<br>
										<a href="http://localhost:40086/CUSTOM?processName=ALLOCATEPICKER" class="btn btn-primary" role="button" style="float: right; background-color:grey;">Reload <i class="fa fa-refresh"></i></a>
										<br><br>
										<table class="table table-bordered"><tr><th>SO Number</th><th>Customer</th><th>Date</th><th>Picker</th></tr>',
										@rows, 
										'</table><br><br>
				<script>
					function notAllowed()
					{
						alert("Previous and Next do not work in this process");
					}
					$' +'document).ready(function() {
						$' +'"#divDetail").css("display", "none");
						$' +'"#textBox").css("display", "none");
						$' +'".glyphicon-circle-arrow-left").removeAttr("onclick");
						$' +'".glyphicon-circle-arrow-left").attr("onclick", "notAllowed()");
						$' +'".glyphicon-circle-arrow-right").removeAttr("onclick");
						$' +'".glyphicon-circle-arrow-right").attr("onclick", "notAllowed()");
					});
					$' +'".doc").click(function(e) {	$' +'"#textBox").val(e.target.innerHTML);
													Next();	
												});
				</script>')

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output

GO

PRINT '############### [PrescriptAllocatePickerLoad] Done ###################'
GO

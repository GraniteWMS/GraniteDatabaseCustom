CREATE PROCEDURE [dbo].[PrescriptAllocatePickerDocument] (
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
	SELECT @docNum = @stepInput
	DECLARE @picker varchar(30)
	DECLARE @date datetime
	DECLARE @customer varchar(30)
	DECLARE @rows varchar(MAX)
	DECLARE @counter int = 0
	
	DECLARE tmp CURSOR LOCAL FOR
	SELECT Number, Picker, [Date], TradingPartnerCode FROM Custom_AllocatePickerDocument_View WHERE Number = @docNum AND [Status] = 'RELEASED'
	OPEN tmp
	FETCH NEXT FROM tmp INTO @docNum, @picker, @date, @customer

	WHILE @@FETCH_STATUS = 0

	BEGIN
		SELECT @counter = @counter+1
		IF (ISNULL(@picker, '') = '')
		BEGIN
			SELECT @rows = CONCAT(@rows, '<tr>
										<td class="doc">', @docNum, '</td><td>', @customer, '</td><td>', @date, '</td><td id="picker',@counter,'">', @picker, '</td>
									</tr>')
		END
		ELSE
		BEGIN
			SELECT @rows = CONCAT(@rows, '<tr>
										<td class="doc">', @docNum, '</td><td>', @customer, '</td><td>', @date, '</td><td id="picker',@counter,'">', @picker, ' 
										<i id="',@picker,'" class="fa fa-trash-o" style="font-size:200%;color:red;float:right;margin-right:5px;"></i></td>
									</tr>')
		END
		FETCH NEXT FROM tmp INTO @docNum, @picker, @date, @customer
	END
	CLOSE tmp
	DEALLOCATE tmp

	DECLARE users CURSOR LOCAL FOR
	SELECT Name FROM Users WHERE UserGroup_id IN (2,3) AND Name NOT IN (SELECT ISNULL(Picker,'') FROM Custom_AllocatePickerDocument_View WHERE Number = @docNum AND [Status] = 'RELEASED')
	OPEN users
	FETCH NEXT FROM users INTO @picker

	WHILE @@FETCH_STATUS = 0

	BEGIN
		IF NOT EXISTS(SELECT TOP 1 ID FROM ProcessStepLookup WHERE Value = @picker AND Process = 'ALLOCATEPICKER' AND ProcessStep = 'Picker')
		BEGIN
			INSERT INTO ProcessStepLookup (Value,Description,Process,ProcessStep,UserName) VALUES (@picker, @picker, 'ALLOCATEPICKER', 'Picker', NULL)
		END
		FETCH NEXT FROM users INTO @picker
	END
	CLOSE users
	DEALLOCATE users

	INSERT INTO @Output
		SELECT 'Instruction', CONCAT('<style>
			table, input {width: 100%;}
			input {outline: none; border: none;}
			table, th, td {border: 1px solid black;}
			.fa-trash-o:hover { cursor: pointer; background-color: lightblue;}
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
						$' +'"#textBox").css("display", "none");
						$' +'"#divDetail").css("display", "none");
						$' +'".glyphicon-circle-arrow-left").removeAttr("onclick");
						$' +'".glyphicon-circle-arrow-left").attr("onclick", "notAllowed()");
						$' +'".glyphicon-circle-arrow-right").removeAttr("onclick");
						$' +'".glyphicon-circle-arrow-right").attr("onclick", "notAllowed()");
					});
					$' +'".fa-trash-o").click(function(e) {	OptionNext(e.target.id);	});	
						
				</script>	
					')

	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output

GO

PRINT '############### [PrescriptAllocatePickerDocument] Done ###################'
GO

CREATE PROCEDURE [dbo].[PreScriptOrderCheckDocumentDisplayAccpacStatus]
	(
	@input dbo.ScriptInputParameters READONLY
)
AS

DECLARE @Output TABLE(
	Name varchar(max),
	Value varchar(max)
  )

SET NOCOUNT ON;

DECLARE @Filter varchar(30) = ''
-- SELECT @Filter = UPPER(VALUE) FROM @input WHERE NAME = 'Filter'
-- DECLARE @User varchar(30)
-- SELECT @User = VALUE
-- FROM @input
-- WHERE NAME = 'User'

DECLARE @valid bit
DECLARE @message varchar(MAX)

DECLARE @Document varchar(30)
SELECT @Document = UPPER(Value) FROM @input WHERE Name = 'StepInput'
DECLARE @Document_id BIGINT
DECLARE @Shipment VARCHAR(30)
DECLARE @ShiDate varchar(10)
DECLARE @LastInvNum varchar(10)
DECLARE @CaseCount Decimal(19,4), @TotalOrderCaseCount Decimal(19,4)

DECLARE @htmlTableRows varchar(MAX)
Declare @Instruction VARCHAR(MAX)

SELECT @Document_id = ID FROM Document WHERE Number = @Document

--todo change ERP database name [ACCPAC]
SELECT TOP 1
	@ShiDate = CONVERT(varchar(10),SHIDATE), @Shipment =  SHINUMBER, @LastInvNum = LASTINVNUM
FROM [ACCPAC].dbo.[OESHIH]
WHERE ORDNUMBER = @Document
ORDER BY SHIUNIQ DESC

SELECT @CaseCount = SUM(ActionQty),  @TotalOrderCaseCount = SUM(ActionQty)
FROM Document Inner Join
	DocumentDetail on DocumentDetail.Document_id = Document.ID Inner Join
	MasterItem on DocumentDetail.Item_id = MasterItem.ID
WHERE Document.Number = @Document

--IF @Filter = '' or @Filter = 'ALL' or @Filter = 'A'
--BEGIN

SELECT @htmlTableRows = COALESCE(@htmlTableRows + '<tr>
			<td>'+ CASE WHEN DocumentDetail.ActionQty = 0 THEN '<strike>' ELSE '' END
			+
			RTRIM(SUBSTRING(MasterItem.[Description],1,50)) + 
			CASE WHEN DocumentDetail.ActionQty = 0 THEN '</strike>' ELSE '' END
			+
			'</td>
			<td>'+ CONVERT(varchar(20),DocumentDetail.ActionQty) + '</td>
			<td>'+ CONVERT(varchar(20),DocumentDetail.Qty) + '</td>
			<td>'+ [Code] + '</td>
			</tr>','<tr>
			<td>'+ CASE WHEN DocumentDetail.ActionQty = 0 THEN '<strike>' ELSE '' END
			+
			RTRIM(SUBSTRING(MasterItem.[Description],1,50)) + 
			CASE WHEN DocumentDetail.ActionQty = 0 THEN '</strike>' ELSE '' END
			+
			'</td>
			<td>'+ CONVERT(varchar(20),DocumentDetail.ActionQty) + '</td>
			<td>'+ CONVERT(varchar(20),DocumentDetail.Qty) + '</td>
			<td>'+ [Code] + '</td>
			</tr>')
FROM Document Inner Join
	DocumentDetail on DocumentDetail.Document_id = Document.ID Inner Join
	MasterItem on DocumentDetail.Item_id = MasterItem.ID
WHERE Document.Number = @Document
ORDER BY DocumentDetail.ActionQty DESC
--END

----------This is used to implement departmental filters
--ELSE
--BEGIN

----Set these filters in the ProcessStepLookup
--	IF @Filter = 'F' or @Filter = 'FROZEN' SET @Filter = 'FROZEN'
--	IF @Filter = 'C' or @Filter = 'CANDY' SET @Filter = 'CANDY'
--	IF @Filter = 'D' or @Filter = 'DRY' SET @Filter = 'DRY'
--	IF @Filter = 'R' or @Filter = 'REFRIG' SET @Filter = 'REFRIG'

--	SELECT @CaseCount = SUM(ActionQty) FROM Document Inner Join 
--	DocumentDetail on DocumentDetail.Document_id = Document.ID  Inner Join
--	MasterItem on DocumentDetail.Item_id = MasterItem.ID
--	WHERE Document.Number = @Document 
--	AND MasterItem.Category = @Filter

--	SELECT @htmlTableRows = COALESCE(@htmlTableRows + '<tr>
--			<td>'+ CASE WHEN DocumentDetail.ActionQty = 0 THEN '<strike>' ELSE '' END
--			+
--			RTRIM(SUBSTRING(MasterItem.[Description],1,50)) + 
--			CASE WHEN DocumentDetail.ActionQty = 0 THEN '</strike>' ELSE '' END
--			+
--			'</td>
--			<td>'+ CONVERT(varchar(20),DocumentDetail.ActionQty) + '</td>
--			<td>'+ CONVERT(varchar(20),DocumentDetail.Qty) + '</td>
--			<td>'+ [Code] + '</td>
--			</tr>','<tr>
--			<td>'+ CASE WHEN DocumentDetail.ActionQty = 0 THEN '<strike>' ELSE '' END
--			+ RTRIM(SUBSTRING(MasterItem.[Description],1,50)) + 
--			CASE WHEN DocumentDetail.ActionQty = 0 THEN '</strike>' ELSE '' END
--			+ 
--			'</td>
--			<td>'+ CONVERT(varchar(20),DocumentDetail.ActionQty) + '</td>
--			<td>'+ CONVERT(varchar(20),DocumentDetail.Qty) + '</td>
--			<td>'+ [Code] + '</td>
--			</tr>') FROM Document Inner Join
--	DocumentDetail on DocumentDetail.Document_id = Document.ID  Inner Join
--	MasterItem on DocumentDetail.Item_id = MasterItem.ID
--	WHERE Document.Number = @Document 	
--	AND MasterItem.Category = @Filter
--	ORDER BY DocumentDetail.ActionQty DESC
--END

SELECT @Instruction = '<head><title>Order Table</title></head>
	<body>
      <table border = "1">
	   <caption>' + 'FILTER=' + @Filter + '| Filter Count:' + CONVERT(Varchar(20), @CaseCount ) + ' of Total Case count: '  + Convert(Varchar(20),@TotalOrderCaseCount) +'</caption>
		<tr>
            <th>Item Description</th>
            <th>Picked</th>
            <th>Ordered</th>
			<th>Code</th>
       </tr>' +  @htmlTableRows+ ' </table> </body>'

--INSERT INTO custom_DocumentTrackingLog(Document,TrackingStatus,[User],ActivityDate,Comment, IntegrationReference)
--VALUES (@Document,'OrderChecking',@User,getdate(),'View Order','')

SELECT @valid = 1
SELECT @message = 'Last Shipment Number:  ' + isnull(@Shipment,'NOT POSTED') + ' | Shipdate: ' + isnull(@ShiDate,'---------') +  ' | LastInvoice: ' + isnull(@LastInvNum,'---------') +  '   | '

INSERT INTO @Output
SELECT 'Instruction', @Instruction
INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @Document

SELECT *
FROM @Output

GO
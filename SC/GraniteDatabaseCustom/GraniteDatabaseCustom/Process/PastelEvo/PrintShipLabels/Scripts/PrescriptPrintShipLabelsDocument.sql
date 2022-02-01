CREATE PROCEDURE [dbo].[PrescriptPrintShipLabelsDocument]
	(
	@input dbo.ScriptInputParameters READONLY
)
AS

DECLARE @Output TABLE(
	Name varchar(max),
	Value varchar(max)
  )

SET NOCOUNT ON;

DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @Instruction varchar(max)
DECLARE @StepInput varchar(MAX) = (SELECT Value FROM @input WHERE Name = 'StepInput')
DECLARE @User varchar(50) = (SELECT Value FROM @input WHERE Name = 'User')
DECLARE @Printer varchar(50) = (Select Value From @input WHERE Name = 'PrintName')

DECLARE @Document varchar(30) = (SELECT UPPER(Value) FROM @input WHERE Name = 'StepInput')
DECLARE @Document_id BIGINT
DECLARE @CaseCount Decimal(19,4), @TotalOrderCaseCount Decimal(19,4)

SELECT @Document_id = ID FROM Document WHERE Number = @Document

SELECT @CaseCount = SUM(ActionQty),  @TotalOrderCaseCount = SUM(ActionQty)
FROM Document Inner Join
	DocumentDetail on DocumentDetail.Document_id = Document.ID Inner Join
	MasterItem on DocumentDetail.Item_id = MasterItem.ID
WHERE Document.Number = @Document

DECLARE @Customer varchar(200)
DECLARE @Orderdate varchar(20)
DECLARE @DeliveryDate varchar(20)
DECLARE @ExtOrderNumber  varchar(100)
DECLARE @cContact varchar(200)	
DECLARE @ShpAddr1 varchar(200) 
DECLARE @ShpAddr2 varchar(200) 
DECLARE @ShpAddr3 varchar(200) 

SELECT @Customer = CUSTOMER, @cContact = SHPCONTACT, @ShpAddr1 = SHPADDR1, @ShpAddr2 =  SHPADDR2, @ShpAddr3 = SHPADDR3,
@OrderDate = OrderDate,@DeliveryDate= DeliveryDate,  @ExtOrderNumber = ExtOrderNum
FROM Label_ShipLabel
WHERE Number = @Document

--SELECT @Instruction = '<head><title>Shipping Details</title></head>
--	<body>
--	   <caption>' + ' Count:' + CONVERT(Varchar(20), @CaseCount ) + ' of Total count: '  + Convert(Varchar(20),@TotalOrderCaseCount) +'</caption>
--		<p>
--            <th>Customer</th>
--            <th>Address</th>
--            <th>City</th>
--       </p></body>'

SELECT @valid = 1
SELECT @message = ''

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
PRINT '############### [PrescriptPrintShipLabelsQty] Done ###################'
GO
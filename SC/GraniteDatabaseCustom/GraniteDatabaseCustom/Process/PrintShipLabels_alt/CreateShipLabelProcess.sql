GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

:setvar GraniteDatabaseName "GraniteDatabaseName"
:setvar ERPDatabaseName "ERPDatabaseName"
GO
:On Error exit
GO

USE [$(GraniteDatabaseName)]
GO

-- Notes: Process and Steps

INSERT [$(GraniteDatabaseName)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'PRINTSHIPLABELS', N'PRINTSHIPLABELS', N'CUSTOM', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO
INSERT [$(GraniteDatabaseName)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Document', N'Document', 0, 1, 1, NULL, 1, N'PRINTSHIPLABELS', N'PrescriptPrintShipLabelsDocument')
GO
INSERT [$(GraniteDatabaseName)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Qty', N'Qty of Labels', 1, 1, 1, NULL, 0, N'PRINTSHIPLABELS', N'PrescriptPrintShipLabelsQty')
GO

PRINT '############### Process and Steps Done ###################'

-- Notes: Prescript - PrescriptPrintShipLabelsQty
GO
CREATE PROCEDURE [dbo].[PrescriptPrintShipLabelsQty] (
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
DECLARE @stepInput varchar(MAX) 
	SELECT @stepInput = UPPER(Value) FROM @input WHERE Name = 'StepInput' 
DECLARE @User varchar(30)
	SELECT @User = VALUE FROM @input WHERE NAME = 'User'
DECLARE @Document varchar(50)
	SELECT @Document = VALUE FROM @input WHERE Name = 'Document'
DECLARE @Printer varchar(20)
	SELECT @Printer = UPPER(Value) FROM @input WHERE Name = 'PrinterName' 
	IF ISNULL(@Printer,'') = '' SET @Printer = 'Z2'
	
IF ISNUMERIC(@stepInput) = 1
	IF CONVERT(Int,@stepInput) <=50
	BEGIN
		SELECT @valid = 1
		SELECT @message = 'Label inserted into Printing Queue'
		INSERT INTO [$(GraniteDatabaseName)].dbo.LabelPrintQueue (DateQueued, LabelFormat, LabelParameter1, LabelParameter2, QuantityofLabels, Printer, Status, [User])
		SELECT getdate(),'SHIPLABEL.BTW', @Document,'', CONVERT(INT,@stepInput), @Printer, 'ENTERED', @User
	END
	ELSE
	BEGIN
		SELECT @valid = 0
		SELECT @message = 'Number of Labels must be less than 50'
	END
ELSE
BEGIN
	SELECT @valid = 0
	SELECT @message = 'Number of Labels must be a number'
END	
	
	INSERT INTO @Output
	SELECT 'Instruction', '<br>'
	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

	SELECT * FROM @Output
GO

PRINT '############### [PrescriptPrintShipLabelsQty] Done ###################'

-- Notes: Prescript - PrescriptPrintShipLabelsDocument
GO
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

DECLARE @Document varchar(30) = (SELECT  UPPER(Value) FROM @input WHERE Name = 'StepInput')
DECLARE @Document_id BIGINT
DECLARE @CaseCount Decimal(19,4), @TotalOrderCaseCount Decimal(19,4)

SELECT @Document_id = ID FROM Document WHERE Number = @Document

SELECT @CaseCount = SUM(ActionQty),  @TotalOrderCaseCount = SUM(ActionQty)
FROM [$(GraniteDatabaseName)].dbo.Document Inner Join
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

-- Notes: SQL view - Label_ShipLabel
GO
CREATE VIEW [dbo].[Label_ShipLabel]
AS
SELECT  RTRIM(cAccountName) AS CUSTOMER, RTRIM(Address1) AS SHPADDR1, '' AS SHIPVIA, RTRIM(cContact) AS SHPNAME, 
		RTRIM(Address2) AS SHPADDR2, RTRIM(Address3) AS SHPADDR3, RTRIM(Address4) AS SHPADDR4, 
        '' AS SHPCITY, '' AS SHPSTATE, '' AS SHPCOUNTRY, cContact AS SHPCONTACT, '' AS SHPZIP, '' AS ERPLocation, 
		OrderNum AS Number, '' AS STOP, '' AS ROUTE, '' AS Territory, '' AS Expr1, InvNumber, GrvNumber, Description, 
        InvDate, OrderDate, DueDate, DeliveryDate, RTRIM(Address5) AS SHPADDR5, RTRIM(Address6) AS SHPADDR6, DeliveryNote, ExtOrderNum, cTelephone
FROM            [$(ERPDatabaseName)].dbo.InvNum
WHERE        (DocType = 4) AND (DocState IN (1, 3, 4, 7)) AND (InvDate > GETDATE() - 60)
GO

PRINT '############### [Label_ShipLabel] Done ###################'
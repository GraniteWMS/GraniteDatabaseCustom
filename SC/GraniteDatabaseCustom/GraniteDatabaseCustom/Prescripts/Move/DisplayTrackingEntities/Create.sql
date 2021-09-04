CREATE PROCEDURE [dbo].[PreScriptMoveTrackingEntity_DisplayTrackingEntities]
    (
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
DECLARE @trackingEntityBarcode varchar(50) = (SELECT Value FROM @input WHERE Name = 'StepInput')

DECLARE @cssStyle varchar(MAX)
DECLARE @htmlHead varchar(MAX)
DECLARE @htmlBody varchar(MAX)
DECLARE @htmlTableRows varchar(MAX)

DECLARE @MasterItemCode varchar(100)
DECLARE @Qty Varchar(20)
DECLARE @Location varchar(30)
Declare @Batch varchar(50)
Declare @ExpiryDate varchar(10)
DECLARE @TrackingEntity varchar(10)
DECLARE @excludeLocation varchar(10) = '%REC%'

SELECT @MasterItemCode = MasterItem.Code
FROM TrackingEntity
    INNER JOIN MasterItem ON TrackingEntity.MasterItem_id = MasterItem.ID
WHERE Barcode = @trackingEntityBarcode

DECLARE cursorApp_Inventory_Instock CURSOR LOCAL FOR
SELECT Barcode, Location, CONVERT(varchar(20),Qty), Batch, CONVERT(varchar(10),ISNULL(ExpiryDate,''))
FROM App_Inventory_Instock
WHERE [Master Item Code]= @MasterItemCode and Location NOT LIKE @excludeLocation

OPEN cursorApp_Inventory_Instock
FETCH NEXT FROM cursorApp_Inventory_Instock INTO @TrackingEntity, @Location,@Qty,@Batch,@ExpiryDate
IF @@FETCH_STATUS = 0 
	BEGIN
    WHILE @@FETCH_STATUS = 0

		BEGIN
        SELECT @htmlTableRows = CONCAT(@htmlTableRows, 
										'<tr class="empty">
											<td class="doc">', @TrackingEntity, '</td><td>', @Location, '</td><td>', @Qty,  '</td><td>', @Batch,  '</td><td>', @ExpiryDate,  '</td>
										</tr>')

        FETCH NEXT FROM cursorApp_Inventory_Instock INTO @TrackingEntity, @Location, @Qty, @Batch, @ExpiryDate
    END
    CLOSE cursorApp_Inventory_Instock
    DEALLOCATE cursorApp_Inventory_Instock

    SELECT @cssStyle = '<style>
							table, input {width: 100%;}
							input {outline: none; border: none;}
							table, th, td {border: 1px solid black;}
							.empty { background-color: rgb(255,173,102); }
							.doc:hover { cursor: pointer; background-color: lightblue;}
					   </style>'

    -- todo remove external CDN
    SELECT @htmlHead = '<head><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></head>'

    SELECT @htmlBody = CONCAT('<table class="table table-bordered"><tr><th>TrackingEntity</th><th>Location</th><th>Qty</th><th>Batch</th><th>ExpiryDate</th></tr>',
											@htmlTableRows, 
							  '</table><br><br>')

    INSERT INTO @Output
    SELECT 'Instruction', CONCAT(@cssStyle , @htmlHead, @htmlBody)

--Add a Button
--<br>
--<a href="http://localhost:40086/CUSTOM?processName=ALLOCATEPICKER" class="btn btn-primary" role="button" style="float: right; background-color:grey;">Reload <i class="fa fa-refresh"></i></a>
--<br><br>		
END

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @trackingEntityBarcode

SELECT *
FROM @Output

GO
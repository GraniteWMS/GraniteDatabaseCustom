USE [GraniteDatabaseTest]
GO

/****** Object:  StoredProcedure [dbo].[Logic_UpdatePickInstruction]    Script Date: 7/10/2022 10:07:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[Logic_UpdatePickInstruction] (
   @Document varchar(30)
)
AS

BEGIN
SET NOCOUNT ON;
DECLARE @OptionalFieldPalletQty varchar(50) = 'PALLETQTY'
DECLARE @PalletQtyOptionalField int = (SELECT ID FROM OptionalFields WHERE Name = @OptionalFieldPalletQty)

DECLARE @DocumentID BIGINT = (SELECT ID FROM Document WHERE Number = @Document  and Document.Type IN ('ORDER','PICKSLIP','TRANSFER'))

--In this query I check if there is a full pallet first and if that is NULL then check for any stock and if that is null then return ZZZ No Stock
	UPDATE DocumentDetail SET Instruction = isnull((SELECT TOP 1  L.Barcode 
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID LEFT OUTER JOIN OptionalFieldValues_MasterItem Opt 
	ON TE.MasterItem_id = Opt.BelongsTo_id AND Opt.OptionalField_id = @PalletQtyOptionalField
	WHERE  L.Barcode NOT LIKE '%REC%' AND TE.InStock = 1 AND TE.OnHold = 0 
	AND TE.Qty > CASE 
		WHEN isnull(Opt.Value,1) > 1 AND (DocumentDetail.Qty - DocumentDetail.ActionQty) >= Opt.Value THEN Opt.Value
		ELSE 1000000	--Dont want to find pallet stock if the PalletQty is not defined
				 END
	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	ORDER BY  TE.Qty,TE.ManufactureDate, L.Barcode DESC),   --Next part applies if the previous isnull
	isnull((SELECT TOP 1  L.Barcode 
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID 
	WHERE L.Barcode NOT LIKE '%REC%' AND TE.InStock = 1 AND TE.OnHold = 0 
	AND TE.Qty > 0			 
	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	--AND L.Barcode is lower level (pickface)
	ORDER BY TE.Qty,TE.ManufactureDate, L.Barcode DESC),'000-No Stock'))
	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
	WHERE Document.ID = @DocumentID AND  (DocumentDetail.Qty - DocumentDetail.ActionQty) > 0  


	UPDATE DocumentDetail SET LinePriority = TSQL.LinePriority
	FROM DocumentDetail DD INNER JOIN (SELECT ROW_NUMBER () OVER(ORDER BY Instruction DESC) as LinePriority, LineNumber 
	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
	WHERE Document.ID = @DocumentID  ) TSQL ON DD.LineNumber = TSQL.LineNumber
	WHERE DD.Document_id = @DocumentID 

END



GO



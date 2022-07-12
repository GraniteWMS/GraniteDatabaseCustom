
/****** Object:  StoredProcedure [dbo].[Logic_PickingInstruction_Finelinesettings]    Script Date: 7/11/2022 9:34:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Logic_PickingInstruction_Finelinesettings]

	@Document varchar(50)
AS
BEGIN

	DECLARE @DocumentID BIGINT = (SELECT ID FROM Document WHERE Number = @Document)

--First update Standard Picking Locations in the Comment Field
--Next Update to show a Bulk Location where the Comment field is empty (no Pickface stock)

--Then update the PickInstruction from the comment field - If the comment is empty, still show the PICKINGSEQ field from SAGE (Dependency on FN_PICKSEQ_ACCPAC)

--Finally Update the sort order of LinePriority
	--First Show BULK PICKS
	--Next Show Pick Face
	--Finally Show ZZZ-NoStock


	UPDATE DocumentDetail SET Comment = '' WHERE DocumentDetail.Document_id = @DocumentID

	UPDATE DocumentDetail 
	SET Comment = 'PICK:' + (SELECT TOP 1  L.Barcode + '  (PickLoc Qty:' + CONVERT(varchar,(CONVERT(int,TE.Qty))) + ')'	
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID
	WHERE 
	--LEFT(TE.Barcode,2) NOT IN ('PN','PC') AND
	TE.InStock = 1 AND TE.OnHold = 0  and L.NonStock = 0 and L.isActive = 1  AND TE.Qty > 0 
	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	AND L.[Type] = 'PICKING'
--	AND TE.Qty >= (DocumentDetail.Qty - isnull(DocumentDetail.ActionQty,0))
	ORDER BY TE.CreatedDate)
	FROM DocumentDetail 
	WHERE DocumentDetail.Document_id = @DocumentID


	UPDATE DocumentDetail 
	SET Comment = 'BULK:' + (SELECT TOP 1  L.Barcode + '  (On Pallet:' + CONVERT(varchar,(CONVERT(int,TE.Qty))) + ')'
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID
	WHERE TE.InStock = 1 AND TE.OnHold = 0 AND TE.Qty > 0  and L.NonStock = 0 and L.isActive = 1
	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	AND L.[Type] = 'BULK'
	ORDER BY TE.CreatedDate)
	FROM DocumentDetail 
	WHERE DocumentDetail.Document_id = @DocumentID and isnull(Comment,'') = ''


	UPDATE DocumentDetail
	SET Instruction = CASE  WHEN isnull(Comment,'') ='' THEN 'ZZZ-NO STOCK' ELSE 'PICK LOCATION:' + dbo.FN_PICKSEQ_ACCPAC(Item_id,FromLocation) END
	WHERE DocumentDetail.Document_id = @DocumentID



	UPDATE DocumentDetail SET LinePriority = TSQL.LinePriority
	FROM DocumentDetail DD INNER JOIN (SELECT ROW_NUMBER () OVER(ORDER BY Instruction) as LinePriority, LineNumber 
	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
	WHERE Document.ID = @DocumentID) TSQL ON DD.LineNumber = TSQL.LineNumber
	WHERE DD.Document_id = @DocumentID




END

GO



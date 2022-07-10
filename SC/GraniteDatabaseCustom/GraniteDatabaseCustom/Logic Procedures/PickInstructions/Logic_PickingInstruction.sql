USE [GraniteDatabase]
GO

/****** Object:  StoredProcedure [dbo].[Logic_PickingInstruction]    Script Date: 7/10/2022 9:47:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Logic_PickingInstruction]
	-- Add the parameters for the stored procedure here
	@Document varchar(50)
AS
BEGIN

--Simple allocation where there is stock -Show only the TOP Location.
	UPDATE DocumentDetail SET Instruction = isnull('Pick from:' + (SELECT TOP 1  L.Barcode + ' (OnHand:' + CONVERT(varchar,(CONVERT(int,TE.Qty))) + ')'
	FROM TrackingEntity TE Inner Join Location L
	ON TE.Location_id = L.ID
	WHERE TE.InStock = 1 AND TE.OnHold = 0 AND TE.Qty > 0  and L.NonStock = 0 and L.isActive = 1
	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
	ORDER BY L.[Type],TE.ExpiryDate,TE.CreatedDate),'ZZZ-No Stock')
	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
	WHERE Document.Number = @Document

--Show multiple locations and batches instead of TrackingEntities -Also include the Batch Qty


----Allocation WHERE We show Location and TrackingEntity
--	UPDATE DocumentDetail SET Instruction = isnull('Pick from:' + (SELECT TOP 1  L.Barcode + ' TE:-' + TE.Barcode
--	FROM TrackingEntity TE Inner Join Location L
--	ON TE.Location_id = L.ID
--	WHERE TE.InStock = 1 AND TE.OnHold = 0 AND TE.Qty > 0  and L.NonStock = 0 and L.isActive = 1
--	AND TE.MasterItem_id=  DocumentDetail.Item_id AND L.ERPLocation = DocumentDetail.FromLocation 
--	ORDER BY L.[Type],TE.ExpiryDate,TE.CreatedDate),'ZZZ-No Stock')
--	FROM DocumentDetail INNER JOIN Document ON Document.ID = DocumentDetail.Document_id
--	WHERE Document.Number = @Document




END

GO



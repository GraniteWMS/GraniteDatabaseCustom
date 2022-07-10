

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Craig Collins
-- Create date: 10 July 2022
-- Description:	A utility to copy a document
-- =============================================
CREATE PROCEDURE [dbo].[Utility_CopyDocument]
	@Document varchar(50),
	@NewDocument varchar(50), 
	@NewStatus varchar(30),
	@NewType varchar(30)

AS
BEGIN

DECLARE @DocumentID bigint
SELECT @DocumentID = ID FROM Document WHERE Number = @Document
DECLARE @NewDocumentID bigint
SELECT @NewDocumentID = ID FROM Document WHERE Number = @NewDocument


IF		ISNULL(@DocumentID,0) > 0		--Document Exists
	AND ISNULL(@NewDocumentID,0) = 0	
BEGIN	
	INSERT INTO [dbo].[Document]
           ([Number],[TradingPartnerCode],[TradingPartnerDescription],[Description],[ActionDate],[CreateDate],[ExpectedDate]
           ,[isActive] ,[Priority],[ERPLocation],[Site],[AuditDate] ,[AuditUser] ,[Type] ,[Status])
	SELECT		@NewDocument
           ,[TradingPartnerCode]
           ,[TradingPartnerDescription]
           ,[Description]
           ,[ActionDate]
           ,[CreateDate]
           ,[ExpectedDate]
           ,[isActive]
           ,[Priority]
           ,[ERPLocation]
           ,[Site]
           ,getdate()
           ,'AUTOMATION'
           ,@NewType
           ,@NewStatus
	FROM Document WHERE ID = @DocumentID

	SELECT @NewDocumentID  = ID FROM Document WHERE Number = @NewDocument
END		--The New Document Header is created.

--@NewDocumentID will now have the New DocumentID
INSERT INTO [dbo].[DocumentDetail]
           ([LineNumber]
--           ,[LinePriority]
           ,[UOMQty]
           ,[Qty]
           ,[UOM]
           ,[UOMConversion]
           ,[Completed]
           ,[UnitValue]
           ,[Comment]
           ,[MultipleEntries]
--           ,[ActionQty]
--           ,[PackedQty]
           ,[FromLocation]
           ,[ToLocation]
           ,[IntransitLocation]
           ,[Batch]
           ,[ExpiryDate]
           ,[SerialNumber]
           ,[AuditDate]
           ,[AuditUser]
--           ,[ReversalAuditDate]
--           ,[ReversalAuditUser]
           ,[Item_id]
           ,[Document_id]
--           ,[LinkedDetail_id]
           ,[Status]
           ,[Type]
           ,[Cancelled]
--           ,[ERPIdentification]
--          ,[Instruction]
)
SELECT      [LineNumber]
--           ,[LinePriority]
           ,[UOMQty]
           ,[Qty]
           ,[UOM]
           ,[UOMConversion]
           ,[Completed]
           ,[UnitValue]
           ,[Comment]
           ,[MultipleEntries]
--           ,[ActionQty]
--           ,[PackedQty]
           ,[FromLocation]
           ,[ToLocation]
           ,[IntransitLocation]
           ,[Batch]
           ,[ExpiryDate]
           ,[SerialNumber]
           ,[AuditDate]
           ,[AuditUser]
--           ,[ReversalAuditDate]
--           ,[ReversalAuditUser]
           ,[Item_id]
           ,@NewDocumentID
--           ,[LinkedDetail_id]
           ,[Status]
           ,[Type]
           ,[Cancelled]
--           ,[ERPIdentification]
--          ,[Instruction]
FROM DocumentDetail WHERE Document_id = @DocumentID
AND NOT EXISTS (SELECT ID FROM DocumentDetail DD WHERE Document_id = @NewDocumentID AND DD.LineNumber = DocumentDetail.LineNumber)


END





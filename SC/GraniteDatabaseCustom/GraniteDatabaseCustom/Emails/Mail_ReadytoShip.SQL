
/****** Object:  StoredProcedure [dbo].[Mail_ReadytoShip]    Script Date: 7/10/2022 9:47:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Craig Collins
-- Description:	After Packing is complete -send email with the Order details showing what was PICKED and PACKED.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ReadytoShip]

	@DocumentReference varchar(50)
AS
BEGIN
	DECLARE @Body varchar(max)
	DECLARE @sql varchar(max)
	DECLARE @html varchar(max)
	DECLARE @orderby varchar(max)

	DECLARE @EmailSubject varchar(max)
	Declare @UserName varchar(30)
	Declare @StartTime DateTime
	Declare @EndTime DateTime
	Declare @Duration Int
	DECLARE @Comment varchar(250)
	Declare @TradingPartnerDescription varchar(max) = ''
	Declare @TradingPartnerCode varchar(100) = ''

	SELECT @TradingPartnerCode = TradingPartnerCode, @TradingPartnerDescription = TradingPartnerDescription FROM Document WHERE Number = @DocumentReference

	SELECT @EmailSubject = 'Order:' + @DocumentReference + ' is Ready to Invoice to Customer:' + isnull(@TradingPartnerCode,'')  + '-' + isnull(@TradingPartnerDescription,'')											
	
	select @sql = CONCAT('SELECT DocumentDetail.LineNumber,MasterItem.Code,MasterItem.Description, PackedQty as PackedQty, ActionQty as PickedQty, Qty as Committed, UOMQty as Ordered
						,CASE WHEN PackedQty <  Qty THEN ''Yellow'' WHEN UOMQty = 0 THEN ''Gray'' WHEN PackedQty = 0 Then ''Pink'' ELSE ''White'' END as RowColor  
						FROM Document inner join DocumentDetail on DocumentDetail.Document_id = Document.ID
						inner join MasterItem on DocumentDetail.Item_id = MasterItem.ID
						WHERE Document.Number = ''',@DocumentReference,'''			
						')

	SELECT @OrderBy = 'ORDER BY RowColor'

	--SELECT @sql
	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT

	
	SELECT  @Comment = concat(@DocumentReference,' is ready to INVOICE.  ')

	SELECT @html = CONCAT('<body><h1><b>',@EmailSubject,'</h1></b><p>','<h3>',@Comment,'</h3></p>','<h4>','Items checked on the order are:','</h4></p>',@html)

	--Send a mail
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
		@recipients = 'info@granitewms.com',
		@subject = @EmailSubject,
		@Body = @html,
		@body_format = 'HTML'
END
GO



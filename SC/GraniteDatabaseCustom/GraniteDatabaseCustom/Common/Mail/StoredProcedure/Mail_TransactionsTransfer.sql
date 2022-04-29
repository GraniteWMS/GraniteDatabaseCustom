-- =============================================
-- Author:		Craig Collins
-- Description:	Dependant on database mail profile Granite
-- =============================================
CREATE PROCEDURE [dbo].[Mail_TransactionsTransfer]
	-- Add the parameters for the stored procedure here
	@DocumentReference varchar(50)
AS
BEGIN
	DECLARE @Body varchar(max)
	DECLARE @sql varchar(max)
	DECLARE @html varchar(max)
	DECLARE @orderby varchar(max)

    DECLARE @emailRecipients varchar(max) = 'craigc@granitewms.com;customer@customer.com'
	DECLARE @EmailSubject varchar(255)
	Declare @UserName varchar(30)
	Declare @StartTime DateTime
	Declare @EndTime DateTime
	Declare @Duration Int
	Declare @LastReceipt varchar(20)
	Declare @DocumentID BIGINT 
	Declare @TradingPartnerCode varchar(50)
	Declare @TradingPartnerDescription varchar(255)
	DECLARE @DocumentDescription varchar(255)

	SELECT @DocumentID = ID, @TradingPartnerCode = TradingPartnerCode, 
	@TradingPartnerDescription = TradingPartnerDescription, @DocumentDescription = Description 
	FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @DocumentReference
	
	SELECT TOP 1 @UserName = Users.Name, @StartTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] INNER JOIN
						[$(GraniteDatabase)].dbo.Users ON [Transaction].[User_id] = Users.ID
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID ASC

	SELECT TOP 1 @EndTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] 
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID DESC

	SELECT @EmailSubject = 'TRANSFER Order:' + @DocumentReference + '--' + @TradingPartnerDescription +  ' -Processed by:' + @UserName + ' is documented as below'												

	SELECT @sql = CONCAT('SELECT    CONVERT(varchar(20),getdate(),101) as ScannedDate, MasterItem.Code, MasterItem.Description,TrackingEntity.Batch as Lot, SUM(ActionQty) as QtyTransferred, 
	IntegrationReference, CASE IntegrationStatus WHEN 0 THEN ''Azure'' ELSE ''LightGrey'' END as RowColor
						FROM dbo.[Transaction] with (NOLOCK) INNER JOIN
						dbo.MasterItem with (NOLOCK) ON [Transaction].FromMasterItem_id = MasterItem.ID INNER JOIN
						Document with (NOLOCK) on [Transaction].Document_id = Document.ID  INNER JOIN
						TrackingEntity with (NOLOCK) on TrackingEntity.ID = [Transaction].TrackingEntity_id
						WHERE Document.Number = ''',@DocumentReference,'''
						GROUP BY MasterItem.Code, MasterItem.Description, TrackingEntity.Batch,IntegrationReference,IntegrationStatus

						')
	SELECT @OrderBy = 'ORDER BY IntegrationReference,ScannedDate, Code, Lot'


	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT


--	SELECT TOP 1 @LastReceipt = LASTRECEIP FROM [$(AccpacDatabase)].dbo.POPORH1 WHERE PONUMBER = @DocumentReference 

	SELECT @html = CONCAT('<body><h1><b>',@EmailSubject,'</h1></b><p>','<h4>Started:',CONVERT(varchar(20),@StartTime),' EST Ended:',CONVERT(varchar(20),@EndTime),' Duration:', 
	CONVERT(varchar(20),DATEDIFF(Minute,@StartTime,@EndTime)),' EST minutes </h4></p><br><h4>',@TradingPartnerDescription, ' Collect by:',@DocumentDescription,'</h4></p>',
--	,'<h4>Last Receipt Number:',@LastReceipt,'</h4>'
	'<br>',@html)
	--Send a mail
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
		@recipients = @emailRecipients,
		@subject = @EmailSubject,
		@Body = @html,
		@body_format = 'HTML'
END
GO
-- =============================================
-- Author:		Craig Collins
-- Description:	Dependant on database mail profile Granite
-- =============================================
CREATE PROCEDURE [dbo].[Mail_TransactionsPicked]
	-- Add the parameters for the stored procedure here
	@DocumentReference varchar(50)
AS
BEGIN
	DECLARE @Body varchar(max)
	DECLARE @sql varchar(max)
	DECLARE @html varchar(max)
	DECLARE @orderby varchar(max)

    DECLARE @emailRecipients varchar(255) = 'craigc@granitewms.com;customer@customer.com'
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
	@TradingPartnerDescription = TradingPartnerDescription, 
	@DocumentDescription = Description FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @DocumentReference
	
	SELECT TOP 1 @UserName = Users.Name, @StartTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] INNER JOIN
						[$(GraniteDatabase)].dbo.Users ON [Transaction].[User_id] = Users.ID
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID ASC

	SELECT TOP 1 @EndTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] 
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID DESC

	SELECT @EmailSubject = 'Sales Order:' + @DocumentReference + ' for Customer:' + @TradingPartnerCode + '-' + @DocumentDescription +' is picked'												

	-- todo static sql
	SELECT @sql = CONCAT('SELECT    CONVERT(varchar(20),getdate(),101) as PickedDate, MasterItem.Code, MasterItem.Description, TrackingEntity.Batch as Lot,SUM(ActionQty) as QtyPicked, 
	CASE IntegrationStatus WHEN 0 THEN ''Azure'' ELSE ''LightGrey'' END as RowColor
						FROM [Transaction] with (NOLOCK) INNER JOIN 
						TrackingEntity with (NOLOCK) On [Transaction].TrackingEntity_id = TrackingEntity.ID INNER JOIN
						MasterItem with (NOLOCK) ON [Transaction].FromMasterItem_id = MasterItem.ID INNER JOIN
						Document with (NOLOCK) on [Transaction].Document_id = Document.ID
						WHERE Document.Number = ''',@DocumentReference,'''
						GROUP BY MasterItem.Code, MasterItem.Description,IntegrationStatus, TrackingEntity.Batch
						')
	SELECT @OrderBy = 'ORDER BY Lot,PickedDate'


	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT


--	SELECT TOP 1 @LastReceipt = LASTRECEIP FROM [STOCKD].dbo.POPORH1 WHERE PONUMBER = @DocumentReference 

	SELECT @html = CONCAT('<body><h1><b>',@EmailSubject,'</h1></b><p>','<h3>Picked by:',@UserName,'  Started:',CONVERT(varchar(20),@StartTime),' EST Ended:',CONVERT(varchar(20),@EndTime),' Duration:', 
	CONVERT(varchar(20),DATEDIFF(Minute,@StartTime,@EndTime)),' minutes </h3> <br> <h3> ','Customer:',@TradingPartnerCode,'-',@DocumentDescription, ' Collect by:',@TradingPartnerDescription,'</h3></p>',
	 --'<h4>Last Receipt Number:',@LastReceipt,'</h4><br>',
	@html)
	--Send a mail
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
    	@recipients = @emailRecipients,
		@subject = @EmailSubject,
		@Body = @html,
		@body_format = 'HTML'
END

GO
-- =============================================
-- Author:		Craig Collins
-- Description:	Dependent on email setup with a profile Granite
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MOProgress]
	-- Add the parameters for the stored procedure here
	@MONumber varchar(50)
AS
BEGIN
	DECLARE @Body varchar(max)
	DECLARE @sql varchar(max)
	DECLARE @html varchar(max)
	DECLARE @orderby varchar(max)

    DECLARE @EmailRecipients varchar(max) = 'craigc@granitewms.com;customer@customer.com'
	DECLARE @EmailSubject varchar(100)
	Declare @UserName varchar(30)
	Declare @StartTime DateTime
	Declare @EndTime DateTime
	Declare @Duration Int
	Declare @LastReceipt varchar(20)
	Declare @DocumentId Bigint = (SELECT ID FROM [$(GraniteDatabase)].dbo.Document WHERE Number = @MONumber)
	
	SELECT TOP 1 @UserName = Users.Name, @StartTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] INNER JOIN
						[$(GraniteDatabase)].dbo.Users ON [$(GraniteDatabase)].dbo.[Transaction].[User_id] = Users.ID
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID ASC

	SELECT TOP 1 @EndTime = [Transaction].Date FROM [$(GraniteDatabase)].dbo.[Transaction] 
						WHERE Document_id = @DocumentID
						ORDER BY [Transaction].ID DESC

	SELECT @EmailSubject = 'Manufacturing Progress: ' + @MONumber												

	SELECT @sql = CONCAT('
SELECT L3.Site, dbo.[Users].[Name] AS [UserName], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (nolock) LEFT OUTER JOIN
                  dbo.TrackingEntity  with (nolock) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (nolock) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (nolock) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location with (nolock) AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location with (nolock) AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location with (nolock) AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (nolock) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] with (nolock) ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE''
				  and Document.Number =  ''',@MONumber,'''
 GROUP BY L3.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch
              
						')
	SELECT @OrderBy = 'ORDER BY ManufactureDate'

	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT

	SELECT @html = CONCAT('<body><h1><b>',@EmailSubject,'</h1></b><p>',
	--'<h4>Started:',CONVERT(varchar(20),@StartTime),' EST Ended:',CONVERT(varchar(20),@EndTime),' Duration:', 
	--CONVERT(varchar(20),DATEDIFF(Minute,@StartTime,@EndTime)),' EST minutes </h4>
	'</p>',
	--'<h4>Last Receipt Number:',@LastReceipt,'</h4>'
	'<br>'
	,@html)

	--Send a mail
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
		@recipients = @EmailRecipients,
		@subject = @EmailSubject,
		@Body = @html,
		@body_format = 'HTML'
END
GO


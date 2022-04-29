-- =============================================
-- Author:		Craig Collins
-- Description:	Dependant on database mail profile Granite
-- =============================================
CREATE PROCEDURE [dbo].[Mail_JOBCompanyDailyProduction]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	DECLARE @Body varchar(max)
	DECLARE @sql varchar(max)
	DECLARE @html varchar(max)
	DECLARE @htmlmessage varchar(max) = ''
	DECLARE @Outputhtml varchar(max) = ''
	DECLARE @orderby varchar(max)

    DECLARE @emailRecipients varchar(max) = 'craigc@granitewms.com;customer@customer.com'
	DECLARE @EmailSubject varchar(100)
	Declare @UserName varchar(30)
	Declare @StartTime DateTime
	Declare @EndTime DateTime
	Declare @Duration Int
	Declare @LastReceipt varchar(20)
	
	DECLARE @Site varchar(30)

	------------------------------------------

	SELECT @Site = 'ORANGE'

	SELECT @EmailSubject = @Site + '-Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											

	SELECT @sql = CONCAT('
SELECT L1.Site, RIGHT(dbo.TrackingEntity.Batch,3) AS [Operator], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (NOLOCK) LEFT OUTER JOIN
                  dbo.TrackingEntity with (NOLOCK) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (NOLOCK) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (NOLOCK) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (NOLOCK) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] with (NOLOCK) ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE'' AND L1.Site = ''',@Site,'''
				   AND dbo.[Transaction].Date > CONVERT(Date,getdate(),101)
 GROUP BY L1.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch     
						','')
	SELECT @OrderBy = 'ORDER BY Document, ManufactureDate'


	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT

	
	SELECT @htmlmessage = CONCAT(@htmlmessage,'<h2><b>',@EmailSubject,'</h2></b>',
	@html)

	------------------------------------------

	SELECT @Site = 'LIVERMORE'

	SELECT @EmailSubject = @Site + '-Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											

	SELECT @sql = CONCAT('
SELECT L1.Site, RIGHT(dbo.TrackingEntity.Batch,3) AS [Operator], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (NOLOCK) LEFT OUTER JOIN
                  dbo.TrackingEntity with (NOLOCK) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (NOLOCK) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (NOLOCK) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location  AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location  AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (NOLOCK) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] with (NOLOCK) ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE'' AND L1.Site = ''',@Site,'''
				   AND dbo.[Transaction].Date > CONVERT(Date,getdate(),101)
 GROUP BY L1.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch     
						','')
	SELECT @OrderBy = 'ORDER BY Document, ManufactureDate'

	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT

	SELECT @htmlmessage = CONCAT(@htmlmessage,'<h2><b>',@EmailSubject,'</h2></b>',
	@html)

	SELECT @Site = 'BURBANK'

	SELECT @EmailSubject = @Site + '-Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											

	SELECT @sql = CONCAT('
SELECT L1.Site, RIGHT(dbo.TrackingEntity.Batch,3) AS [Operator], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (NOLOCK) LEFT OUTER JOIN
                  dbo.TrackingEntity with (NOLOCK) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (NOLOCK) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (NOLOCK) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location  AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location  AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (NOLOCK) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] with (NOLOCK) ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE'' AND L1.Site = ''',@Site,'''
				   AND dbo.[Transaction].Date > CONVERT(Date,getdate(),101)
 GROUP BY L1.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch     
						','')
	SELECT @OrderBy = 'ORDER BY Document, ManufactureDate'


	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT


	SELECT @htmlmessage = CONCAT(@htmlmessage,'<h2><b>',@EmailSubject,'</h2></b>',
	@html)

	SELECT @Site = 'PHOENIX'

	SELECT @EmailSubject = @Site + '-Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											

	SELECT @sql = CONCAT('
SELECT L1.Site, RIGHT(dbo.TrackingEntity.Batch,3) AS [Operator], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (NOLOCK) LEFT OUTER JOIN
                  dbo.TrackingEntity with (NOLOCK) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (NOLOCK) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (NOLOCK) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location  AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location  AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location  AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (NOLOCK) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE'' AND L1.Site = ''',@Site,'''
				   AND dbo.[Transaction].Date > CONVERT(Date,getdate(),101)
 GROUP BY L1.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch     
						','')
	SELECT @OrderBy = 'ORDER BY Document, ManufactureDate'

	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT


	SELECT @htmlmessage = CONCAT(@htmlmessage,'<h2><b>',@EmailSubject,'</h2></b>',
	@html)


	------------------------------------------
	SELECT @Site = 'PHOENIX2'

	SELECT @EmailSubject = @Site + '-Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											

	SELECT @sql = CONCAT('
SELECT L1.Site, RIGHT(dbo.TrackingEntity.Batch,3) AS [Operator], dbo.[Document].Number AS Document, CONVERT(varchar,dbo.[Transaction].Date,101) as ManufactureDate,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode AS Pallet,  dbo.TrackingEntity.Batch,
                SUM(dbo.[Transaction].ActionQty) as [QtyPCS],   '''' as RowColor
FROM     dbo.[Transaction] with (NOLOCK) LEFT OUTER JOIN
                  dbo.TrackingEntity with (NOLOCK) ON dbo.TrackingEntity.ID = dbo.[Transaction].TrackingEntity_id LEFT OUTER JOIN
                  dbo.MasterItem with (NOLOCK) ON dbo.MasterItem.ID = dbo.TrackingEntity.MasterItem_id LEFT OUTER JOIN
                  dbo.CarryingEntity with (NOLOCK) ON dbo.[TrackingEntity].BelongsToEntity_id = dbo.CarryingEntity.ID LEFT OUTER JOIN
                  dbo.Location  AS L1 ON dbo.[Transaction].FromLocation_id = L1.ID LEFT OUTER JOIN
                  dbo.Location  AS L2 ON dbo.[Transaction].ToLocation_id = L2.ID LEFT OUTER JOIN
                  dbo.Location  AS L3 ON dbo.TrackingEntity.Location_id = L3.ID LEFT OUTER JOIN
                  dbo.Users with (NOLOCK) ON dbo.[Transaction].User_id = dbo.Users.ID LEFT OUTER JOIN
                  dbo.[Document] ON dbo.[Document].ID = dbo.[Transaction].Document_id
				  WHERE  dbo.[Transaction].Type = ''MANUFACTURE'' AND L1.Site = ''',@Site,'''
				   AND dbo.[Transaction].Date > CONVERT(Date,getdate(),101)
 GROUP BY L1.Site,dbo.[Users].Name,dbo.[Document].Number, CONVERT(varchar,dbo.[Transaction].Date,101) ,
dbo.MasterItem.Code, dbo.MasterItem.Description,  
dbo.CarryingEntity.Barcode ,  dbo.TrackingEntity.Batch     
						','')
	SELECT @OrderBy = 'ORDER BY Document, ManufactureDate'

	EXEC dbo.SqlToHtml @sql, @OrderBy, @html OUTPUT

	SELECT @htmlmessage = CONCAT(@htmlmessage,'<h2><b>',@EmailSubject,'</h2></b>',
	@html)
	SELECT @EmailSubject = 'Companywide Daily Manufacturing Progress: ' + CONVERT(varchar(20),getdate(),101)											
	

	--Send a mail
	EXECUTE msdb.dbo.sp_send_dbmail
		@profile_name = 'Granite',
		@recipients = @emailRecipients,
		@subject = @EmailSubject,
		@Body = @htmlmessage,
		@body_format = 'HTML'
END
GO


CREATE VIEW [dbo].[Label_ShipLabel]
AS
SELECT  RTRIM(cAccountName) AS CUSTOMER, RTRIM(Address1) AS SHPADDR1, '' AS SHIPVIA, RTRIM(cContact) AS SHPNAME, 
		RTRIM(Address2) AS SHPADDR2, RTRIM(Address3) AS SHPADDR3, RTRIM(Address4) AS SHPADDR4, 
        '' AS SHPCITY, '' AS SHPSTATE, '' AS SHPCOUNTRY, cContact AS SHPCONTACT, '' AS SHPZIP, '' AS ERPLocation, 
		OrderNum AS Number, '' AS STOP, '' AS ROUTE, '' AS Territory, '' AS Expr1, InvNumber, GrvNumber, Description, 
        InvDate, OrderDate, DueDate, DeliveryDate, RTRIM(Address5) AS SHPADDR5, RTRIM(Address6) AS SHPADDR6, DeliveryNote, ExtOrderNum, cTelephone
FROM            [$(ERPDatabaseName)].dbo.InvNum
WHERE        (DocType = 4) AND (DocState IN (1, 3, 4, 7)) AND (InvDate > GETDATE() - 60)
GO

PRINT '############### [Label_ShipLabel] Created ###################'

GO
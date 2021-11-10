CREATE VIEW [dbo].[Custom_AllocatePickerDocument_View]
AS
SELECT        D .Number, RTRIM(D .TradingPartnerCode) + ' ' + D .TradingPartnerDescription AS TradingPartnerCode, D .[Status], D .isActive, C.Date, C.Picker
FROM            Document D LEFT JOIN
                         Custom_AllocatePickerDocument C ON D .Number = C.DocNumber
WHERE        D .[Type] = 'ORDER' AND D .[Status] = 'RELEASED'
ORDER BY D .Number, C.Picker ASC OFFSET 0 ROWS

GO
PRINT '############### View Custom_AllocatePickerDocument_View Done ###################'
GO
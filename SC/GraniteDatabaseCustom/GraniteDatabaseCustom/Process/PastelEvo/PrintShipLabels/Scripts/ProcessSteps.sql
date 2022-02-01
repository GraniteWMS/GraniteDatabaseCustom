INSERT [$(GraniteDatabase)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'PRINTSHIPLABELS', N'PRINTSHIPLABELS', N'CUSTOM', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO
INSERT [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Document', N'Document', 0, 1, 1, NULL, 1, N'PRINTSHIPLABELS', N'PrescriptPrintShipLabelsDocument')
GO
INSERT [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Qty', N'Qty of Labels', 1, 1, 1, NULL, 0, N'PRINTSHIPLABELS', N'PrescriptPrintShipLabelsQty')
GO

PRINT '############### Process and Step created  ###################'
GO
﻿GO
INSERT INTO [$(GraniteDatabase)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'PALLETSTOCKTAKE', N'PALLETSTOCKTAKE', N'STOCKTAKECOUNT', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Session', N'Session', 0, 1, 0, NULL, 1, N'PALLETSTOCKTAKE', NULL)
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Count', N'Count', 1, 1, 1, NULL, 2, N'PALLETSTOCKTAKE', NULL)
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Location', N'Location', 2, 1, 1, NULL, 3, N'PALLETSTOCKTAKE', NULL)
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'TrackingEntity', N'TrackingEntity', 3, 1, 0, NULL, 4, N'PALLETSTOCKTAKE', N'PrescriptPalletStockTakeTrackingEntity')
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'PalletConfirmation', N'PalletConfirmation', 4, 1, 0, NULL, 5, N'PALLETSTOCKTAKE', N'PrescriptPalletStockTakePalletConfirmation')
GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Qty', N'Qty', 5, 1, 0, NULL, 2, N'PALLETSTOCKTAKE', NULL)
GO

PRINT '############### Process and Step created  ###################'
GO
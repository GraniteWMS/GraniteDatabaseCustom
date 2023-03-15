?GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) 
VALUES (N'Document', N'Document', 1, 1, 1, NULL, 2, N'CHECKLIST', N'PrescriptChecklistDocument')
?GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) VALUES (N'MasterItem', N'MasterItem', 2, 1, 1, NULL, 3, N'CHECKLIST', N'PrescriptChecklistMasterItem')
?GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) VALUES (N'Qty', N'Qty', 3, 1, 1, NULL, 2, N'CHECKLIST', N'PrescriptChecklistQty')
?GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) VALUES (N'Location', N'Location', 0, 1, 1, NULL, 1, N'CHECKLIST', N'PrescriptChecklistLocation')
?GO
INSERT INTO [$(GraniteDatabase)].[dbo].[ProcessStep] ([Name], [Description], [ProcessIndex], [isActive], [Required], [DefaultValue], [NextIndex], [Process], [PreScript]) VALUES (N'Step200', N'Step200', 200, 1, 1, NULL, 2, N'CHECKLIST', N'PrescriptCheckingStep200')
?GO
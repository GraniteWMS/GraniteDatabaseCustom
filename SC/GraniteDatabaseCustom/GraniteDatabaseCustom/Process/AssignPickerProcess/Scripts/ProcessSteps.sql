﻿INSERT [$(GraniteDatabase)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'ALLOCATEPICKER', N'ALLOCATEPICKER', N'CUSTOM', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES ('LOAD' ,'Load Active Sales Orders' ,0 ,1 ,0 ,NULL,1 ,'ALLOCATEPICKER','PrescriptAllocatePickerLoad')
GO
INSERT INTO [dbo].[ProcessStep] ([Name], [Description], [ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('DOCUMENT' ,'SELECT Sales Order Number' ,1 ,1 ,1 ,NULL ,2 ,'ALLOCATEPICKER' ,'PrescriptAllocatePickerDocument')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('PICKER' ,'Add Picker' ,1 ,1 ,1 ,NULL ,2 ,'ALLOCATEPICKER' ,'PrescriptAllocatePickerPicker')
GO

PRINT '############### Process and Steps Done ###################'
GO
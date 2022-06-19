INSERT [$(GraniteDatabase)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'DELIVERYNOTIFYHACCP', N'DELIVERY -NOTIFY with HACCP', N'TAKEON', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO

INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES ('Location' ,'Delivery Location' ,0 ,1 ,0 ,'DELIVERY',1 ,'DELIVERYNOTIFYHACCP','PrescriptDeliveryNotifyHACCPLocation')
GO
INSERT INTO [dbo].[ProcessStep] ([Name], [Description], [ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Carrier' ,'Carrier' ,1 ,1 ,1 ,NULL ,2 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Truck' ,'Truck Registration' ,2 ,1 ,1 ,NULL ,3 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Driver' ,'Driver Name' ,3 ,1 ,1 ,NULL ,4 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPConditionClean' ,'HACCP -Condition (Clean)' ,4 ,1 ,1 ,NULL ,5 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPConditionDamage' ,'HACCP -Condition (Damage)' ,5 ,1 ,1 ,NULL ,6 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPConditionOdor' ,'HACCP -Condition (Odor)' ,6 ,1 ,1 ,NULL ,7 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPConditionPests' ,'HACCP -Condition (Pests)' ,7 ,1 ,1 ,NULL ,8 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPTruckEnvironment' ,'HACCP -TruckEnvironment' ,8 ,1 ,1 ,NULL ,9 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPTruckTemperature' ,'HACCP -Truck Temperature' ,9 ,1 ,1 ,NULL ,10 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('HACCPTruckTransitduration' ,'HACCP -Truck Transit duration (Min)' ,10 ,1 ,1 ,NULL ,11,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Reference' ,'Waybill' ,11 ,1 ,1 ,NULL ,12,'DELIVERYNOTIFYHACCP' ,'PrescriptDeliveryNotifyHACCPReference')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Document' ,'Purchase Order (Enter 0 to just log truck)' ,12 ,1 ,1 ,NULL ,13 ,'DELIVERYNOTIFYHACCP' ,'PrescriptDeliveryNotifyHACCPDocument')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Confirmation' ,'Confirmation' ,13 ,1 ,1 ,NULL ,12 ,'DELIVERYNOTIFYHACCP' ,'PrescriptDeliveryNotifyHACCPConfirmation')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Comment' ,'Comment' ,100 ,1 ,1 ,NULL ,100 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Qty' ,'Qty' ,100 ,1 ,1 ,'1' ,100 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('UseBarcode' ,'UseBarcode' ,100 ,1 ,1 ,'DELIVERY' ,100 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('MasterItem' ,'MasterItem (DELIVERY)' ,100 ,1 ,1 ,'DELIVERY' ,100 ,'DELIVERYNOTIFYHACCP' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Step200' ,'200-Send delivery Email' ,200 ,1 ,1 ,NULL ,200 ,'DELIVERYNOTIFYHACCP' ,'PrescriptDeliveryNotifyHACCPStep200')
GO
PRINT '############### Process and Steps Done ###################'


INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Clean','Clean','DELIVERYNOTIFYHACCP','HACCPConditionClean',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Dirty','Dirty','DELIVERYNOTIFYHACCP','HACCPConditionClean',NULL)
GO

INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('No Damage','No Damage','DELIVERYNOTIFYHACCP','HACCPConditionDamage',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Damaged','Damaged','DELIVERYNOTIFYHACCP','HACCPConditionDamage',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Damaged -REJECT','Damaged -REJECT','DELIVERYNOTIFYHACCP','HACCPConditionDamage',NULL)
GO

INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('No Bad Odor','No Bad Odor','DELIVERYNOTIFYHACCP','HACCPConditionOdor',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Bad Odor','Bad Odor','DELIVERYNOTIFYHACCP','HACCPConditionOdor',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Bad Odor -REJECT','Bad Odor -REJECT','DELIVERYNOTIFYHACCP','HACCPConditionOdor',NULL)
GO

INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('No Pests','No Pests','DELIVERYNOTIFYHACCP','HACCPConditionPests',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Pests Present','Pests Present','DELIVERYNOTIFYHACCP','HACCPConditionPests',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Pests -REJECT','Pests -REJECT','DELIVERYNOTIFYHACCP','HACCPConditionPests',NULL)
GO

INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Ambient','Ambient','DELIVERYNOTIFYHACCP','HACCPTruckEnvironment',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Chilled','Chilled','DELIVERYNOTIFYHACCP','HACCPTruckEnvironment',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Iced','Iced','DELIVERYNOTIFYHACCP','HACCPTruckEnvironment',NULL)
GO
INSERT INTO [dbo].[ProcessStepLookup] ([Value],[Description],[Process],[ProcessStep],[UserName])
VALUES ('Frozen','Frozen','DELIVERYNOTIFYHACCP','HACCPTruckEnvironment',NULL)
GO

PRINT '############### Process Step Lookup Done ###################'
GO
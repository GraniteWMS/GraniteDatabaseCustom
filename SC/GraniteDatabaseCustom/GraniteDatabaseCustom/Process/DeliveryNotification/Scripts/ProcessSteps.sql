INSERT [$(GraniteDatabase)].[dbo].[Process] ([isActive], [Name], [Description], [Type], [IntegrationMethod], [IntegrationIsActive], [IntegrationPost], [ActivityCost]) 
VALUES (1, N'DELIVERYNOTIFY', N'DELIVERY -NOTIFY', N'TAKEON', NULL, 0, 0, CAST(0.000000 AS Decimal(19, 6)))
GO

INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES ('Location' ,'Delivery Location' ,0 ,1 ,0 ,'DELIVERY',1 ,'DELIVERYNOTIFY','PrescriptDeliveryNotifyLocation')
GO
INSERT INTO [dbo].[ProcessStep] ([Name], [Description], [ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Carrier' ,'Carrier' ,1 ,1 ,1 ,NULL ,2 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Truck' ,'Truck Registration' ,2 ,1 ,1 ,NULL ,3 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Driver' ,'Driver Name' ,3 ,1 ,1 ,NULL ,4 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Reference' ,'Waybill' ,4 ,1 ,1 ,NULL ,5,'DELIVERYNOTIFY' ,'PrescriptDeliveryNotifyReference')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Document' ,'Purchase Order (Enter 0 to just log truck)' ,5 ,1 ,1 ,NULL ,6 ,'DELIVERYNOTIFY' ,'PrescriptDeliveryNotifyDocument')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Confirmation' ,'Confirmation' ,6 ,1 ,1 ,NULL ,5 ,'DELIVERYNOTIFY' ,'PrescriptDeliveryNotifyConfirmation')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Comment' ,'Comment' ,100 ,1 ,1 ,NULL ,100 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Qty' ,'Qty' ,100 ,1 ,1 ,'1' ,100 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('UseBarcode' ,'UseBarcode' ,100 ,1 ,1 ,'DELIVERY' ,100 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('MasterItem' ,'MasterItem (DELIVERY)' ,100 ,1 ,1 ,'DELIVERY' ,100 ,'DELIVERYNOTIFY' ,'')
GO
INSERT INTO [dbo].[ProcessStep] ([Name],[Description],[ProcessIndex] ,[isActive],[Required],[DefaultValue],[NextIndex],[Process],[PreScript])
VALUES  ('Step200' ,'200-Send delivery Email' ,200 ,1 ,1 ,NULL ,200 ,'DELIVERYNOTIFY' ,'PrescriptDeliveryNotifyStep200')
GO

PRINT '############### Process and Steps Done ###################'
GO
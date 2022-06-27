
INSERT INTO Functions (Name, Description, Module,Script, isActive)
SELECT 'OrderStatus', 'Set Order Status', 'ORDERPROGRESS','FunctionOrderProgressOrderStatus',1

INSERT INTO FunctionParameter (FunctionName, Name, Description, isBool)
SELECT 'OrderStatus', 'OrderStatusValue', 'Select New Order Status' ,0


INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'RELEASE','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'PICKED','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'READYTOCHECK','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'CHECKING','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'CHECKED','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'CHECKED_BO','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'READYTOLOAD','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'LOADING','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'LOADED','OrderStatus' ,'OrderStatusValue'
INSERT INTO [dbo].[FunctionParameterLookup] ([Value],[FunctionName] ,[ParameterName])
SELECT 'DELIVERED','OrderStatus' ,'OrderStatusValue'
:setvar root "\Functions\OrderProgressOrderStatus"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\FunctionConfiguration.sql
:r $(path)$(root)\FunctionOrderProgressOrderStatus.sql




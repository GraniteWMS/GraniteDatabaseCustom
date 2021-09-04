:setvar GraniteDatabase "Granite"
:setvar PATH "C:\GraniteInstalls\GraniteDatabaseCustom"

USE [$(GraniteDatabase)]
GO

:r $(path)\Scripts\PrescriptOrderCheckNumberOfLabels.sql
:r $(path)\Scripts\PreScriptOrderCheckDocumentDisplayAccpacStatus.sql
:r $(path)\Scripts\PreScriptOrderCheckDisplayShipLabelInstruction.sql
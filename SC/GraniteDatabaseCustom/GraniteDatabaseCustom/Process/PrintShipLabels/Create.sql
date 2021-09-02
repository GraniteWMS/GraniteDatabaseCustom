:setvar GraniteDatabase "GraniteDatabase"
:setvar ERPDatabaseName "EVO"
:setvar PATH "C:\GraniteInstalls\GraniteDatabaseCustom"

USE [$(GraniteDatabase)]
GO

:r $(path)\Scripts\ProcessSteps.sql
:r $(path)\Scripts\PrescriptPrintShipLabelsQty.sql
:r $(path)\Scripts\PrescriptPrintShipLabelsDocument.sql
:r $(path)\Scripts\Label_ShipLabel.sql
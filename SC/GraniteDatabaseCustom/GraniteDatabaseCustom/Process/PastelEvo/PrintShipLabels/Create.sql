:setvar root "\Process\PastelEvo\PrintShipLabels\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\ProcessSteps.sql
:r $(path)$(root)\PrescriptPrintShipLabelsQty.sql
:r $(path)$(root)\PrescriptPrintShipLabelsDocument.sql
:r $(path)$(root)\Label_ShipLabel.sql
:setvar root "\Prescripts\Accpac\AccpacOrderCheck\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\PrescriptOrderCheckNumberOfLabels.sql
:r $(path)$(root)\PreScriptOrderCheckDocumentDisplayAccpacStatus.sql
:r $(path)$(root)\PreScriptOrderCheckDisplayShipLabelInstruction.sql
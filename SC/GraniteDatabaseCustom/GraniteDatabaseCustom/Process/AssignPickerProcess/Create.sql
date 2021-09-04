:setvar GraniteDatabase "Granite"
:setvar PATH "C:\GraniteInstalls\GraniteDatabaseCustom"

USE [$(GraniteDatabase)]
GO

:r $(path)\Scripts\Custom_AllocatePickerDocument.sql
:r $(path)\Scripts\Custom_AllocatePickerDocument_View.sql
:r $(path)\Scripts\ProcessSteps.sql
:r $(path)\Scripts\PrescriptAllocatePickerPicker.sql
:r $(path)\Scripts\PrescriptAllocatePickerLoad.sql
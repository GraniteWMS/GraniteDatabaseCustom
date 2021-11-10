:setvar root "\Process\AssignPickerProcess\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\Custom_AllocatePickerDocument.sql
:r $(path)$(root)\Custom_AllocatePickerDocument_View.sql
:r $(path)$(root)\ProcessSteps.sql
:r $(path)$(root)\PrescriptAllocatePickerPicker.sql
:r $(path)$(root)\PrescriptAllocatePickerLoad.sql
:r $(path)$(root)\PrescriptAllocatePickerDocument.sql
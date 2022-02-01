:setvar root "\Process\PalletStockTake\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\Custom_Pallet_Counted.sql
:r $(path)$(root)\PrescriptPalletStockTakePalletConfirmation.sql
:r $(path)$(root)\PrescriptPalletStockTakeTrackingEntity.sql
:r $(path)$(root)\ProcessSteps.sql

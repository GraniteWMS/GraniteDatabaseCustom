:setvar root "\Process\DeliveryNotification\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\ProcessSteps.sql
:r $(path)$(root)\PrescriptDeliveryNotifyLocation.sql
:r $(path)$(root)\PrescriptDeliveryNotifyDocument.sql
:r $(path)$(root)\PrescriptDeliveryNotifyReference.sql
:r $(path)$(root)\PrescriptDeliveryNotifyConfirmation.sql
:r $(path)$(root)\PrescriptDeliveryNotifyStep200.sql
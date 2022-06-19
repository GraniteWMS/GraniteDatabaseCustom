:setvar root "\Process\DeliveryNotificationHACCP\Scripts"

USE [$(GraniteDatabase)]
GO

:r $(path)$(root)\HACCPHeader.sql
:r $(path)$(root)\HACCPInspection.sql
:r $(path)$(root)\ProcessSteps.sql
:r $(path)$(root)\PrescriptDeliveryNotifyHACCPLocation.sql
:r $(path)$(root)\PrescriptDeliveryNotifyHACCPDocument.sql
:r $(path)$(root)\PrescriptDeliveryNotifyHACCPReference.sql
:r $(path)$(root)\PrescriptDeliveryNotifyHACCPConfirmation.sql
:r $(path)$(root)\PrescriptDeliveryNotifyHACCPStep200.sql
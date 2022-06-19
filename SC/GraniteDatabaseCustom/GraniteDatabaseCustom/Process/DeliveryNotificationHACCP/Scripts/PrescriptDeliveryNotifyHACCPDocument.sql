
/****** Object:  StoredProcedure [dbo].[PrescriptDeliveryNotifyHACCPDocument]    Script Date: 6/19/2022 7:22:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[PrescriptDeliveryNotifyHACCPDocument] (
   @input dbo.ScriptInputParameters READONLY
)
AS

DECLARE @Output TABLE(
  Name varchar(max),
  Value varchar(max)
  )

SET NOCOUNT ON;
DECLARE @ERPAvailable bit = 0		--

DECLARE @valid bit = 1
DECLARE @message varchar(MAX) = ''
DECLARE @User varchar(50) =  (SELECT Value FROM @input WHERE Name = 'User')
DECLARE @stepInput varchar(MAX)  = (SELECT UPPER(LTRIM(Value)) FROM @input WHERE Name = 'StepInput' )
DECLARE @GraniteDocumentType varchar(30) = 'RECEIVING'
DECLARE @GraniteIntegrationQueueStatus varchar(30) = 'ENTERED'
DECLARE @Document varchar(50) = @StepInput
DECLARE @Erp_id Decimal(20,0)

IF EXISTS(SELECT ID FROM Document WHERE Number = @Document)
BEGIN
		IF @ERPAvailable = 1
		BEGIN
			SELECT @Erp_id = ERPIdentification FROM Document WHERE Number = @Document
			IF isnull(@Erp_id,0) > 0
				INSERT INTO IntegrationDocumentQueue(ERP_id, DocumentNumber, DocumentType, Status,LastUpdateDateTime)
				SELECT @Erp_id, @Document, @GraniteDocumentType,@GraniteIntegrationQueueStatus, getdate()
				WHERE NOT EXISTS(SELECT ID FROM IntegrationDocumentQueue WHERE DocumentNumber  = @Document AND DocumentType = @GraniteDocumentType AND [Status] = @GraniteIntegrationQueueStatus)
		END
		SELECT @message = 'The PO Document is in Granite'
		SELECT @valid = 1		--Set to 0 if you are required to validate the Document on delivery

END
ELSE
BEGIN
	IF @ERPAvailable = 0
	BEGIN
		SELECT @message = 'The PO is not in the system'
		SELECT @valid = 1		--Set to 0 if you are required to validate the Document on delivery
	END
	ELSE
	BEGIN
		--Check if it exists in the ERP
		--SAGE300
		--SELECT @Erp_id = OrdSeq  FROM [$AccpacDatase].dbo.POPORH1 with (nolock) WHERE Document = @Document
		----SAP BO
		--SELECT @Erp_id = OrdSeq  FROM [$AccpacDatase].dbo.POPORH1 with (nolock) WHERE Document = @Document
		----SAGE 200 (EVO)
		--SELECT @Erp_id = OrdSeq  FROM [$AccpacDatase].dbo.POPORH1 with (nolock) WHERE Document = @Document
		----SYSPRO
		--SELECT @Erp_id = OrdSeq  FROM [$AccpacDatase].dbo.POPORH1 with (nolock) WHERE Document = @Document


		--IF isnull(@ERP_id,0) > 0
		--BEGIN
		--	INSERT INTO IntegrationDocumentQueue(ERP_id, DocumentNumber, DocumentType, Status,LastUpdateDateTime)
		--	SELECT (@Erp_id, @Document, @GraniteDocumentType,@GraniteIntegrationQueueStatus, getdate())
		--END
		--ELSE
		--BEGIN
		--	--The Document is not in the ERP System -either validate and show error, or continue
		--	SELECT @message = 'The PO is not in the system'
			SELECT @valid = 1		--Set to 0 if you are required to validate the Document on delivery
		--END
	END

END








INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output


GO



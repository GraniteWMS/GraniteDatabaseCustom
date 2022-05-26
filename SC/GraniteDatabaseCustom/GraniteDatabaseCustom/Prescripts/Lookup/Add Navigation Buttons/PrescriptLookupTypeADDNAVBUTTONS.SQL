

/****** Object:  StoredProcedure [dbo].[PrescriptLookupTypeADDNAVBUTTONS]    Script Date: 5/26/2022 4:53:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Add this Prescript to the Lookup Type to add the much needed ADJUSTMENT and SCRAP navigation buttons.
--Remember to set your IP and Port of your webapp before deployment.

CREATE PROCEDURE [dbo].[PrescriptLookupTypeADDNAVBUTTONS]
    (
    @input dbo.ScriptInputParameters READONLY
)
AS
DECLARE @Output TABLE(
    Name varchar(max),
    Value varchar(max)  
  )

SET NOCOUNT ON;

DECLARE @valid bit = 1
DECLARE @message varchar(MAX) = ''
DECLARE @stepInput varchar(50) = (SELECT Value FROM @input WHERE Name = 'StepInput')
DECLARE @user varchar(50) = (SELECT Value FROM @input WHERE Name = 'User')
DECLARE @printer varchar(50) = (SELECT Value FROM @input WHERE Name = 'Printer')
DECLARE @Document varchar(50) = ''
Declare @IPandPORT varchar(20) = '192.168.1.239:40086'


Insert Into @Output
SELECT 'Instruction',CONCAT('<a href="http://',@IPandPORT,'/ADJUSTMENT?processName=ADJUSTMENT" class="btn btn-primary">ADJUSTMENT</a>','        ','<a href="http://',@IPandPORT,'/SCRAP?processName=SCRAP" class="btn btn-primary">SCRAP</a>') --- ADDS A BUTTON


INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT *
FROM @Output


GO



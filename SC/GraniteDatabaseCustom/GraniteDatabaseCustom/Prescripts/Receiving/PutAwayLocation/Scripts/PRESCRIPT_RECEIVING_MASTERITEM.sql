/*
Path : Receiving.MasterItem
	
Description : The purpose of this PRESCRIPT is to display the current location of the oldest active 
TrackingEntity in the warehouse after entering the Item code and Quantity in Receiving.

Dependency : FN_GetPutawayLocation

Function: 
ALTER 
VALIDATE
MESSAGE
*/
CREATE PROCEDURE [dbo].[PRESCRIPT_RECEIVING_MASTERITEM] (
   @input dbo.ScriptInputParameters READONLY
)
AS
DECLARE @Output TABLE(
  Name varchar(max),  
  Value varchar(max)  
  )

SET NOCOUNT ON;

DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
DECLARE @MasterItemCode varchar(max)
DECLARE @PutawayLocation varchar(50)

SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput'
SELECT @MasterItemCode = @stepInput

SELECT TOP 1 @PutawayLocation = dbo.FN_GetPutawayLocation(@MasterItemCode)

SELECT @valid = 1                  
SELECT @message = 'This item is currently stored in location:' + @PutawayLocation   

INSERT INTO @Output
SELECT 'Message', @message
INSERT INTO @Output
SELECT 'Valid', @valid
INSERT INTO @Output
SELECT 'StepInput', @stepInput

SELECT * FROM @Output

GO
CREATE FUNCTION [dbo].[FN_GetPutawayLocation]  (@MasterItemCode varchar(max))
RETURNS varchar(30)
AS
BEGIN
DECLARE @ReturnLocation varchar(50)
DECLARE @MasterItem_id bigint

--Check if there is an Alias with this entered code and change to the associated masteritem
IF EXISTS(SELECT ID FROM MasterItemAlias_View WHERE Code = @MasterItemCode)
BEGIN
	SELECT @MasterItem_id = MasterItem_id FROM MasterItemAlias_View WHERE Code = @MasterItemCode		
END
ELSE 
	SELECT @MasterItem_id = ID FROM MasterItem WHERE Code = @MasterItemCode or FormattedCode = @MasterItemCode

--This query gets the location of the oldest active Tracking Entity in the warehouse matching the entered MasterItem Code
SELECT TOP 1 @ReturnLocation = L.Barcode 
FROM TrackingEntity TE INNER JOIN Location L on TE.Location_id = L.ID 
WHERE TE.Qty >0 and InStock = 1 and L.NonStock = 0
and TE.MasterItem_id = @MasterItem_id
ORDER BY CreatedDate

--The Item does exist but the location for it was not found.
SELECT @ReturnLocation = isnull(@ReturnLocation,'NO LOCATION FOUND')  

RETURN @ReturnLocation

END

GO
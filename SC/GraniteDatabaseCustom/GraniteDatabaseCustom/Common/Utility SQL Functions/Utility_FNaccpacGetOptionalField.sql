
/****** Object:  UserDefinedFunction [dbo].[FN_SAGE_GetUDF]    Script Date: 11/3/2022 11:06:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Craig Collins
-- Create date: 3 November 2022
-- Description:	Get an Optional Field 
-- Usage: Get an ACCPAC optional Field Value for a specific KEYNAME, AND Optional field Type with a lookup value.  The Lookup Value is specific to the Type
-- for example - An order number if Type is ORDER and Item code (unformatted) if Type is ITEM
-- eg: SELECT [dbo].[Utility_FNaccpacGetOptionalField] ('DEPT','ITEM', '00000111000')


--TODO: Add the ACCPAC Database as a single variable
-- =============================================
CREATE FUNCTION [dbo].[Utility_FNaccpacGetOptionalField]
(
	-- This funtion returns the standard Item Cube * Qty Entered in as a Cubic value for the Function
	@OPTName varchar(50), --DEPT, HSCODE, TRUCK, SHELFLIFE
	@OptType varchar(50),	--What type of Optional Field (ITEM = ICITEMO, ORDER = OEORDHO)
	@LookupData varchar(50) --ITEMNO	--Example -= '2005670005193'
)
RETURNS Varchar(255)
AS
BEGIN
	DECLARE @ReturnValue varchar(255) = ''
	IF @OptType =  'ITEM'
		SELECT @ReturnValue = [VALUE] FROM ACCLTD.dbo.ICITEMO WHERE OPTFIELD = @OPTName AND ITEMNO = @LookupData

	IF @OptType =  'ORDER'
		SELECT @ReturnValue = [VALUE] FROM ACCLTD.dbo.OEORDHO
		WHERE OPTFIELD = @OPTName AND 
		ORDUNIQ = (SELECT ORDUNIQ FROM ACCLTD.dbo.OEORDH WHERE ORDNUMBER =  @LookupData)


	RETURN @ReturnValue



END


GO


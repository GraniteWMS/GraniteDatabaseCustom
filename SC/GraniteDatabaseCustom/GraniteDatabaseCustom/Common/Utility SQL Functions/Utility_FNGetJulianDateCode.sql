
/****** Object:  UserDefinedFunction [dbo].[fnGetPickedQty]    Script Date: 7/28/2022 9:46:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[Utility_FNGetJulianDatecode]
(
	
	
)
RETURNS varchar(3)
AS
BEGIN
DECLARE @JulianDateCode varchar(10) = (SELECT CONVERT(varchar(3), datepart(dy, getdate())))
SELECT @JulianDateCode =  SUBSTRING('000', 1,3 - LEN(@JulianDateCode)) + @JulianDateCode
 
RETURN @JulianDateCode

END

GO



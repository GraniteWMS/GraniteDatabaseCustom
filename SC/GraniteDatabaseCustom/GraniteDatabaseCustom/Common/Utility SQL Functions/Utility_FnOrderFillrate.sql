
/****** Object:  UserDefinedFunction [dbo].[Utility_FnOrderFillrate]    Script Date: 7/25/2022 5:40:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Utility_FnOrderFillrate]  (@Document_id BIGINT)
RETURNS Decimal(6,2)
AS
BEGIN

DECLARE @FillRate Decimal(6,2)
DECLARE @OrderTotal Decimal(6,2)
DECLARE @OrderFilled Decimal(6,2)

SELECT @OrderTotal = SUM(Qty) FROM DocumentDetail WHERE Document_id = @Document_id
SELECT @OrderFilled = SUM(PackedQty) FROM DocumentDetail WHERE Document_id = @Document_id

IF isnull(@OrderTotal,0) > 0
	SELECT @FillRate = (@OrderFilled/@OrderTotal)  *100 
ELSE 
	SELECT @FillRate = 0

RETURN @FillRate

END


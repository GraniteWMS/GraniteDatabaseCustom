
/****** Object:  UserDefinedFunction [dbo].[FN_PICKSEQACCPAC]    Script Date: 7/11/2022 9:44:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FN_PICKSEQACCPAC] (@MasterItem_id varchar(50), @ERPLocation varchar(30)) 
RETURNS varchar(30) 
AS 
BEGIN 
	DECLARE @Return varchar(30)
	SELECT TOP 1  @Return =PICKINGSEQ FROM API_QueryInventoryVariance WHERE MasterItemCode = (SELECT CODE FROM MasterItem WHERE ID = @MasterItem_id) 
	AND ERPLocation = @ERPLocation

    RETURN @Return 
END
GO


--Update the View to contain the PickingSequence.
--Add this field to ERPStockOnHand - 
/*SELECT        FLSDAT.dbo.ICILOC.LOCATION, FLSDAT.dbo.ICILOC.ITEMNO, CAST(FLSDAT.dbo.ICILOC.QTYONHAND - FLSDAT.dbo.ICILOC.QTYSHNOCST + FLSDAT.dbo.ICILOC.QTYADNOCST + FLSDAT.dbo.ICILOC.QTYRENOCST AS DECIMAL(18,
                          2)) AS QTYONHAND, CAST(FLSDAT.dbo.ICILOC.QTYONORDER AS DECIMAL(18, 2)) AS QTYONORDER, CAST(FLSDAT.dbo.ICILOC.QTYSALORDR AS DECIMAL(18, 2)) AS QTYSALORDR, 
                         CAST(FLSDAT.dbo.ICILOC.COSTOFFSET / (CASE WHEN QTYOFFSET = 0 THEN 1 ELSE QTYOFFSET END) AS DECIMAL(18, 2)) AS AVRCOST, FLSDAT.dbo.ICILOC.PICKINGSEQ
FROM            FLSDAT.dbo.ICILOC INNER JOIN
                         dbo.MasterItem ON FLSDAT.dbo.ICILOC.ITEMNO COLLATE DATABASE_DEFAULT = dbo.MasterItem.Code COLLATE DATABASE_DEFAULT
WHERE        (FLSDAT.dbo.ICILOC.LOCATION = 'MW')
/*
--Add this field to API_QueryInventoryVariance
/*SELECT        ISNULL(dbo.MasterItem.Code, dbo.Base_Inventory_Summary.Code) AS MasterItemCode, ISNULL(dbo.MasterItem.Description, dbo.Base_Inventory_Summary.Item) AS Description, 
                         ISNULL(dbo.Base_Inventory_Summary.QtyOnHand, 0) AS WarehouseQty, ISNULL(dbo.ERP_StockOnHand.QTYONHAND, 0) AS ERPQty, ISNULL(dbo.ERP_StockOnHand.QTYONORDER, 0) AS PurchaseOrder, 
                         ISNULL(dbo.ERP_StockOnHand.QTYSALORDR, 0) AS SalesOrder, ISNULL(dbo.Base_Inventory_Summary.QtyOnHand, 0) - ISNULL(dbo.ERP_StockOnHand.QTYONHAND, 0) AS Discrepancy, 
                         ISNULL(dbo.Base_Inventory_Summary.QtyOnHand, 0) - CAST(dbo.ERP_StockOnHand.QTYONHAND AS DECIMAL(18, 2)) - CAST(dbo.ERP_StockOnHand.QTYSALORDR AS DECIMAL(18, 2)) AS SODiscrepancy, 
                         ((CASE WHEN CAST(ISNULL(dbo.Base_Inventory_Summary.QtyOnHand, 0) AS DECIMAL(18, 2)) = CAST(ISNULL(dbo.[ERP_StockOnHand].QTYONHAND, 0) AS DECIMAL(18, 2)) THEN 'GOOD' ELSE 'DISCREPANCY' END)) AS Status, 
                         CAST(((CASE WHEN ISNULL(dbo.[ERP_StockOnHand].QTYONHAND, 0) > ISNULL(Base_Inventory_Summary.QtyOnHand, 0) THEN (((dbo.Base_Inventory_Summary.QtyOnHand) 
                         / (CASE WHEN ISNULL((dbo.[ERP_StockOnHand].QTYONHAND), 0) = 0 THEN 1 ELSE ISNULL((dbo.[ERP_StockOnHand].QTYONHAND), 0) END)) * 100) WHEN ISNULL(dbo.[ERP_StockOnHand].QTYONHAND, 0) 
                         = ISNULL(Base_Inventory_Summary.QtyOnHand, 0) THEN 0 ELSE (((CASE WHEN ISNULL((dbo.[ERP_StockOnHand].QTYONHAND), 0) = 0 THEN 1 ELSE ISNULL((dbo.[ERP_StockOnHand].QTYONHAND), 0) END) 
                         / (CASE WHEN ISNULL((dbo.Base_Inventory_Summary.QtyOnHand), 0) = 0 THEN 1 ELSE (dbo.Base_Inventory_Summary.QtyOnHand) END)) * 100) END)) AS decimal(18, 2)) AS Percentage, dbo.Base_Inventory_Summary.Site, 
                         ISNULL(dbo.Base_Inventory_Summary.ERPLocation, dbo.ERP_StockOnHand.LOCATION) AS ERPLocation, dbo.Base_Inventory_Summary.Category, dbo.Base_Inventory_Summary.Type, 
                         dbo.ERP_StockOnHand.PICKINGSEQ
FROM            dbo.MasterItem LEFT OUTER JOIN
                         dbo.ERP_StockOnHand ON dbo.MasterItem.Code = dbo.ERP_StockOnHand.ITEMNO COLLATE DATABASE_DEFAULT FULL OUTER JOIN
                         dbo.Base_Inventory_Summary ON dbo.MasterItem.Code = dbo.Base_Inventory_Summary.Code AND dbo.ERP_StockOnHand.LOCATION COLLATE DATABASE_DEFAULT = dbo.Base_Inventory_Summary.ERPLocation
*/

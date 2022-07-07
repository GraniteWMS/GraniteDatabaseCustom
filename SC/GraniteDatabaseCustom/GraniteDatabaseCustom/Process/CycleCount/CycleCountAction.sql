USE [Granite2022]
GO

/****** Object:  Table [dbo].[CycleCountAction]    Script Date: 7/7/2022 4:36:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CycleCountAction](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CycleCountSession] [varchar](50) NOT NULL,
	[ScanDate] [datetime] NOT NULL,
	[ERPQty] [decimal](19, 4) NULL,
	[MasterItem_id] [bigint] NOT NULL,
	[MasterItemCode] [varchar](50) NULL,
	[MasterItemQty] [decimal](19, 4) NULL,
	[TrackingEntity_id] [bigint] NOT NULL,
	[TrackingEntity] [varchar](20) NULL,
	[Batch] [varchar](50) NULL,
	[ExpiryDate] [date] NULL,
	[SerialNumber] [varchar](50) NULL,
	[ManufactureDate] [date] NULL,
	[Location_id] [bigint] NOT NULL,
	[LocationBarcode] [varchar](50) NULL,
	[CountLocation_id] [bigint] NULL,
	[CountLocationBarcode] [varchar](50) NULL,
	[Count1Qty] [decimal](19, 4) NULL,
	[Count2Qty] [decimal](19, 4) NULL,
	[Count1User] [varchar](50) NULL,
	[Count2User] [varchar](50) NULL,
	[ApprovedQty] [decimal](19, 4) NULL,
	[Status] [varchar](30) NULL,
	[LinkedTransaction_id] [bigint] NULL,
	[AuditDate] [datetime] NOT NULL,
	[AuditUser] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CycleCountAction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CycleCountAction] ADD  CONSTRAINT [DF_Table_1_CountDate]  DEFAULT (getdate()) FOR [ScanDate]
GO

ALTER TABLE [dbo].[CycleCountAction] ADD  CONSTRAINT [DF_CycleCountAction_AuditDate]  DEFAULT (getdate()) FOR [AuditDate]
GO


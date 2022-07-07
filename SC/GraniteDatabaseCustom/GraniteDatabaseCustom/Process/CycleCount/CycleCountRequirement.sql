USE [Granite2022]
GO

/****** Object:  Table [dbo].[CycleCountRequirement]    Script Date: 7/7/2022 4:38:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CycleCountRequirement](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[MasterItem_id] [bigint] NOT NULL,
	[MasterItemCode] [varchar](50) NULL,
	[Site] [varchar](30) NULL,
	[ERPLocation] [varchar](30) NULL,
	[QtyCreated] [decimal](19, 4) NULL,
	[ERPQtyCreated] [decimal](19, 4) NULL,
	[Status] [varchar](30) NOT NULL,
	[AuditDate] [datetime] NOT NULL,
	[AuditUser] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CycleCountRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CycleCountRequirement] ADD  CONSTRAINT [DF_CycleCountRequirement_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

ALTER TABLE [dbo].[CycleCountRequirement] ADD  CONSTRAINT [DF_CycleCountRequirement_Status]  DEFAULT ('ENTERED') FOR [Status]
GO

ALTER TABLE [dbo].[CycleCountRequirement] ADD  CONSTRAINT [DF_CycleCountRequirement_AuditDate]  DEFAULT (getdate()) FOR [AuditDate]
GO

ALTER TABLE [dbo].[CycleCountRequirement]  WITH CHECK ADD  CONSTRAINT [FK_CycleCountRequirement_MasterItem] FOREIGN KEY([MasterItem_id])
REFERENCES [dbo].[MasterItem] ([ID])
GO

ALTER TABLE [dbo].[CycleCountRequirement] CHECK CONSTRAINT [FK_CycleCountRequirement_MasterItem]
GO


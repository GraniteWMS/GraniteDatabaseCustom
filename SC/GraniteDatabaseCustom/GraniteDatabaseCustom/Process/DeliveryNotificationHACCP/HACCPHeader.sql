
/****** Object:  Table [dbo].[HACCPheader]    Script Date: 6/19/2022 6:41:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[HACCPheader](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Carrier] [varchar](50) NULL,
	[Truck] [varchar](50) NULL,
	[Driver] [varchar](50) NULL,
	[DeliveryReference] [varchar](50) NULL,
	[DateTimeStamp] [datetime] NULL,
	[ConditionClean] [varchar](250) NULL,
	[ConditionDamage] [varchar](250) NULL,
	[ConditionOdor] [varchar](250) NULL,
	[ConditionPests] [varchar](250) NULL,
	[TruckEnvironment] [varchar](50) NULL,
	[TruckTemperature] [varchar](50) NULL,
	[TruckTransitDuration] [varchar](50) NULL,
	[TradingPartnerCode] [varchar](50) NULL,
	[TradingPartnerName] [varchar](250) NULL,
	[TradingPartnerCountry] [varchar](50) NULL,
	[TradingPartnerApproval] [varchar](50) NULL,
	[TradingPartnerType] [varchar](50) NULL,
	[TradingPartnerDocumentType] [varchar](50) NULL,
	[ComplianceSpecReviewed] [varchar](1) NULL,
	[ComplianceHaccpProcessReviewed] [varchar](1) NULL,
	[ReviewedBy] [varchar](50) NULL,
	[Document] [varchar](50) NULL,
	[User] [varchar](50) NULL,
 CONSTRAINT [PK_HACCPheader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[HACCPheader] ADD  CONSTRAINT [DF_HACCPheader_TruckEnvironment]  DEFAULT ('AMBIENT') FOR [TruckEnvironment]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CLEAN or DIRTY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ConditionClean'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DAMAGED, NO DAMAGE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ConditionDamage'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NO ODOR, BAD ODOR, REJECTED' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ConditionOdor'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PESTS, NO PESTS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ConditionPests'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'AMBIENT, REFRIGERATED, ICED, FROZEN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'TruckEnvironment'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Store the Truck Temperature -can be in C or F depending on country
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'TruckTemperature'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record this in minutes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'TruckTransitDuration'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lookup and Select from Supplier List -Also populate the Name and Country prompts' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'TradingPartnerCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Approved, Not Approved (If not Approved then must review compliance spec and Haccp process)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'TradingPartnerApproval'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y or N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ComplianceSpecReviewed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y or N' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HACCPheader', @level2type=N'COLUMN',@level2name=N'ComplianceHaccpProcessReviewed'
GO


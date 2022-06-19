

/****** Object:  Table [dbo].[HACCPinspection]    Script Date: 6/19/2022 6:44:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[HACCPinspection](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateTimeStamp] [datetime] NULL,
	[User_id] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[Location_id] [bigint] NULL,
	[Location] [varchar](50) NULL,
	[MasterItem_id] [bigint] NULL,
	[MasterItemCode] [varchar](50) NULL,
	[TrackingEntity_id] [bigint] NULL,
	[TrackingEntityBarcode] [varchar](50) NULL,
	[Document_id] [bigint] NULL,
	[Document] [varchar](50) NULL,
	[DocumentLine_id] [bigint] NULL,
	[Reference] [varchar](50) NULL,
	[Comment] [varchar](250) NULL,
	[Temperature] [varchar](50) NULL,
	[Condition] [varchar](50) NULL,
	[AdditionalInformation] [varchar](max) NULL,
	[ResponsiblePersons] [varchar](250) NULL,
 CONSTRAINT [PK_HACCPinspection] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


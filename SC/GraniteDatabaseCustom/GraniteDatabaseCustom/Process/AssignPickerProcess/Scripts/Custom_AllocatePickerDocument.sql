CREATE TABLE [dbo].[Custom_AllocatePickerDocument](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocNumber] [varchar](30) NOT NULL,
	[Date] [datetime] NULL,
	[Picker] [varchar](30) NOT NULL
) ON [PRIMARY]

GO
PRINT '############### Table [Custom_AllocatePickerDocument] Done ###################'

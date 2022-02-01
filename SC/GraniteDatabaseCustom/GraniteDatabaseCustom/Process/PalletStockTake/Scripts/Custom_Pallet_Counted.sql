
CREATE TABLE [dbo].[Custom_Pallet_Counted](
 [ID] [bigint] IDENTITY(1,1) NOT NULL,
 [AuditDate] [datetime] NOT NULL,
 [StocktakeSession_id] [bigint] NOT NULL,
 [CarryEntity_id] [bigint] NOT NULL,
 [Count] [int] NULL
) ON [PRIMARY]
GO
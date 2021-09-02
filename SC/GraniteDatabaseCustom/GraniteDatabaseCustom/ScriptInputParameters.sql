--IF OBJECT_ID('dbo.ScriptInputParameters', 'T') IS NOT NULL  
--    DROP PROCEDURE dbo.ScriptInputParameters;  
--GO  
CREATE TYPE dbo.ScriptInputParameters AS TABLE
(
   Name NVARCHAR(50) NOT NULL,
   Value  NVARCHAR(250)
);
GO
CREATE PROCEDURE [dbo].[HTTP_POST]
	-- Add the parameters for the stored procedure here
	@URL varchar(8000),
	--@Body varchar(8000),
	@HttpStatus varchar(60) OUTPUT,
	@HttpStatusText varchar(60) OUTPUT,
	@HttpResponseText varchar(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- DECLARE @UserName varchar(30) = 'Granite'
	-- DECLARE @Password varchar(100) = 'gR@n1t364!'
	
	DECLARE @contentType NVARCHAR(64);
	DECLARE @responseText VARCHAR(8000);
	DECLARE @ret INT;
	DECLARE @status NVARCHAR(32);
	DECLARE @statusText NVARCHAR(32);
	DECLARE @authHeader VARCHAR(100);   
	DECLARE @token INT;
	DECLARE @Len int

    -- Insert statements for procedure here
	-- SELECT @authHeader = dbo.FN_BasicAuthHeader(@UserName, @Password)

	SET @contentType = 'application/json';
	-- Set your url 
	
	-- Open a connection
	EXEC @ret = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT;
	IF @ret <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1);
	-- make a request
	EXEC @ret = sp_OAMethod @token, 'open', NULL, 'POST', @url, 'false';
	EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Content-type', @contentType;
	-- EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Authorization', @authHeader;
	EXEC @ret = sp_OASetProperty @token,'setTimeouts','120000','120000','120000','120000'
	EXEC @ret = sp_OAMethod @token, 'send', NULL
	-- Handle response
	EXEC @ret = sp_OAGetProperty @token, 'status', @status OUT;
	EXEC @ret = sp_OAGetProperty @token, 'statusText', @statusText OUT;
	EXEC @ret = sp_OAGetProperty @token, 'responseText', @responseText OUT;

	SELECT @HttpStatus = @status, @HttpStatusText = @statusText, @HttpResponseText = @responseText

	EXEC sp_OADestroy @ret

	RETURN

END
GO

sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'Database Mail XPs', 1;  
GO  
RECONFIGURE  
GO  

--Configuring system mail
EXECUTE msdb.dbo.sysmail_add_account_sp
	@account_name = 'Granite',
	@description = 'Mail account for sending Granite reports',
	@email_address = 'info@granitewms.com',
	@display_name = 'Granite Automated Mailer',
	@mailserver_name = 'smtp.gmail.com',
	@port = 587,
	@username = 'info@granitewms.com',
	@password = 'GraniteInformation2020'

	--EXECUTE msdb.dbo.sysmail_delete_account_sp  @account_id = 1

	EXECUTE msdb.dbo.sysmail_update_account_sp
		@account_id = 1,
		@account_name = 'Granite',
	@description = 'Mail account for sending Granite reports',
	@email_address = 'info@granitewms.com',
	@display_name = 'Granite Automated Mailer',
	@mailserver_name = 'smtp.gmail.com',
	@port = 587,
	@username = 'info@granitewms.com',
	@password = 'GraniteInformation2020',
	@enable_ssl = 1

EXECUTE msdb.dbo.sysmail_add_profile_sp
	@profile_name = 'Granite'

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
	@profile_name = 'Granite',
	@account_name = 'Granite',
	@sequence_number = 1

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp 
	@profile_name = 'Granite',
	@principal_name = 'public',
	@is_default = 1

EXECUTE msdb.dbo.sysmail_start_sp

GO
sp_configure 'show advanced options', 0;  
GO  
RECONFIGURE;  
GO
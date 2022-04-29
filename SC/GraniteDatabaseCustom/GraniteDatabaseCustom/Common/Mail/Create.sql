:setvar root "\Common\Mail\StoredProcedure"
:setvar path "C:\GraniteInstalls\GraniteDatabaseCustom"
:setvar GraniteDatabase "Granite"
:setvar AccpacDatabase "ACCDAT"

USE [$(GraniteDatabase)]
GO

-- requirement SqlToHtmlPath
:r $(path)\Common\Mail\Account.sql
:r $(path)\Common\SqlToHtml\Create.sql

:r $(path)$(root)\Mail_JOBCompanyDailyProduction.sql
:r $(path)$(root)\Mail_MOProgress.sql
:r $(path)$(root)\Mail_TransactionsPicked.sql
:r $(path)$(root)\Mail_TransactionsReceiving.sql
:r $(path)$(root)\Mail_TransactionsReceivingReceipt.sql
:r $(path)$(root)\Mail_TransactionsTransfer.sql
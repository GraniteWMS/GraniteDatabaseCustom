 -- _____             _____           _       _       
 --|  __ \           / ____|         (_)     | |      
 --| |__) | __ ___  | (___   ___ _ __ _ _ __ | |_ ___ 
 --|  ___/ '__/ _ \  \___ \ / __| '__| | '_ \| __/ __|
 --| |   | | |  __/  ____) | (__| |  | | |_) | |_\__ \
 --|_|   |_|  \___| |_____/ \___|_|  |_| .__/ \__|___/
 --                                    | |            
 --                                    |_|            
 -- UNCOMMENT the scripts you would like to create

:setvar GraniteDatabase "Granite"
:setvar PastelEVODatabase "EVO"
:setvar AccpacDatabase "ACCDAT"
:setvar PATH "C:\GraniteInstalls\GraniteDatabaseCustom"

USE [$(GraniteDatabase)]
GO


-- MOVE       DisplayTrackingEntities
-- :r $(path)\Prescripts\Move\DisplayTrackingEntities\Create.sql

-- PICKING    UpdatePickRecommendation
-- :r $(path)\Prescripts\Picking\UpdatePickRecommendation\Create.sql

-- RECEIVING  PutAwayLocation
-- :r $(path)\Prescripts\Receiving\PutAwayLocation\Create.sql


--    _    ____ ____ ____   _    ____ 
--   / \  / ___/ ___|  _ \ / \  / ___|
--  / _ \| |  | |   | |_) / _ \| |    
-- / ___ \ |__| |___|  __/ ___ \ |___ 
--/_/   \_\____\____|_| /_/   \_\____|
                                     

-- ADJUSTMENT UpdateAccpacJournal (SilentStep)
-- :r $(path)\Prescripts\Accpac\AccpacAdjustment\Create.sql
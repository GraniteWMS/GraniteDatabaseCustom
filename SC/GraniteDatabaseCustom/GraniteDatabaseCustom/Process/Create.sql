 -- _____                                       
 --|  __ \                                      
 --| |__) | __ ___   ___ ___  ___ ___  ___  ___ 
 --|  ___/ '__/ _ \ / __/ _ \/ __/ __|/ _ \/ __|
 --| |   | | | (_) | (_|  __/\__ \__ \  __/\__ \
 --|_|   |_|  \___/ \___\___||___/___/\___||___/
 
 -- UNCOMMENT the scripts you would like to create

:setvar GraniteDatabase "Granite"
:setvar PastelEVODatabase "EVO"
:setvar PATH "C:\GraniteInstalls\GraniteDatabaseCustom"

USE [$(GraniteDatabase)]
GO

-- AssignPickerProcess (Print Ship label)
-- :r $(path)\Process\AssignPickerProcess\Create.sql

-- ____           _       _   _______     _____  
--|  _ \ __ _ ___| |_ ___| | | ____\ \   / / _ \ 
--| |_) / _` / __| __/ _ \ | |  _|  \ \ / / | | |
--|  __/ (_| \__ \ ||  __/ | | |___  \ V /| |_| |
--|_|   \__,_|___/\__\___|_| |_____|  \_/  \___/ 
                                                

-- PrintShipLabels 
-- :r $(path)\PastelEvo\Process\PrintShipLabels\Create.sql

--    _    ____ ____ ____   _    ____ 
--   / \  / ___/ ___|  _ \ / \  / ___|
--  / _ \| |  | |   | |_) / _ \| |    
-- / ___ \ |__| |___|  __/ ___ \ |___ 
--/_/   \_\____\____|_| /_/   \_\____|

-- AccpacOrderCheck
-- :r $(path)\Process\Accpac\PrintShipLabels\Create.sql
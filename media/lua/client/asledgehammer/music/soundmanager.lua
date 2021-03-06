--------------------------------------------------------------------------------------
--  ######   #######  ##     ## ##    ## ########     ##     ##  ######   ########  --
-- ##    ## ##     ## ##     ## ###   ## ##     ##    ###   ### ##    ##  ##     ## --
-- ##       ##     ## ##     ## ####  ## ##     ##    #### #### ##        ##     ## --
--  ######  ##     ## ##     ## ## ## ## ##     ##    ## ### ## ##   #### ########  --
--       ## ##     ## ##     ## ##  #### ##     ##    ##     ## ##    ##  ##   ##   --
-- ##    ## ##     ## ##     ## ##   ### ##     ##    ##     ## ##    ##  ##    ##  --
--  ######   #######   #######  ##    ## ########     ##     ##  ######   ##     ## --
--------------------------------------------------------------------------------------

PZ_SOUND_MANAGER = getSoundManager();

-----------------------------------------------------------------

stopSoundManager = function() getSoundManager():stop() end

-----------------------------------------------------------------

getPZVolume = function() return getSoundManager():getMusicVolume() end

-----------------------------------------------------------------

setPZVolume = function(volume) getSoundManager():setMusicVolume(volume) end

-----------------------------------------------------------------

stopPZMusic = function() end

-----------------------------------------------------------------

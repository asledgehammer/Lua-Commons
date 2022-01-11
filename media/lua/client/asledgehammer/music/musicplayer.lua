--------------------------------------------------------------------------------------
-- @author Jab
-- 
-- FIXME: Add time to the pause menu to prevent desync.
--------------------------------------------------------------------------------------

-- asledgehammer --------------------------
require 'asledgehammer/util'              ;
require 'asledgehammer/class'             ;
require 'asledgehammer/music/musictrack'  ;
require 'asledgehammer/music/sampledata'  ;
require 'asledgehammer/music/soundmanager';
-------------------------------------------

-- Check to see if the java client mod is installed.
local JAVA_MOD_INSTALLED = WavData ~= nil;

---------------------------------------------------------------------------------------------------------
-- ##     ## ##     ##  ######  ####  ######  ########  ##          ###    ##    ## ######## ########  --
-- ###   ### ##     ## ##    ##  ##  ##    ## ##     ## ##         ## ##    ##  ##  ##       ##     ## --
-- #### #### ##     ## ##        ##  ##       ##     ## ##        ##   ##    ####   ##       ##     ## --
-- ## ### ## ##     ##  ######   ##  ##       ########  ##       ##     ##    ##    ######   ########  --
-- ##     ## ##     ##       ##  ##  ##       ##        ##       #########    ##    ##       ##   ##   --
-- ##     ## ##     ## ##    ##  ##  ##    ## ##        ##       ##     ##    ##    ##       ##    ##  --
-- ##     ##  #######   ######  ####  ######  ##        ######## ##     ##    ##    ######## ##     ## --
---------------------------------------------------------------------------------------------------------

local MUSIC_PLAYER = nil;

function getMusicPlayer()
	if MUSIC_PLAYER == nil then
		MUSIC_PLAYER = MusicPlayer(); 
		MUSIC_PLAYER:_registerEvents();
	end
	return MUSIC_PLAYER;
end

MusicPlayer = class(function(o) 
	o._emitter          = FMODSoundEmitter.new()             ;
	o._emitterVolume    = 1.0                                ;
	o._playing          = {--[[ Map<String, MusicTrack> --]]};
	o._music_tracks     = {--[[ Map<String, MusicTrack> --]]};
	o._volume           = getPZVolume()                      ;
	o.disable_pz_music  = false                              ;

end);

-- CONSTANTS -----------------------------------------

MusicPlayer.DEBUG = false;
MusicPlayer.HEADER = '[MusicPlayer]: ';
MusicPlayer.MUSIC_DIRECTORY = 'media/sound/music/';

-------------------------------------------------------

function MusicPlayer:__tostring()
	return tPrint(self);
end

function MusicPlayer:_registerEvents()
	
	Events.OnLoad.Add(function() 
		self:stopAllTracks()
	end);
	
	Events.OnInitWorld.Add(function()
		self:stopAllTracks();
	end);
	
	Events.OnFETick.Add(function() 
		self:update(false);
	end);
	
	-- Events.OnTick.Add(function() self:update(false) end);
	
	Events.OnTickEvenPaused.Add(function() 
		self:update(isGamePaused());
	end);

	Events.OnMainMenuEnter.Add(function()
		if self.disable_pz_music then 
			stopSoundManager();
		end 
	end);


end

function MusicPlayer:loadTrack(mod_id, id, file_type)

	local path = MusicPlayer.MUSIC_DIRECTORY..id;

	local sample_data = nil;

	if JAVA_MOD_INSTALLED then
		sample_data = WavData.read(mod_id, path..'.wavdata');
		-- sample_data = SampleData.readFile(mod_id, path..'.lua');
	end

	local track = MusicTrack(self, mod_id, id, path..id..'.'..file_type, sample_data);
	self._music_tracks[id] = track;

	return track;
end

-------------------------------------------------------

function MusicPlayer:update(paused)
	self:updateVolume();
	self:updateTracks()
	self._emitter:tick();
end

function MusicPlayer:updateVolume()

	local pz_volume = getPZVolume();

	if pz_volume > 0.0 then
		
		self._volume = pz_volume;

		if self.disable_pz_music then 
			-- Disable Project Zomboid's music by setting their volume to zero.
			setPZVolume(0.0);
			getSoundManager():StopMusic();
		end

	else

    if not self.disable_pz_music 
      and pz_volume == 0.0 
      and self._volume ~= 0.0 then

      -- Restore Project Zomboid's internal music volume.
      setPZVolume(self._volume);
    end

	end
end

function MusicPlayer:updateTracks()

	-- Update all playing tracks --
	for key, value in pairs(self._playing) do
		value:update();
	end

end

-------------------------------------------------------

function MusicPlayer:playTrack(track, volume, ticks)

	track = self:_verifyTrackArg(track);

	-- Default values --
	if volume == nil then volume = 1.0 end
	if ticks == nil then ticks = 0 end

	-- Clamp Values --
	volume = clamp(volume, 0.0, 1.0);
	if ticks < 0 then ticks = 0 end

	-- Stop track if playing already.
	if self:isPlayingTrack(track) then self:stopTrack(track) end
	print(MusicPlayer.HEADER.."Playing Track: "..tostring(track._id));

	triggerEvent('MusicTrackStarting', track);

	if ticks == 0 then

		track:resetMetadata();

		-- Set MusicTrack Fields --
		track._volume = volume;

		triggerEvent('MusicTrackStarted', track);

	else

		-- Track Starting Metadata --
		track._starting.running       = true  ;
		track._starting.ticks_started = ticks ;
		track._starting.ticks         = 0     ;
		track._starting.volume        = volume;

		track._volume = 0.0;

	end

	local clip = track._sound:getRandomClip();

	track._channel = self._emitter:playClip(clip, nil);

	-- Set the time to be tracked.
	track._time.started = math.floor(1000 * os.time());
	track._time.completed = 0;

	self._playing[track._id] = track;

end

function MusicPlayer:stopTrack(track, ticks)

	track = self:_verifyTrackArg(track);

	if ticks == nil then ticks = 0 end
	if ticks < 0 then ticks = 0 end

	-- Make sure the track is playing to stop it.
	if not self:isPlayingTrack(track) then return end

	print(MusicPlayer.HEADER.."Stopping Track: "..tostring(track._id));

	triggerEvent('MusicTrackStopping', track);

	if ticks == 0 then

		self._emitter:stopSound(track._channel);
		self._playing[track._id] = nil;

		triggerEvent('MusicTrackStopped', track);
		
		-- TEST CODE --
		local shader = getScreenShader();
		if shader ~= null then 
			setScreenShaderUniformFloat("testUniformValue", 0.0, 0.0);
		end
		---------------

		-- Set MusicTrack Metadata --
		track._volume  = 0.0;
		track._channel = -1 ;
		track._time.completed = os.time();
		
		-- Set MusicTrack Stopping Metadata --
		track:resetMetadata();

	else

		-- Set MusicTrack Stopping Metadata --
		track._stopping.running       = true  ;
		track._stopping.volume        = volume;
		track._stopping.ticks         = ticks ;
		track._stopping.ticks_started = ticks ;
		track._stopping.on_complete   = nil   ;

	end

end

function MusicPlayer:stopAllTracks(ticks)

	print(MusicPlayer.HEADER..'Stopping all tracks..');
	
	if ticks == nil or ticks < 0 then ticks = 0 end
	
	for key, value in pairs(self._playing) do value:stop(ticks) end

end

-------------------------------------------------------

-- Checks if anything is playing.
function MusicPlayer:isPlayingTrack(track)

	track = self:_verifyTrackArg(track);

	return self._playing[track._id] ~= nil;

end

function MusicPlayer:_verifyTrackArg(track)

	if track == nil then
		error('The track given is nil.');
		return;
	end

	-- String ID argument.
	if type(track) == 'string' then
		track = self._music_tracks[track];
	else
		-- Make sure the argument is a class table.
		if type(track) ~= 'table' then
			error('Not a valid track argument: '..tostring(track)..' (type: '..tostring(type(track))..').');
			return false;
		end
	end

	if track == nil then
		error('Unknown track: '..tostring(track));
		return;
	end

	return track;

end

-----------------------------------------------------------------------------------------------
-- ##     ## ##     ##  ######  ####  ######  ######## ########     ###     ######  ##    ## --
-- ###   ### ##     ## ##    ##  ##  ##    ##    ##    ##     ##   ## ##   ##    ## ##   ##  --
-- #### #### ##     ## ##        ##  ##          ##    ##     ##  ##   ##  ##       ##  ##   --
-- ## ### ## ##     ##  ######   ##  ##          ##    ########  ##     ## ##       #####    --
-- ##     ## ##     ##       ##  ##  ##          ##    ##   ##   ######### ##       ##  ##   --
-- ##     ## ##     ## ##    ##  ##  ##    ##    ##    ##    ##  ##     ## ##    ## ##   ##  --
-- ##     ##  #######   ######  ####  ######     ##    ##     ## ##     ##  ######  ##    ## --
-----------------------------------------------------------------------------------------------

MusicTrack = class(function(o, manager, mod_id, id, path, sample_data)

	o._manager     = manager                          ;
	o._mod_id      = mod_id                           ;
	o._id          = id                               ;
	o._path        = path                             ;
	o._sound       = GameSounds.getSound('music/'..id);
	o._channel     = -1                               ;
	o._sample_data = sample_data                      ;
	o._volume      = 1.0                              ;

	o._time = {
		started = 0,
		completed = 0
	};

	o._starting = {
		running       = false,
		volume        = 0    ,
		ticks         = 0    ,
		ticks_started = 0    ,
		on_complete   = nil
	};

	o._stopping = {
		running       = false,
		volume        = 0    ,
		ticks         = 0    ,
		ticks_started = 0    ,
		on_complete   = nil
	};

end);

function MusicTrack:resetMetadata()

	-- Reset starting metadata --
	self._starting.running       = false;
	self._starting.volume        = 0.0  ;
	self._starting.ticks         = 0    ;
	self._starting.ticks_started = 0    ;
	self._starting.on_complete   = nil  ;

	-- Reset stopping metadata --
	self._stopping.running       = false;
	self._stopping.volume        = 0.0  ;
	self._stopping.ticks         = 0    ;
	self._stopping.ticks_started = 0    ;
	self._stopping.on_complete   = nil  ;

end

function MusicTrack:update()

	if self._starting.running then

		if self._starting.ticks < self._starting.ticks_started then
			
			self._volume = self._starting.volume * (self._starting.ticks / self._starting.ticks_started);
			self._starting.ticks = self._starting.ticks + 1;

			triggerEvent('MusicTrackStarting', self);
		
		else

			self._volume = self._starting.volume;

			-- print('on_complete = '..tostring(self._starting.on_complete));

			-- Run Completion Callback --
			if self._starting.on_complete ~= nil and type(self._starting.on_complete) == 'function' then
				self._starting.on_complete();
			end

			self:resetMetadata();

			triggerEvent('MusicTrackStarted', self);

		end

	elseif self._stopping.running then

		if self._stopping.ticks > 0 then
		
			self._volume = self._stopping.ticks / self._stopping.ticks_started;
			self._stopping.ticks = self._stopping.ticks - 1;
		
			triggerEvent('MusicTrackStopping', self);

		else

			-- Stopping volume --
			self._volume = 0.0;

			-- Stop the Track --
			self._manager._emitter:stopSound(self._channel);
			self._manager._playing[self._id] = nil;
			self._channel = -1;

			-- Run Completion Callback --
			if self._stopping.on_complete ~= nil and type(self._stopping.on_complete) == 'function' then
				self._stopping.on_complete();
			end

			self:resetMetadata();

			triggerEvent('MusicTrackStopped', self);

		end
	end

	local v = self._volume * self._manager._volume;

	-- Update FMOD volume of channel playing the sound.
	self._manager._emitter:setVolume(self._channel, v);

	-- Internal check.
	if not self._manager._emitter:isPlaying(self._channel) then
		self:stop();
	end

	if self._sample_data ~= nil then

		-- Calculate the sample volume of the position of the track.
		local track_length = self._sample_data:getTrackLength();
		local sample_length = self._sample_data:getSampleLength();

		local sample_delta = Math.floor(1000.0 * os.time()) - self._time.started;
		local lerp_value = sample_delta / track_length;

		local offset = math.floor(sample_length * lerp_value);

		local value = self._sample_data:getSample(offset, 1);
		local valuePct = value / 127.0;

		triggerEvent('MusicTrackUpdate', self, offset, v, valuePct);

	else

		triggerEvent('MusicTrackUpdate', self, offset, v, 0);

	end

end

-------------------------------------------

function MusicTrack:play(volume, ticks, on_complete)
	
	if ticks == nil or ticks < 0 then ticks = 0 end
	if volume == nil then volume = 1.0 end

	volume = clamp(volume, 0.0, 1.0);

	self._manager:playTrack(self, volume, ticks);
	
	if ticks ~= 0 then
		self._starting.on_complete = on_complete;
	else
		
		if on_complete ~= nil and type(on_complete) == 'function' then
			on_complete();
		end
	
	end

end

function MusicTrack:stop(ticks, on_complete)

	if not self:isPlaying() then return end 

	if ticks == nil or ticks < 0 then ticks = 0 end

	self._manager:stopTrack(self, ticks);

	if ticks ~= 0 then
		self._stopping.on_complete = on_complete;
	else

		if on_complete ~= nil and type(on_complete) == 'function' then
			on_complete();
		end

	end

end

function MusicTrack:isPlaying() return self._channel ~= -1 end

-- function(track)
triggerEvent('MusicTrackStarting');

-- function(track)
triggerEvent('MusicTrackStarted');

-- function(track)
triggerEvent('MusicTrackStopping');

-- function(track)
triggerEvent('MusicTrackStopped');

-- function(track, offset, volume)
triggerEvent('MusicTrackUpdate');

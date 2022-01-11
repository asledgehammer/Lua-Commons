-----------------------------------------------------------------------------------------------------
--  ######     ###    ##     ## ########  ##       ######## ########     ###    ########    ###    --
-- ##    ##   ## ##   ###   ### ##     ## ##       ##       ##     ##   ## ##      ##      ## ##   --
-- ##        ##   ##  #### #### ##     ## ##       ##       ##     ##  ##   ##     ##     ##   ##  --
--  ######  ##     ## ## ### ## ########  ##       ######   ##     ## ##     ##    ##    ##     ## --
--       ## ######### ##     ## ##        ##       ##       ##     ## #########    ##    ######### --
-- ##    ## ##     ## ##     ## ##        ##       ##       ##     ## ##     ##    ##    ##     ## --
--  ######  ##     ## ##     ## ##        ######## ######## ########  ##     ##    ##    ##     ## --
-----------------------------------------------------------------------------------------------------

SampleData = class(function(o, data)

	if data ~= nil then
		o._data = data;
		o._data.samples_length = string.len(data.samples);

		print('samples_length = '..tostring(o._data.samples_length));
	else 
		o._data = {
			samples_length = 1,
			samples        = '\x00', 
			length         = 0
		};
	end

end);

function SampleData:getSample(offset, avg_amount)
	
	if avg_amount == nil or avg_amount < 1 then avg_amount = 1 end

	if avg_amount == 1 then
		if offset < 1 or offset > self._data.samples_length then return 0 end
		return self._data.samples[offset];
	end

	local avg     = 0;
	local val_neg = 0;
	local val_pos = 0;
	local len     = self._data.samples_length;

	for i=1,avg_amount,1 do
		
		local offset_neg = math.floor(offset - avg_amount);
		if offset_neg > 0 and offset_neg <= len then
			val_neg = tonumber(self._data.samples.byte(offset_neg));
		else
			val_neg = 0;
		end

		local offset_pos = math.floor(offset + avg_amount);
		if offset_pos > 0 and offset_pos <= len then
			val_pos = tonumber(self._data.samples.byte(offset_pos));
		else
			val_pos = 0;
		end

		avg = avg + val_neg;
		avg = avg + val_pos;
	
	end

	return avg / (avg_amount * 2);

end

SampleData.readFile = function(mod_id, path_to_file)

	local reader = getModFileReader(mod_id, path_to_file, false);

	print("File: "..tostring(path_to_file));

	if reader == nil then
		print("File doesn't exist: "..tostring(path_to_file));
		return;
	end

	local code = '';
	local next_line = nil;
	repeat
		next_line = reader:readLine();
		if next_line ~= nil then code = code..next_line end
	until next_line == nil;

	reader:close();

	return SampleData(load_function(code)());
	
end

function SampleData:getLength() return self._data.length end
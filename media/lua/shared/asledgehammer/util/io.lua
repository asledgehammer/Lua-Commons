
-- asledgehammer ------------------
require 'asledgehammer/util/table';
-----------------------------------

----------------------------------------------------------------

IO = {
    file_routines = {}
}

----------------------------------------------------------------
-- TODO: Document.
----------------------------------------------------------------
function IO.writeFile(explodedFile)

  local writeBytes = function(fileWriter, bytes)
    for b in string.gmatch(bytes, '([^,]+)') do
      local n = tonumber(b);
      fileWriter:write(toInt(n - 128));
    end
  end

  local writeChars = function(fileWriter, string)
    fileWriter:writeChars(string);
  end
  
  local run = function()
    
    print("###| Writing file: "..explodedFile.path.."...");
    
    local fileWriter = getFileOutput(explodedFile.path);
    local length = tLength(explodedFile.segmentTypes) - 1;
    local maxCallsPerYield = 0;
    local offset = 0;
    
    for index = 0, length, 1 do
      if explodedFile.segmentTypes[index] == 0 then
        writeChars(fileWriter, explodedFile.fileData[index]);
      else
        writeBytes(fileWriter, explodedFile.fileData[index]);
      end
      if offset < maxCallsPerYield then
        offset = offset + 1;
      else
        offset = 0;
        coroutine.yield();
      end
    end
    
    fileWriter:close();
    print("###| File completed: "..explodedFile.path..".");

  end

  IO.file_routines[tLength(IO.file_routines)] = coroutine.create(run);

end
  
-----------------------------------------------------------------
-- TODO: Document.
----------------------------------------------------------------
function IO.updateFileRoutines()

  local length = tLength(IO.file_routines) - 1;

  if length > -1 then

    local ran = false;

    for index = 0, length, 1 do

      local co = IO.file_routines[index];

      if coroutine.status(co) == "suspended" then
        coroutine.resume(co);
        ran = true;
        break;
      end

    end

    if not ran then IO.file_routines = {} end
  end
end

-----------------------------------------------------------------

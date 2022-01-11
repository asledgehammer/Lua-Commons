Functions = {
    debugLoadFunction = false
};

-----------------------------------------------------------------
-- @string body The body of the function.
-- @table  args The arguments to put in the function header. 
-- 
-- @return Returns a function from a body string and provided 
--         arguments.
-----------------------------------------------------------------
function loadFunction(body, args) 

  local function_context = {};
  setmetatable(function_context, { __index = _G });

  local compiled = "return function(";
  local compiled_args = "";

  if args ~= nil and type(args) == "table" then

    for k,v in pairs(args) do

      if compiled_args == "" then compiled_args = v
      else compiled_args = compiled_args..","..v end
    
    end

  end

  compiled = compiled..compiled_args..") "..body.." end";
  
  -- Debug print function.
  if Functions.debugLoadFunction then print("compiled: "..compiled); end
  
  local f, err = loadstring(compiled, body);
    
    if f then 
      setfenv(f, function_context);
      return f(); 
    else 
      return f, err; 
    end

end

-----------------------------------------------------------------
-- @return  Returns the location of the code.
-----------------------------------------------------------------
function getfunctionlocation()
    local w = debug.getinfo(2, "S")
    return w.short_src..":"..w.linedefined
  end

-----------------------------------------------------------------

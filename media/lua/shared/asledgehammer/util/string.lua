
-----------------------------------------------------------------
-- TODO: Document.
-- https://stackoverflow.com/a/7615129
-----------------------------------------------------------------
function splitString(inputstr, sep)
  
  if sep == nil then sep = "%s" end
  
  local t={} ; i=1
  
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str;
    i = i + 1;
  end
  
  return t;

end

-----------------------------------------------------------------
-- @return  Returns a string with the first character upper-cased.
-----------------------------------------------------------------
function firstToUpper(str)
  str = string.lower(str);
  return (str:gsub("^%l", string.upper))
end
  
-----------------------------------------------------------------
-- @string s    The String being examined.
-- @UIFont font   The font being used to draw the string.
-- @return      The length of the String in pixels.
-----------------------------------------------------------------
function sLength(s, font) 
  return getTextManager():MeasureStringX(font, s) end
  
-----------------------------------------------------------------
-- @UIFont font   The font being used to draw.
-- @return      The height of the String in pixels.
-----------------------------------------------------------------
function sHeight(font)
  -- if font == UIFont.Small then
  --   return 16; --return getTextManager():MeasureStringY(font, s);
  -- end
  return 16;
end

-----------------------------------------------------------------

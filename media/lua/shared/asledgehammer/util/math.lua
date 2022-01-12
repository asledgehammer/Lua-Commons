
-----------------------------------------------------------------
-- @number val - The value to clamp.
-- @number min - The minimum value to return.
-- @number max - The maximum value to return.
--
-- @return - The value in limited form.
-----------------------------------------------------------------
function clamp(val, min, max)
  if val < min then val = min end
  if val > max then val = max end
  return val;
end

-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
function lerp(start, stop, percent)
  return (start + percent * (stop - start)) end

-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
function contains(x, y, w, h, px, py) 
  return px >= x and px <= x + w and py >= y and py <= y + h end

-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
function ease_in_quad(value) return value * value end

-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
function ease_out_quad(value) return value * (2 - value) end

-- function ease_out_quint(value) return value end

function ease_in_quint(x)
  return x * x * x * x * x;
end

function ease_out_quint(value)
  return 1 - Math.pow(1 - value, 5);
end

-----------------------------------------------------------------

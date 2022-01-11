
-- asledgehammer ------------
require 'asledgehammer/class'
-----------------------------

-----------------------------------------------------------------
-- TODO: Document.
-----------------------------------------------------------------
UIColor = class(function(o, r, g, b, a) 
	o.r = r;
	o.g = g;
	o.b = b;
	o.a = a;
end);

-----------------------------------------------------------------

function UIColor:__tostring()
	return tostring(self.r)..','..tostring(self.g)..','..tostring(self.b)..','..tostring(self.a);
end

----------------------------------------------------------------
-- Renders the ChatMessage into a String.
--
-- @return Returns the rendered String.
----------------------------------------------------------------
function UIColor:toTag()	
	return '<RGB:'
			..tostring(self.r)
			..','
			..tostring(self.g)
			..','
			..tostring(self.b)
			..'>';
end

-----------------------------------------------------------------

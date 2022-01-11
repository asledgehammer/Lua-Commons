
-- PZ
require "ISUI/ISUIElement"
-- require "ISUI/ISPanel"

-----------------------------------------------------------------

-- Injected method for scrolling.
function ISUIElement:scrollToBottom()
  self:setYScroll(-(self:getScrollHeight() - (self:getScrollAreaHeight())));
end

-----------------------------------------------------------------

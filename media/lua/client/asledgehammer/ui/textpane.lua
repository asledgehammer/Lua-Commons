
-- pz ------------------------
require "ISUI/ISRichTextPanel"
------------------------------

-- asledgehammer -------------------
require "asledgehammer/ui/component"
require "asledgehammer/ui/uicolor"
require "asledgehammer/util"
------------------------------------

-----------------------------------------------------------------
-- TextPane.lua
-- UI extnesion for ISRichTextPanel Text Panels.
-- 
-- @author Jab
-- @license LGPL3
-----------------------------------------------------------------
TextPane = ISRichTextPanel:derive("TextPane");

-----------------------------------------------------------------
-- @override
-----------------------------------------------------------------
function TextPane:new(name, x, y, w, h)
  
  local o = ISRichTextPanel:new(x, y, w, h);
  setmetatable(o, self);
  self.__index = self;
  
  o.name = name;
  o.text = "";
  o.alpha_factor = 0.85;
  o.shadow_text = true;
  o.autoscroll = true;
  o.active = false;
  
  return o;

end

-----------------------------------------------------------------
-- @override
-----------------------------------------------------------------
function TextPane:update()
  self.autoscroll = self.vscroll.pos == 1;
end

-----------------------------------------------------------------
-- Adds a line to the TextPane.
--
-- @string text The String text content to add as a line.
-----------------------------------------------------------------
function TextPane:addLine(text)
  
  local vsv1 = self:isVScrollBarVisible();
  local pos = self.vscroll.pos;
  
  if text ~= nil then
    if text == "" then
      self.text = text;
    else
      self.text = self.text .. " <LINE> <RGB:1,1,1> " .. text;
    end
  end
  
  self:paginate();

  local vsv2 = self:isVScrollBarVisible();

  if not vsv1 and vsv2 then self.autoscroll = true end
  
  if self.autoscroll then self:scrollToBottom() end

end

-----------------------------------------------------------------
-- Renders the TextPane formally.
-----------------------------------------------------------------
function TextPane:render() self.vscroll.javaObject:render() end

-----------------------------------------------------------------
-- Renders the text in the TextPane with a stencil for the 
--   TextPane dimensions inside of the scroll view.
-----------------------------------------------------------------
function TextPane:_render()

  self:setStencilRect(0, 0, self.width, self.height);
  
  -- Invoke super method.
  ISRichTextPanel.render(self);
  
  self:clearStencilRect();
  
  self.vscroll.javaObject:render();

end

-----------------------------------------------------------------
-- Clears the text in the TextPane.
-----------------------------------------------------------------
function TextPane:clear() self.text = "" end

-----------------------------------------------------------------

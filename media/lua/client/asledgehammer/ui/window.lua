
require "asledgehammer/ui/component"
require "asledgehammer/ui/uicolor"

Window = Component:derive("Window");

function Window:onMouseUp(x, y)
	
	if self.resizing == true then self.setCapture(false) end
	
	self.resizing = false;

end

function Window:new(x, y, w, h)

	local o = ISUIElement:new(x, y, w, h);
	setmetatable(o, self);
	self.__index = self;

	o.alpha_factor_target = 0.85;
	o.backgroundColor = {r=0, g=0, b=0, a=0.0};

	return o;

end

function Window:createChildren()
	
	self.color_border       = UIColor(133, 136, 141, 255);
	self.color_border_inner = UIColor(133, 136, 141,  96);
	self.color_background_1 = UIColor( 64,  64,  64,  64);
	self.color_background_2 = UIColor( 36,  36,  36, 255);
	self.color_gradient     = UIColor( 10,  10,  10, 255);
	self.color_debug        = UIColor(255,   0,   0,   0);
	
	self.color_background   = self.color_background_1;

end

function Window:applyAlpha()

	if self.alpha_factor_target == 0.85 then
	
		self.color_border.a       = 255;
		self.color_border_inner.a =  96;
		self.color_background.a   =  64;
		self.color_gradient.a     = 255;
	
	elseif self.alpha_factor_target == 1.0 then
	
		self.color_border.a       = 255;
		self.color_border_inner.a = 255;
		self.color_gradient.a     = 255;
		self.color_background     = self.color_background_2;
	
	elseif self.alpha_factor_target == 0.25 then
	
		self.color_background     = self.color_background_1;
		self.color_border.a       = 255;
		self.color_border_inner.a =   0;
		self.color_background.a   =   0;
		self.color_gradient.a     =   0;
	
	elseif self.alpha_factor_target == 0.5 then
	
		self.color_border.a       = 255;
		self.color_border_inner.a =  48;
		self.color_background.a   =  12;
		self.color_gradient.a     = 255;
	
	end
end

function Window:_render()
	
	x = self:getX();
	y = self:getY();
	w = self:getWidth();
	h = self:getHeight();
	
	self:applyAlpha();
	
	self:alphaGradientH(x - 5, y, 5, h, self.color_gradient, 0, 125);
	self:alphaGradientH(x + w, y, 5, h, self.color_gradient, 125, 0);
	self:alphaGradientV(x, y - 5, w, 5, self.color_gradient, 0, 125);
	self:alphaGradientV(x, y + h, w, 5, self.color_gradient, 125, 0);
	
	self:fillRoundRectFancy(x + 1, y + 1, w - 1, h - 1, self.color_background);
	
	self:drawRoundRect(x, y, w, h, self.color_border);
end

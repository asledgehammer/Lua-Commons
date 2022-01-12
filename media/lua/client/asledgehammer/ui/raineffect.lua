
-- asledgehammer -------------
require 'asledgehammer/util' ;
require 'asledgehammer/class';
------------------------------

-----------------------------------------------------------------
-- @author Jab
-----------------------------------------------------------------
local RainEffect = class(function(o)

    o.pixels = nil;
    o.pixels_amount = 0;
    o.pixel_phase = 0;
    o.pixel_phase_deg = math.pi / 360;
    o.warningFadeMax = 10;
    o.warningFade = warningFadeMax;
    o.lx = 0;
    o.ly = 0;
    o.lw = 0;
    o.lh = 0;
    o.dx = 0;
    o.dy = 0;
    o.dw = 0;
    o.dh = 0;

    o.speed = 1.0;
    o.alpha = 1.0;

    return o;

end);

-----------------------------------------------------------------

function RainEffect:render(main_screen)

    local core = getCore();
    local sw = core:getScreenWidth();
    local sh = core:getScreenHeight();

    if self.pixels == nil then self:createPixels(sw, sh) end

    -- Go through each pixel.
    for index = 0, self.pixels_amount, 1 do
 
        local pixel = self.pixels[index];
        local x = pixel.x;
        local y = pixel.y;
        local l = pixel.length * self.speed;
 
        local r = 0.6;
        local g = 0.6;
        local b = 0.6;
        local a = 30 / l;
 
        if l > 23 then
        
            local v = ((l - 23) / 7);
            
            r = 0.6  + (v / 2.5);
            g = 0.6  + (v / 2.5);
            b = 0.75 + (v / 2.6);
            a = math.sin(pixel.phase);
        
        end
 
        if r > 1   then r = 1   end
        if g > 1   then g = 1   end
        if b > 1   then b = 1   end
        if r < 0   then r = 0   end
        if g < 0   then g = 0   end
        if b < 0   then b = 0   end
        if a < 0.2 then a = 0.2 end
        if a > 1   then a = 1   end
 
        main_screen:drawLine2(x, y, x - l, y - l, a * self.alpha, r, g, b);
 
        if x >= sw + l or y >= sh + l then
 
            self:createPixel(index, false, sw, sh);
 
        else
 
            if l < 5 then l = 5 end
            
            local vx = 1.2 * (l / 2.5);
            local vy = 1.2 * (l / 2.5);

            if vx > 9.5 then vx = 9.5 end
            if vy > 9.5 then vy = 9.5 end
            
            pixel.x = pixel.x + vx;
            pixel.y = pixel.y + vy;
            pixel.phase = pixel.phase + 0.1;
 
        end
    end
end

-----------------------------------------------------------------

function RainEffect:createPixels(w, h)

    local sw = w or getCore():getScreenWidth();
    local sh = h or getCore():getScreenHeight();
    
    self.pixels = {};
    self.pixels_amount = (sw + sh) / 2;
    
    for index = 0, self.pixels_amount, 1 do
        self:createPixel(index, true, sw, sh);
    end

end

-----------------------------------------------------------------

function RainEffect:createPixel(index, random, w, h) 
    
    local core = getCore();

    local sw = w or core:getScreenWidth();
    local sh = h or core:getScreenHeight();
    
    local flip = ZombRand(2);
    
    local x = 0;
    local y = 0;
    
    local length = ZombRand(30);
    
    if length < 4 then length = 4 end
    
    if random then
        x = ZombRand(sw);
        y = ZombRand(sh);
    else
        
        if flip == 1 then
            x = ZombRand(sw);
            y = -length;
        else
            x = -length;
            y = ZombRand(sh);
        end

    end

    self.pixels[index] = {
        x      = x, 
        y      = y, 
        length = length,
        phase  = 0
    };

end

-----------------------------------------------------------------


function createRainEffect() 
    
    local effect = RainEffect();

    addMainScreenRender(function(main_screen)
        effect:render(main_screen);
    end);

    Events.OnResolutionChange.Add(function(ow, oh, nw, nh)
        effect:createPixels(nw, nh);
    end);

    return effect;
end

-----------------------------------------------------------------

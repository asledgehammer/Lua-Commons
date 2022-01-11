
-----------------------------------------------------------------
--                                                             --
-- This file adds hooks to the MainScreen UI for multiple mods --
-- to interact with the render methods.                        --
--                                                             --
--  - Jab                                                      --
--                                                             --
-----------------------------------------------------------------

-- pz -----------------------------
require 'OptionScreens/MainScreen';
-----------------------------------

-- asledgehammer ------------
require 'asledgehammer/util';
-----------------------------

-----------------------------------------------------------------

MainScreen.render_functions = {};
MainScreen.focus_functions  = {};

MainScreen._prerender = MainScreen.prerender;
MainScreen._onFocus = MainScreen.onFocus;

-----------------------------------------------------------------

-- @override
function MainScreen:prerender()

    -- super:prerender()
    self:_prerender();

    -- Run our code after the method.
    local length = tLength(MainScreen.render_functions) - 1;

    for index = 0, length, 1 do 
        MainScreen.render_functions[index](self); 
    end

end

-----------------------------------------------------------------

-- @override
function MainScreen:onFocus(x, y)

    -- super:onFocus()
    self:_onFocus(x, y);

    -- Run our code after the method.
    local length = tLength(MainScreen.focus_functions) - 1;

    for index = 0, length, 1 do 
        MainScreen.focus_functions[index](self, x, y); 
    end

end

-----------------------------------------------------------------

function addMainScreenRender(func)
    local length = tLength(MainScreen.render_functions);
    MainScreen.render_functions[length] = func;
    return length;
end

-----------------------------------------------------------------

function addMainScreenFocus(func)
    local length = tLength(MainScreen.focus_functions);
    MainScreen.focus_functions[length] = func;
    return length;
end

-----------------------------------------------------------------

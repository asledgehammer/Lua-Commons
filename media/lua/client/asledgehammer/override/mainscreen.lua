
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

MainScreen.prerender_functions = {};
MainScreen.render_functions = {};
MainScreen.postrender_functions = {};
MainScreen.focus_functions  = {};

MainScreen._alc_prerender = MainScreen.prerender;
MainScreen._alc_render = MainScreen.render;
MainScreen._alc_onFocus = MainScreen.onFocus;

-----------------------------------------------------------------

-- @override
function MainScreen:prerender()

    local length = tLength(MainScreen.prerender_functions) - 1;
    for index = 0, length, 1 do 
        MainScreen.prerender_functions[index](self); 
    end
    
    self:_alc_prerender();

end

-- @override
function MainScreen:render()

    local length = tLength(MainScreen.render_functions) - 1;
    for index = 0, length, 1 do 
        MainScreen.render_functions[index](self); 
    end

    self:_alc_render();

    length = tLength(MainScreen.postrender_functions) - 1;
    for index = 0, length, 1 do 
        MainScreen.postrender_functions[index](self); 
    end

end

-----------------------------------------------------------------

-- @override
function MainScreen:onFocus(x, y)

    -- super:onFocus()
    self:_alc_onFocus(x, y);

    -- Run our code after the method.
    local length = tLength(MainScreen.focus_functions) - 1;

    for index = 0, length, 1 do 
        MainScreen.focus_functions[index](self, x, y); 
    end

end


function addMainScreenPreRender(func)
    local length = tLength(MainScreen.prerender_functions);
    MainScreen.prerender_functions[length] = func;
    return length;
end

-----------------------------------------------------------------

function addMainScreenRender(func)
    local length = tLength(MainScreen.render_functions);
    MainScreen.render_functions[length] = func;
    return length;
end

-----------------------------------------------------------------

function addMainScreenPostRender(func)
    local length = tLength(MainScreen.postrender_functions);
    MainScreen.postrender_functions[length] = func;
    return length;
end

-----------------------------------------------------------------

function addMainScreenFocus(func)
    local length = tLength(MainScreen.focus_functions);
    MainScreen.focus_functions[length] = func;
    return length;
end

-----------------------------------------------------------------


-- Get rid of scenarios thing for debug mode. It's annoying.
LoadMainScreenPanelInt = function (ingame)

    local panel2 = MainScreen:new(ingame);
    panel2:initialise();
    panel2:addToUIManager();
    if ingame then
        panel2:setVisible(false);
    end
    local joypadData = JoypadState.getMainMenuJoypad()
    if not ingame and joypadData ~= nil then
        joypadData.focus = MainScreen.instance.animPopup or MainScreen.instance;
        updateJoypadFocus(joypadData);
    end
    if not ingame and not isDemo() then
        local argsServer = getServerAddressFromArgs();
        if argsServer then
            local ss = argsServer:split(":")
            if #ss == 2 then
                local ip = ss[1]
                local port = ss[2]
                MainScreen.instance.bottomPanel:setVisible(false)
                MainScreen.instance.bootstrapConnectPopup:connect(ip, port, getServerPasswordFromArgs())
            end
        end
    end
end
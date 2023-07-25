-- Cavebot by otclient@otclient.ovh
-- visit http://bot.otclient.ovh/

setDefaultTab("Cave")

singlehotkey("1", "Stop/Start", function()
if CaveBot.isOn() or TargetBot.isOn() then
CaveBot.setOff()
TargetBot.setOff()
elseif CaveBot.isOff() or TargetBot.isOff() then
CaveBot.setOn()
TargetBot.setOn()
end
end)

UI.Separator()

local cavebotTab = "Cave"
local targetingTab = "Target"

setDefaultTab(cavebotTab)
CaveBot.Extensions = {}
importStyle("/cavebot/cavebot.otui")
importStyle("/cavebot/config.otui")
importStyle("/cavebot/editor.otui")
dofile("/cavebot/actions.lua")
dofile("/cavebot/config.lua")
dofile("/cavebot/editor.lua")
dofile("/cavebot/example_functions.lua")
dofile("/cavebot/recorder.lua")
dofile("/cavebot/walking.lua")
-- in this section you can add extensions, check extension_template.lua
--dofile("/cavebot/extension_template.lua")
dofile("/cavebot/sell_all.lua")
dofile("/cavebot/depositor.lua")
dofile("/cavebot/buy_supplies.lua")
dofile("/cavebot/d_withdraw.lua")
dofile("/cavebot/supply_check.lua")
dofile("/cavebot/travel.lua")
dofile("/cavebot/doors.lua")
dofile("/cavebot/pos_check.lua")
dofile("/cavebot/withdraw.lua")
dofile("/cavebot/inbox_withdraw.lua")
dofile("/cavebot/lure.lua")
dofile("/cavebot/bank.lua")
dofile("/cavebot/clear_tile.lua")
dofile("/cavebot/tasker.lua")
-- main cavebot file, must be last
dofile("/cavebot/cavebot.lua")

setDefaultTab(targetingTab)
TargetBot = {} -- global namespace
importStyle("/targetbot/looting.otui")
importStyle("/targetbot/target.otui")
importStyle("/targetbot/creature_editor.otui")
dofile("/targetbot/creature.lua")
dofile("/targetbot/creature_attack.lua")
dofile("/targetbot/creature_editor.lua")
dofile("/targetbot/creature_priority.lua")
dofile("/targetbot/looting.lua")
dofile("/targetbot/walking.lua")
-- main targetbot file, must be last
dofile("/targetbot/target.lua")


setDefaultTab("Cave")

local xpbonus = 60*40
macro(1000, "Stamina Refill", function()
    if stamina() < xpbonus then
        useWith((16215), player)
delay(200)
    end
end)
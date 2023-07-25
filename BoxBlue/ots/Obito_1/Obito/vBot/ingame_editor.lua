setDefaultTab("Tools")




-- config

local keyUp = "PageUp"
local keyDown = "PageDown"


-- script

local lockedLevel = pos().z
local m = macro(1000, "Spy Level PGUP/PGDOWN", function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if oldPos.z ~= newPos.z then
        lockedLevel = pos().z
        modules.game_interface.getMapPanel():unlockVisibleFloor()
    end
end)

onKeyPress(function(keys)
    if m.isOn() then
        if keys == keyDown then
            lockedLevel = lockedLevel + 1
            modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
        elseif keys == keyUp then
            lockedLevel = lockedLevel - 1
            modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
        end
    end
end)
UI.Separator()

-- Super Dash

function superDash(parent)
 if not parent then
    parent = panel
  end
  local switch = g_ui.createWidget('BotSwitch', parent)
  switch:setId("superDashButton")
  switch:setText("Super Dash")
  switch:setOn(storage.superDash)
  switch.onClick = function(widget)    
    storage.superDash = not storage.superDash
    widget:setOn(storage.superDash)
  end

  onKeyPress(function(keys)
    if not storage.superDash then
      return
    end
    consoleModule = modules.game_console
    if (keys == "W" and not consoleModule:isChatEnabled()) or keys == "Up" then
      moveToTile = g_map.getTile({x = posx(), y = posy()-1, z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx(), y = posy()-6, z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "A" and not consoleModule:isChatEnabled()) or keys == "Left" then
      moveToTile = g_map.getTile({x = posx()-1, y = posy(), z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx()-6, y = posy(), z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "S" and not consoleModule:isChatEnabled()) or keys == "Down" then
      moveToTile = g_map.getTile({x = posx(), y = posy()+1, z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx(), y = posy()+6, z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "D" and not consoleModule:isChatEnabled()) or keys == "Right" then
      moveToTile = g_map.getTile({x = posx()+1, y = posy(), z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx()+6, y = posy(), z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    end
  end)
end
superDash()

UI.Separator()


-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Ingame script editor", function(newText)
    UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom scrupts here"}, function(text)
      storage.ingame_hotkeys = text
      reload()
    end)
  end)
  
  
  for _, scripts in pairs({storage.ingame_hotkeys}) do
    if type(scripts) == "string" and scripts:len() > 3 then
      local status, result = pcall(function()
        assert(load(scripts, "ingame_editor"))()
      end)
      if not status then 
        error("Ingame edior error:\n" .. result)
      end
    end
  end

UI.Separator()
  

excludeIds = {
    12099
}

stairsIds = {
    1666,
    6207,
    1948,
    435,
    7771,
    5542,
    8657,
    6264,
    1646,
    1648,
    1678,
    5291,
    1680,
    6905,
    6262,
    1664,
    13296,
    1067,
    13861,
    11931,
    1949,
    6896,
    6205,
    13926,
    1947,
    12097
}

-----

Jump = {}

Jump.tecla = "f"

Jump.saveUp = "PageUp"

Jump.saveDown = "PageDown"

Jump.remove = "Delete"


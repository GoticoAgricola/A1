-- tools tab
setDefaultTab("Tools")

-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Ingame macro editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros or "", {title="Macro editor", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros = text
    reload()
  end)
end)
UI.Button("Ingame hotkey editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_macros, storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end


UI.Label("-- MARCA--"):setColor('pink')

local moneyIds = {3031, 3035} -- gold coin, platinium coin
macro(1000, "Exchange money", function()
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

macro(1000, "Stack items", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)


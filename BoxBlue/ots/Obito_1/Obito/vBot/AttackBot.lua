-- author: Vithrax
-- version 2.0

-- if you want to change tab, in line below insert: setDefaultTab("tab name")



attackPanelName = "attackbot"
local ui = setupUI([[
Panel
  height: 38

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('AttackBot')

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

  Button
    id: 1
    anchors.top: prev.bottom
    anchors.left: parent.left
    text: 1
    margin-right: 2
    margin-top: 4
    size: 17 17

  Button
    id: 2
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 2
    margin-left: 4
    size: 17 17
    
  Button
    id: 3
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 3
    margin-left: 4
    size: 17 17

  Button
    id: 4
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 4
    margin-left: 4
    size: 17 17 
    
  Button
    id: 5
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 5
    margin-left: 4
    size: 17 17
    
  Label
    id: name
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    text-align: center
    margin-left: 4
    height: 17
    text: Profile #1
    background: #292A2A
]])

addSeparator()
ui:setId(attackPanelName)

local i = 1
local j = 1
local k = 1
local pvpDedicated = false
local item = false

-- create blank profiles 
if not AttackBotConfig[attackPanelName] or not AttackBotConfig[attackPanelName][1] or #AttackBotConfig[attackPanelName] ~= 5 then
  AttackBotConfig[attackPanelName] = {
    [1] = {
      enabled = false,
      attackTable = {},
      Kills = false,
      name = "Profile #1",
      KillsAmount = 1,
      PvpSafe = true,
      BlackListSafe = false,
      AntiRsRange = 5
    },
    [2] = {
      enabled = false,
      attackTable = {},
      Kills = false,
      name = "Profile #2",
      KillsAmount = 1,
      PvpSafe = true,
      BlackListSafe = false,
      AntiRsRange = 5
    },
    [3] = {
      enabled = false,
      attackTable = {},
      Kills = false,
      name = "Profile #3",
      KillsAmount = 1,
      PvpSafe = true,
      BlackListSafe = false,
      AntiRsRange = 5
    },
    [4] = {
      enabled = false,
      attackTable = {},
      Kills = false,
      name = "Profile #4",
      KillsAmount = 1,
      PvpSafe = true,
      BlackListSafe = false,
      AntiRsRange = 5
    },
    [5] = {
      enabled = false,
      attackTable = {},
      Kills = false,
      name = "Profile #5",
      KillsAmount = 1,
      PvpSafe = true,
      BlackListSafe = false,
      AntiRsRange = 5
    },
  }
end

if not AttackBotConfig.currentBotProfile or AttackBotConfig.currentBotProfile == 0 or AttackBotConfig.currentBotProfile > 5 then 
  AttackBotConfig.currentBotProfile = 1
end

-- finding correct table, manual unfortunately
local currentSettings
local setActiveProfile = function()
  local n = AttackBotConfig.currentBotProfile
  currentSettings = AttackBotConfig[attackPanelName][n]
end
setActiveProfile()

if not currentSettings.AntiRsRange then
  currentSettings.AntiRsRange = 5 
end

local activeProfileColor = function()
  for i=1,5 do
    if i == AttackBotConfig.currentBotProfile then
      ui[i]:setColor("green")
    else
      ui[i]:setColor("white")
    end
  end
end
activeProfileColor()

local categories = {
  "Selecinar categoria",
  "Jutsu de area",
  "Jutsu area 3x3",
  "Jutsu Frontal 1x1",
  "Wave (Linha reta)",
  "Target Jutsu (kamui, etc.)",
  "Targeted Item (Kunai etc.)",
  "Targeted Item de Area",
  "Aumentar Dano (Buff)"
}

local labels = {
  "",
  "Area jutsu",
  "Area",
  "Frontal jutsu",
  "Wave",
  "Targeted Jutsu",
  "Targeted Item",
  "Area Item",
  "Buff"
}

local range = {
  "Selecionar Range",
  "Range: 1",
  "Range: 2",
  "Range: 3",
  "Range: 4",
  "Range: 5",
  "Range: 6",
  "Range: 7",
  "Range: 8",
  "Range: 9"
}

local pattern = {
  "Definir Area Conjuracao",
  "Simples (Kamui, Etc)",
  "Area Larga (5x5)",
  "Area Media (3x3)",
  "Area Pequena (2x2)",
  "Wave Larga (4x6)",
  "Wave Media (3x6)",
  "Wave Pequena (2x6)",
  "Linha Reta (1x6)",
  "Area (1x1)",
  "Area Item",
  "Buffs"
}

ui.title.onClick = function(widget)
currentSettings.enabled = not currentSettings.enabled
widget:setOn(currentSettings.enabled)
vBotConfigSave("atk")
end

ui.settings.onClick = function(widget)
  attackWindow:show()
  attackWindow:raise()
  attackWindow:focus()
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
  attackWindow = UI.createWindow('AttackWindow', rootWidget)
  attackWindow:hide()

  -- functions
  local updateCategoryText = function()
    attackWindow.category:setText(categories[i])
  end
  local updateParameter1Text = function()
    attackWindow.parameter1:setText(pattern[k])
  end
  local updateParameter2Text = function()
    attackWindow.parameter2:setText(range[j])
  end

  -- spin box
  attackWindow.KillsAmount.onValueChange = function(widget, value)
    currentSettings.KillsAmount = value
  end
  attackWindow.AntiRsRange.onValueChange = function(widget, value)
    currentSettings.AntiRsRange = value
  end

  -- checkbox
  attackWindow.pvpSpell.onClick = function(widget)
    pvpDedicated = not pvpDedicated
    attackWindow.pvpSpell:setChecked(pvpDedicated)
  end
  attackWindow.Kills.onClick = function(widget)
    currentSettings.Kills = not currentSettings.Kills
    attackWindow.Kills:setChecked(currentSettings.Kills)
  end
  attackWindow.PvpSafe.onClick = function(widget)
    currentSettings.PvpSafe = not currentSettings.PvpSafe
    attackWindow.PvpSafe:setChecked(currentSettings.PvpSafe)
  end
  attackWindow.BlackListSafe.onClick = function(widget)
    currentSettings.BlackListSafe = not currentSettings.BlackListSafe
    attackWindow.BlackListSafe:setChecked(currentSettings.BlackListSafe)
  end

  --buttons
  attackWindow.CloseButton.onClick = function(widget)
    attackWindow:hide()
    vBotConfigSave("atk")
  end

  local inputTypeToggle = function()
    if attackWindow.category:getText():lower():find("item") then
      item = true
      attackWindow.spellFormula:setText("")
      attackWindow.spellFormula:hide()
      attackWindow.spellDescription:hide()
      attackWindow.itemId:show()
      attackWindow.itemDescription:show()
    else
      item = false
      attackWindow.itemId:setItemId(0)
      attackWindow.itemId:hide()
      attackWindow.itemDescription:hide()
      attackWindow.spellFormula:show()
      attackWindow.spellDescription:show()
    end
  end

  local setSimilarPattern = function()
    if i == 2 then
      k = 3
    elseif i == 3 then
      k = 10
    elseif i == 4 then
      k = 10
    elseif i == 5 then
      k = 6
    elseif i == 6 or i == 7 then
      k = 2
    elseif i == 8 then
      k = 11
    elseif i == 9 then
      k = 12
    end
  end

  attackWindow.categoryNext.onClick = function(widget)
    if i == #categories then
      i = 1
    else
      i = i + 1
    end
    setSimilarPattern()
    updateParameter1Text()
    updateCategoryText()
    inputTypeToggle()
  end

  attackWindow.categoryPrev.onClick = function(widget)
    if i == 1 then
      i = #categories
    else
      i = i - 1
    end
    setSimilarPattern()
    updateParameter1Text()
    updateCategoryText()
    inputTypeToggle()
  end

  attackWindow.parameter1Next.onClick = function(widget)
    if k == #pattern then
      k = 1
    else
      k = k + 1
    end
    updateParameter1Text()
  end

  attackWindow.parameter1Prev.onClick = function(widget)
    if k == 1 then
      k = #pattern
    else
      k = k - 1
    end
    updateParameter1Text()
  end

  attackWindow.parameter2Next.onClick = function(widget)
    if j == #range then
      j = 1
    else
      j = j + 1
    end
    updateParameter2Text()
  end

  attackWindow.parameter2Prev.onClick = function(widget)
    if j == 1 then
      j = #range
    else
      j = j - 1
    end
    updateParameter2Text()
  end

  local validVal = function(v)
    if type(v) ~= "number" then
      local val = tonumber(v)
      if not val then return false end
    end
    if v >= 0 and v < 101 then
      return true
    else
      return false
    end
  end

  local clearValues = function()
    attackWindow.spellFormula:setText("")
    attackWindow.minMana:setText(1)
    attackWindow.minMonsters:setText(1)
    attackWindow.itemId:setItemId(0)
    attackWindow.newCooldown:setText(1)
    pvpDedicated = false
    item = false
    attackWindow.pvpSpell:setChecked(false)
    i = 1
    j = 1
    k = 1
    updateParameter1Text()
    updateParameter2Text()
    updateCategoryText()
    inputTypeToggle()
  end

  local setProfileName = function()
    ui.name:setText(currentSettings.name)
  end
  attackWindow.Name.onTextChange = function(widget, text)
    currentSettings.name = text
    setProfileName()
  end

  local refreshAttacks = function()
    if currentSettings.attackTable then
      for i, child in pairs(attackWindow.attackList:getChildren()) do
        child:destroy()
      end
      for _, entry in pairs(currentSettings.attackTable) do
        local label = UI.createWidget("AttackEntry", attackWindow.attackList)
        label.enabled:setChecked(entry.enabled)
        label.enabled.onClick = function(widget)
          entry.enabled = not entry.enabled
          label.enabled:setChecked(entry.enabled)
        end
        label.remove.onClick = function(widget)
          table.removevalue(currentSettings.attackTable, entry)
          reindexTable(currentSettings.attackTable)
          label:destroy()
        end
        if entry.pvp then
          label:setText("(" .. entry.manaCost .. "% CP) " .. labels[entry.category] .. ": " .. entry.attack ..  " (Range: ".. entry.dist .. ")")
          label:setColor("yellow")
        else
          label:setText("(" .. entry.manaCost .. "% CP & mob >= " .. entry.minMonsters .. ") " .. labels[entry.category] .. ": " .. entry.attack ..  " (Range: ".. entry.dist .. ")")
          label:setColor("green")
        end
      end
    end
  end


  attackWindow.MoveUp.onClick = function(widget)
    local input = attackWindow.attackList:getFocusedChild()
    if not input then return end
    local index = attackWindow.attackList:getChildIndex(input)
    if index < 2 then return end

    local move
    if currentSettings.attackTable and #currentSettings.attackTable > 0 then
      for _, entry in pairs(currentSettings.attackTable) do
        if entry.index == index -1 then
          move = entry
        end
        if entry.index == index then
          move.index = index
          entry.index = index -1
        end
      end
    end
    table.sort(currentSettings.attackTable, function(a,b) return a.index < b.index end)

    attackWindow.attackList:moveChildToIndex(input, index - 1)
    attackWindow.attackList:ensureChildVisible(input)
  end

  attackWindow.MoveDown.onClick = function(widget)
    local input = attackWindow.attackList:getFocusedChild()
    if not input then return end
    local index = attackWindow.attackList:getChildIndex(input)
    if index >= attackWindow.attackList:getChildCount() then return end

    local move
    local move2
    if currentSettings.attackTable and #currentSettings.attackTable > 0 then
      for _, entry in pairs(currentSettings.attackTable) do
        if entry.index == index +1 then
          move = entry
        end
        if entry.index == index then
          move2 = entry
        end
      end
      if move and move2 then
        move.index = index
        move2.index = index + 1
      end
    end
    table.sort(currentSettings.attackTable, function(a,b) return a.index < b.index end)

    attackWindow.attackList:moveChildToIndex(input, index + 1)
    attackWindow.attackList:ensureChildVisible(input)
  end

  attackWindow.addButton.onClick = function(widget)
    local val
    if (item and attackWindow.itemId:getItemId() <= 100) or (not item and attackWindow.spellFormula:getText():len() == 0) then
      warn("AttackBot: missing jutsu or item id!")
    elseif not tonumber(attackWindow.minMana:getText()) or not validVal(tonumber(attackWindow.minMana:getText())) then
      warn("AttackBot: chakra Values incorrect! it has to be number from between 1 and 100")
    elseif not tonumber(attackWindow.minMonsters:getText()) or not validVal(tonumber(attackWindow.minMonsters:getText())) then
      warn("AttackBot: Monsters Count incorrect! it has to be number higher than 0")
    elseif i == 1 or j == 1 or k == 1 then
      warn("AttackBot: Categories not changed! You need to be more precise")
    else
      if item then 
        val = attackWindow.itemId:getItemId()
      else
        val = attackWindow.spellFormula:getText()
      end
      table.insert(currentSettings.attackTable, {index = #currentSettings.attackTable+1, cd = tonumber(attackWindow.newCooldown:getText()) ,attack = val, manaCost = tonumber(attackWindow.minMana:getText()), minMonsters = tonumber(attackWindow.minMonsters:getText()), pvp = pvpDedicated, dist = j-1, model = k, category = i, enabled = true})
      refreshAttacks()
      clearValues()
    end
  end

  -- [[ if added new options, include them below]]



  
  local loadSettings = function()
    ui.title:setOn(currentSettings.enabled)
    attackWindow.KillsAmount:setValue(currentSettings.KillsAmount)
    updateCategoryText()
    updateParameter1Text()
    updateParameter2Text()
    attackWindow.Kills:setChecked(currentSettings.Kills)
    setProfileName()
    inputTypeToggle()
    attackWindow.Name:setText(currentSettings.name)
    refreshAttacks()
    attackWindow.PvpSafe:setChecked(currentSettings.PvpSafe)
    attackWindow.BlackListSafe:setChecked(currentSettings.BlackListSafe)
    attackWindow.AntiRsRange:setValue(currentSettings.AntiRsRange)
  end
  loadSettings()

  local profileChange = function()
    setActiveProfile()
    activeProfileColor()
    loadSettings()
    vBotConfigSave("atk")
  end

    -- profile buttons
  for i=1,5 do
    local button = ui[i]
      button.onClick = function()
      AttackBotConfig.currentBotProfile = i
      profileChange()
    end
  end

  local resetSettings = function()
    currentSettings.enabled = false
    currentSettings.attackTable = {}
    currentSettings.Kills = false
    currentSettings.name = "Profile #" .. AttackBotConfig.currentBotProfile
    currentSettings.pvpSafe = true
    currentSettings.BlackListSafe = false
    currentSettings.AntiRsRange = 5
  end





  -- [[ end ]] --

  attackWindow.ResetSettings.onClick = function()
    resetSettings()
    loadSettings()
  end


  -- public functions
  AttackBot = {} -- global table
  
  AttackBot.isOn = function()
    return currentSettings.enabled
  end
  
  AttackBot.isOff = function()
    return not currentSettings.enabled
  end
  
  AttackBot.setOff = function()
    currentSettings.enabled = false
    ui.title:setOn(currentSettings.enabled)
    vBotConfigSave("atk")
  end
  
  AttackBot.setOn = function()
    currentSettings.enabled = true
    ui.title:setOn(currentSettings.enabled)
    vBotConfigSave("atk")
  end
  
  AttackBot.getActiveProfile = function()
    return AttackBotConfig.currentBotProfile -- returns number 1-5
  end

  AttackBot.setActiveProfile = function(n)
    if not n or not tonumber(n) or n < 1 or n > 5 then
      return error("[AttackBot] wrong profile parameter! should be 1 to 5 is " .. n)
    else
      AttackBotConfig.currentBotProfile = n
      profileChange()
    end
  end
end

-- executor
-- table example (attack = 3155, manaCost = 50(%), minMonsters = 5, pvp = true, dist = 3, model = 6, category = 3)
-- i = category 
-- j = range
-- k = pattern - covered

local patterns = {
  "",
  "",
  [[
    0000000000000
    0000001000000
    0000011100000
    0000111110000
    0001111111000
    0011111111100
    0111111111110
    0011111111100
    0001111111000
    0000111110000
    0000011100000
    0000001000000
    0000000000000
  ]],
  [[
    00000000000
    00000000000
    00000100000
    00001110000
    00011111000
    00111111100
    00011111000
    00001110000
    00000100000
    00000000000
    00000000000
  ]],
  [[
    0000000
    0001000
    0011100
    0111110
    0011100
    0001000
    0000000
  ]],
  [[
    000000NNN000000
    000000NNN000000
    000000NNN000000
    000000NNN000000
    0000000N0000000
    WWWWW00N0EEEEEE
    WWWWWWW0EEEEEEE
    WWWWW00S0EEEEEE
    0000000S0000000
    000000SSS000000
    000000SSS000000
    000000SSS000000
    000000SSS000000
  ]],
  [[
    000NNNNN000
    000NNNNN000
    0000NNN0000
    WW00NNN00EE
    WWWW0N0EEEE
    WWWWW0EEEEE
    WWWW0S0EEEE
    WW00SSS00EE
    0000SSS0000
    000SSSSS000
    000SSSSS000
  ]],
  [[
    00NNN00
    00NNN00
    WW0N0EE
    WWW0EEE
    WW0S0EE
    00SSS00
    00SSS00
  ]],
  [[
    00000000N00000000
    00000000N00000000
    00000000N00000000
    00000000N00000000
    00000000N00000000
    00000000N00000000
    00000000N00000000
    00000000N00000000
    WWWWWWWW0EEEEEEEE
	00000000S00000000
	00000000S00000000
	00000000S00000000
	00000000S00000000
	00000000S00000000
	00000000S00000000
	00000000S00000000
	00000000S00000000
  ]],
  "",
  ""
}

local safePatterns = {
  "",
  "",
  [[
    0000000000000
    0000001000000
    0000011100000
    0000111110000
    0001111111000
    0011111111100
    0111111111110
    0011111111100
    0001111111000
    0000111110000
    0000011100000
    0000001000000
    0000000000000
  ]],
  [[
    00000000000
    00000000000
    00000100000
    00001110000
    00011111000
    00111111100
    00011111000
    00001110000
    00000100000
    00000000000
    00000000000
  ]],
  [[
    0000000
    0001000
    0011100
    0111110
    0011100
    0001000
    0000000
  ]],
  [[
    0000NNNNN0000
    0000NNNNN0000
    0000NNNNN0000
    0000NNNNN0000
    WWWW0NNN0EEEE
    WWWWWNNNEEEEE
    WWWWWW0EEEEEE
    WWWWWSSSEEEEE
    WWWW0SSS0EEEE
    0000SSSSS0000
    0000SSSSS0000
    0000SSSSS0000
    0000SSSSS0000
  ]],
  [[
    000NNNNNNN000
    000NNNNNNN000
    000NNNNNNN000
    WWWWNNNNNEEEE
    WWWWNNNNNEEEE
    WWWWWNNNEEEEE
    WWWWWW0EEEEEE
    WWWWWSSSEEEEE
    WWWWSSSSSEEEE
    WWWWSSSSSEEEE
    000SSSSSSS000
    000SSSSSSS000
    000SSSSSSS000
  ]],
  [[
    00NNNNN00
    00NNNNN00
    WWNNNNNEE
    WWWWNEEEE
    WWWW0EEEE
    WWWWSEEEE
    WWSSSSSEE
    00SSSSS00
    00SSSSS00
  ]],
  [[
    0000000NNN0000000
    0000000NNN0000000
    0000000NNN0000000
    0000000NNN0000000
    0000000NNN0000000
    0000000NNN0000000
    0000000NNN0000000
    WWWWWWWNNNEEEEEEE
    WWWWWWWW0EEEEEEEE
    WWWWWWWSSSEEEEEEE
    0000000SSS0000000
    0000000SSS0000000
    0000000SSS0000000
    0000000SSS0000000
    0000000SSS0000000
    0000000SSS0000000
    0000000SSS0000000
  ]],
  "",
  ""
}

local posN = [[
  111
  000
  000
]]
local posE = [[
  001
  001
  001
]]
local posS = [[
  000
  000
  111
]]
local posW = [[
  100
  100
  100
]]

local bestTile
macro(100, function()
  if not currentSettings.enabled then return end
  if #currentSettings.attackTable == 0 or isInPz() or not target() or modules.game_cooldown.isGroupCooldownIconActive(1) then return end

  if g_game.getClientVersion() < 960 or not currentSettings.Cooldown then
    delay(0)
  end

  local monstersN = 0
  local monstersE = 0
  local monstersS = 0
  local monstersW = 0
  monstersN = getCreaturesInArea(pos(), posN, 2)
  monstersE = getCreaturesInArea(pos(), posE, 2)
  monstersS = getCreaturesInArea(pos(), posS, 2)
  monstersW = getCreaturesInArea(pos(), posW, 2)
  local posTable = {monstersE, monstersN, monstersS, monstersW}
  local bestSide = 0
  local bestDir
  -- pulling out the biggest number
  for i, v in pairs(posTable) do
    if v > bestSide then
        bestSide = v
    end
  end
  -- associate biggest number with turn direction
  if monstersN == bestSide then bestDir = 0
    elseif monstersE == bestSide then bestDir = 1
    elseif monstersS == bestSide then bestDir = 2
    elseif monstersW == bestSide then bestDir = 3
  end

  if currentSettings.Rotate then
    if player:getDirection() ~= bestDir and bestSide > 0 then
      turn(bestDir)
    end
  end

  for _, entry in pairs(currentSettings.attackTable) do
    if entry.enabled then
      if (type(entry.attack) == "string" and canCast(entry.attack, not currentSettings.ignoreMana, not currentSettings.Cooldown)) or (type(entry.attack) == "number" and (not currentSettings.Visible or findItem(entry.attack))) then
        if manapercent() >= entry.manaCost and distanceFromPlayer(target():getPosition()) <= entry.dist then
          if currentSettings.pvpMode then
            if entry.pvp then
              if type(entry.attack) == "string" and target():canShoot() then
                cast(entry.attack, entry.cd)
                return
              else
                if not vBot.isUsing and target():canShoot() then
                  g_game.useInventoryItemWith(entry.attack, target())
                  return
                end
              end
            end
          else
            if entry.category == 6 or entry.category == 7 then
              if getMonsters(4) >= entry.minMonsters then
                if type(entry.attack) == "number" then
                  if not vBot.isUsing then
                    g_game.useInventoryItemWith(entry.attack, target())
                    return
                  end
                else
                  cast(entry.attack, entry.cd)
                  return
                end
              end
            else
              if (g_game.getClientVersion() < 960 or not currentSettings.Kills or killsToRs() > currentSettings.KillsAmount) and (not currentSettings.BlackListSafe or not isBlackListedPlayerInRange(currentSettings.AntiRsRange)) then
                if entry.category == 8 then
                  bestTile = getBestTileByPatern(patterns[5], 2, entry.dist, currentSettings.PvpSafe)
                end
                if entry.category == 4 and (not currentSettings.PvpSafe or isSafe(2, false)) and bestSide >= entry.minMonsters then
                  cast(entry.attack, entry.cd)
                  return
                elseif entry.category == 3 and (not currentSettings.PvpSafe or isSafe(2, false)) and getMonsters(1) >= entry.minMonsters then
                  cast(entry.attack, entry.cd)
                  return
                elseif entry.category == 5 and getCreaturesInArea(player, patterns[entry.model], 2) >= entry.minMonsters and (not currentSettings.PvpSafe or getCreaturesInArea(player, safePatterns[entry.model], 3) == 0) then
                  cast(entry.attack, entry.cd)
                  return
                elseif entry.category == 2 and getCreaturesInArea(pos(), patterns[entry.model], 2) >= entry.minMonsters and (not currentSettings.PvpSafe or getCreaturesInArea(pos(), safePatterns[entry.model], 3) == 0) then
                  cast(entry.attack, entry.cd)
                  return
                elseif entry.category == 8 and bestTile and bestTile.count >= entry.minMonsters then
                  if not vBot.isUsing then
                    g_game.useInventoryItemWith(entry.attack, bestTile.pos:getTopUseThing())
                  end
                  return
                elseif entry.category == 9 and not isBuffed() and getMonsters(entry.dist) >= entry.minMonsters then
                  cast(entry.attack, entry.cd)
                  return
                else
                  if entry.category == 6 or entry.category == 7 then
                    if getMonsters(4) >= entry.minMonsters then
                      if type(entry.attack) == "number" then
                        if not vBot.isUsing then
                          g_game.useInventoryItemWith(entry.attack, target())
                          return
                        end
                      else
                        cast(entry.attack, entry.cd)
                        return
                      end
                    end
                  end
                end
              else
                if entry.category == 6 or entry.category == 7 then
                  if getMonsters(4) >= entry.minMonsters then
                    if type(entry.attack) == "number" then
                      if not vBot.isUsing then
                        g_game.useInventoryItemWith(entry.attack, target())
                        return
                      end
                    else
                      cast(entry.attack, entry.cd)
                      return
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end)

UI.Separator()

followFriend = {}

followFriend.Exclude = {}

followFriend.Click = {
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
    14801,
    14127
}

followFriend.postostring = function(pos)
    return (pos.x .. "," .. pos.y .. "," .. pos.z)
end

function followFriend.accurateDistance(a, b)
    if type(a) == "userdata" then
        a = a:getPosition()
    end
    if not b then
        b = pos()
    end
    if a then
        return math.abs(b.x - a.x) + math.abs(a.y - b.y)
    end
end

followFriend.Check = {}

followFriend.checkTile = function(tile)
    if not tile then
        return false
    end

    local pos = followFriend.postostring(tile:getPosition())

    if followFriend.Check[pos] ~= nil then
        return followFriend.Check[pos]
    end

    for _, x in ipairs(tile:getItems()) do
        if table.find(followFriend.Click, x:getId()) then
            followFriend.Check[pos] = true
            return true
        elseif table.find(followFriend.Exclude, x:getId()) then
            followFriend.Check[pos] = false
            return false
        end
    end

    local cor = g_map.getMinimapColor(tile:getPosition())
    if cor >= 210 and cor <= 213 and not tile:isPathable() and tile:isWalkable() then
        followFriend.Check[pos] = true
        return true
    else
        followFriend.Check[pos] = false
        return false
    end
end



function followFriend.accurateDistance(p1, p2)
    if type(p1) == "userdata" then
        p1 = p1:getPosition()
    end
    if type(p2) ~= "table" then
        p2 = pos()
    end
    return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end

followFriend.nextPosition = {
	{x = 0, y = -1},
	{x = 1, y = 0},
	{x = 0, y = 1},
	{x = -1, y = 0},
	{x = 1, y = -1},
	{x = 1, y = 1},
	{x = -1, y = 1},
	{x = -1, y = -1}
}



followFriend.getPosition = function(pos, dir)
	local nextPos = followFriend.nextPosition[dir + 1]
	
	pos.x = pos.x + nextPos.x
	pos.y = pos.y + nextPos.y

    return pos
end

function table.reverse(t)
	local newTable = {}
	local j = 0
	for i = #t, 1, -1 do
		j = j + 1
		newTable[j] = t[i]
	end
	return newTable
end

followFriend.reverseDirection = {
	2,
	3,
	0,
	1,
	6,
	7,
	4,
	5
}

function followFriend.reversedDirection(dir)
	return followFriend.reverseDirection[dir + 1]
end

followFriend.goUse = function(pos)
    local playerPos = player:getPosition()
    local path = findPath(pos, playerPos)
    if not path then
        return
    end
	path = table.reverse(path)
    for i, v in ipairs(path) do
        if i > 5 then
            break
        end
        playerPos = followFriend.getPosition(playerPos, followFriend.reversedDirection(v))
    end
    local tile = g_map.getTile(playerPos)
    local topThing = tile and tile:getTopUseThing()
    if topThing then
		g_game.use(topThing)
		if table.equals(tile:getPosition(), pos) then
			return delay(300)
		end
	end
end

followFriend.checkAll = function()
    local tiles, pos = {}, pos()
    for _, tile in ipairs(g_map.getTiles(pos.z)) do
		local tilePos = tile:getPosition()
        if followFriend.checkTile(tile) and findPath(tilePos, pos) then
            table.insert(tiles, {
					tile = tile, distance = followFriend.accurateDistance(pos, tilePos)
				}
			)
        end
    end
    if #tiles == 0 then
        return
    end
    table.sort(
        tiles,
        function(a, b)
            return a.distance < b.distance
        end
    )
    return tiles[1].tile
end

followFriend.targetPos = {}

followFriend.actualPosition = function()
	return followFriend.targetPos[posz()]
end

followFriend.macroCheck = macro(1, "Auto Follow Friend", function()
	local checkPos = followFriend.actualPosition()
	if followFriend.tryWalk or not checkPos or not followHim then
		return
    end
    local lookForTarget = getCreatureById(followHim:getId())
    if followFriend.See and followFriend.lastPosition == followFriend.postostring(checkPos) then
		if not lookForTarget then
			followFriend.distance = getDistanceBetween(pos(), followFriend.See:getPosition())
            followFriend.See:setText("AQUI", "green")
            if followFriend.See:isWalkable() then
				if not followFriend.See:isPathable() then
					if autoWalk(followFriend.See:getPosition(), 1) then
						followFriend.tryWalk = true
                        return
					end
				end
				followFriend.goUse(followFriend.See:getPosition(), followFriend.distance)
			end
		else
			followFriend.targetPos[pos().z] = lookForTarget:getPosition()
			followFriend.See:setText("AQUI", "red")
		end
		return
	end
	if followFriend.See then
		followFriend.See:setText("")
	end
	followFriend.See = followFriend.checkAll()
	followFriend.lastPosition = followFriend.postostring(checkPos)
end)

macro(1, function()
        if followFriend.macroCheck.isOff() then
            return
        end
        local target = g_game.getFollowingCreature()
        if target then
            local targetPos = target:getPosition()
            if targetPos then
                followHim = target
                followFriend.targetPos[targetPos.z] = targetPos
            end
        end
        local targetPos = followHim and followHim:getPosition()
		if g_game.isFollowing() and getDistanceBetween(pos(), targetPos) > 1 then
			g_game.follow(nil)
		end
        if targetPos and targetPos.z == pos().z and not g_game.isFollowing() and getDistanceBetween(targetPos, pos()) > 1 then
			if not g_game.isAttacking() then
				return g_game.follow(followHim)
			else
				return followFriend.goUse(targetPos)
			end
		end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
	if not (newPos and oldPos) then return end
	if creature == player then
		if followFriend.targetPos[oldPos.z] and followFriend.tryWalk and followFriend.See then
			followFriend.tryWalk = nil
			followFriend.See = nil
			followFriend.targetPos[oldPos.z] = nil
		end
	elseif creature == followHim then
		followFriend.targetPos[newPos.z] = newPos
	end
end)


  macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)

UI.Separator()

UI.Label("Chakra Training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="CP%", text="powerdown", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)

UI.Separator()

macro(60000, "Trade Seller Msg", function()
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then
    sayChannel(trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "I'm using OTClientV8!", function(widget, text)
  storage.autoTradeMessage = text
end)


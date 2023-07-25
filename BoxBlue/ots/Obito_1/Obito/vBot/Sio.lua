setDefaultTab("Main")
  local panelName = "advancedFriendHealer"
  local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Friend Healer')

  Button
    id: editList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
      
  ]], parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {
      minMana = 60,
      minFriendHp = 40,
      customSpellName = "",
      customSpell = false,
      distance = 8,
      itemHeal = false,
      id = 107,
      exuraSio = false
    }
  end

  local config = storage[panelName]

  -- basic elements
  ui.title:setOn(config.enabled)
  ui.title.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
  end
  ui.editList.onClick = function(widget)
    sioListWindow:show()
    sioListWindow:raise()
    sioListWindow:focus()
  end

  rootWidget = g_ui.getRootWidget()
  if rootWidget then
    sioListWindow = UI.createWindow('SioListWindow', rootWidget)
    sioListWindow:hide()

    -- TextWindow
    sioListWindow.spellName:setText(config.spellName)
    sioListWindow.spellName.onTextChange = function(widget, text)
      config.customSpellName = text
    end

    -- botswitches
    sioListWindow.spell:setOn(config.customSpell)
    sioListWindow.spell.onClick = function(widget)
      config.customSpell = not config.customSpell
      widget:setOn(config.customSpell)
    end
    sioListWindow.item:setOn(config.itemHeal)  
    sioListWindow.item.onClick = function(widget)
      config.itemHeal = not config.itemHeal
      widget:setOn(config.itemHeal)
    end
    sioListWindow.exuraSio:setOn(config.exuraSio)  
    sioListWindow.exuraSio.onClick = function(widget)
      config.exuraSio = not config.exuraSio
      widget:setOn(config.exuraSio)
    end 

    -- functions
    local updateMinManaText = function()
      sioListWindow.manaInfo:setText("Minimum Mana >= " .. config.minMana .. "%")
    end
    local updateFriendHpText = function()
      sioListWindow.friendHp:setText("Heal Friend Below " .. config.minFriendHp .. "% hp")  
    end
    local updateDistanceText = function()
      sioListWindow.distText:setText("Max Distance: " .. config.distance)
    end

    -- scrollbars and text updates
    sioListWindow.Distance:setValue(config.distance)
    sioListWindow.Distance.onValueChange = function(scroll, value)
      config.distance = value
      updateDistanceText()
    end
    updateDistanceText()

    sioListWindow.minMana:setValue(config.minMana)
    sioListWindow.minMana.onValueChange = function(scroll, value)
      config.minMana = value
      updateMinManaText()
    end
    updateMinManaText()

    sioListWindow.minFriendHp:setValue(config.minFriendHp)
    sioListWindow.minFriendHp.onValueChange = function(scroll, value)
      config.minFriendHp = value
      updateFriendHpText()
    end
    updateFriendHpText()

    sioListWindow.itemId:setItemId(config.id)
    sioListWindow.itemId.onItemChange = function(widget)
      config.id = widget:getItemId()
    end

    sioListWindow.closeButton.onClick = function(widget)
      sioListWindow:hide()
    end

  end

  -- local variables
  local newTibia = g_game.getClientVersion() >= 960

  local function isValid(name)
    if not newTibia then return true end

    local voc = vBot.BotServerMembers[name]
    if not voc then return true end
    
    if voc == 11 then voc = 1
    elseif voc == 12 then voc = 2
    elseif voc == 13 then voc = 3
    elseif voc == 14 then voc = 4
    end

    local isOk = false
    if voc == 1 and config.healEk then
      isOk = true
    elseif voc == 2 and config.healRp then
      isOk = true
    elseif voc == 3 and config.healMs then
      isOk = true
    elseif voc == 4 and config.healEd then
      isOk = true
    end

    return isOk
  end

  macro(200, function()
    if not config.enabled then return end
    if modules.game_cooldown.isGroupCooldownIconActive(2) then return end

    --[[
      1. custom spell
      2. exura gran sio - at 50% of minHpValue
      3. exura gran mas res
      4. exura sio
      5. item healing
    --]]

    -- exura gran sio & custom spell
    if config.customSpell or config.exuraGranSio then
      for i, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player and isValid(spec:getName()) and spec:canShoot() then
          if isFriend(spec) then
            if config.customSpell and spec:getHealthPercent() <= config.minFriendHp then
              return cast(config.customSpellName .. ' "' .. spec:getName() .. '"', 1000)
            end
            if config.exuraGranSio and spec:getHealthPercent() <= config.minFriendHp/3 then
              if canCast('exura gran sio "' .. spec:getName() ..'"') then
                return cast('exura gran sio "' .. spec:getName() ..'"', 60000)
              end
            end
          end
        end
      end
    end

    -- exura gran mas res and standard sio
    local friends = 0
    if config.exuraMasRes then
      for i, spec in ipairs(getSpectators(player, largeRuneArea)) do
        if spec:isPlayer() and spec ~= player and isValid(spec:getName()) and spec:canShoot() then
          if isFriend(spec) and spec:getHealthPercent() <= config.minFriendHp then
            friends = friends + 1
          end
        end
      end
      if friends > 1 then
        return cast('exura gran mas res', 2000)
      end
    end
    if config.exuraSio or config.itemHeal then
      for i, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player and isValid(spec:getName()) and spec:canShoot() then
          if isFriend(spec) then
            if spec:getHealthPercent() <= config.minFriendHp then
              if config.exuraSio then
                return cast('Chiyute no jutsu "' .. spec:getName() .. '"', 1000)
              elseif findItem(config.id) and distanceFromPlayer(spec:getPosition()) <= config.distance then
                return useWith(config.id, spec)
              end
            end
          end
        end
      end
    end 

  end)
addSeparator()
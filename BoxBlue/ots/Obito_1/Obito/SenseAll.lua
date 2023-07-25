------------------------------------------SENSE-------------------------------------------

local mapPanel = modules.game_interface.getMapPanel()

local spellWidget = [[
Panel
  background-color: black
  padding: 0 5
  text-auto-resize-horizontal: true
]]


Sense = {}
  
Sense.elapsed = 0
  
Sense.distance = 0
  
Sense.onScreen = setupUI(spellWidget, mapPanel)
  
Sense.actualText = function(text)
  if not text then return end
  text = text:split(', ')
  text[2] = 'E' .. Sense.revertElapsed()
  text[3] = Sense.actualDistance(Sense.Distance)
  local texto
  for _, string in ipairs(text) do
      if texto then
          texto = texto .. ', ' .. string
      else
          texto = string
      end
  end
  return texto
end
  
Sense.actualDistance = function(n)
  n = tonumber(n)
  return math.abs(n - getDistanceBetween(Sense.lastPosition, player:getPosition()))
end
    
  
macro(3000, function()
  local getC = Sense.Text and getCreatureByName(Sense.Text:split(', ')[1])
  if Sense.elapsed == 0 or (getC and getDistanceBetween(getC:getPosition(), player:getPosition()) <= 7) then
    Sense.onScreen:setHeight(0)
      return Sense.onScreen:clearText()
  end
  if not Sense.Count or Sense.Count < now then
      if Sense.Count then
          Sense.elapsed = Sense.elapsed - 1
      end
      Sense.Count = now + 1000
  end
  Sense.onScreen:setText(Sense.actualText(Sense.Text))
end)
  
Sense.revertElapsed = function()
  return math.abs(Sense.elapsed - 30)
end
  
  
  
Sense.actualPosition = function(text)
  if text == 'north' then
       return {x = 150, y = -230}
  elseif text == 'south' then
      return {x = 150, y = 250}
  elseif text == 'west' then
      return {x = -180, y = -1}
  elseif text == 'east' then
      return {x = 400, y = -30}
  elseif text == 'north-east' then
      return {x = 300, y = -150}
  elseif text == 'south-east' then
      return {x = 380, y = 150}
  elseif text == 'north-west' then
      return {x = -100, y = -150}
  elseif text == 'south-west' then
      return {x = -180, y = 250}
  end
end
  
Sense.setPosition = function(position)
  position.x = math.ceil(mapPanel:getWidth() / 2) + position.x
  position.y = math.ceil(mapPanel:getHeight() / 2) + position.y
  return Sense.onScreen:setPosition(position)
end
  
Sense.setPrimary = function(texto, cor)
  if cor == 'very far' then
      Sense.onScreen:setColor('red')
  elseif cor == 'far' then
      Sense.onScreen:setColor('yellow')
  elseif cor == '' or cor == 'on a higher level' or cor == 'on a lower level' then
      Sense.onScreen:setColor('white')
  end
  Sense.elapsed = 30
  Sense.Count = nil
  Sense.setText(texto, Sense.elapsed, cor)
end
  
  
Sense.convertTodistance = function(text)
  if text == 'very far' then
      return 375
  elseif text == 'far' then
      return 190
  elseif text == 'on a higher level' then
      return {60, 'Up'}
  elseif text == 'on a lower level' then
      return {60, 'Down'}
  elseif text == '' then
      return 60
  end
end
  
Sense.setText = function(texto, tempo, distancia)
  distancia = Sense.convertTodistance(distancia)
  Sense.Distance = distancia
  if type(distancia) == 'table' then
       Sense.Distance = distancia[1]
      distancia = distancia[1] .. ', ' .. distancia[2]
  end
  Sense.Text = texto .. ', ' .. 'E' .. Sense.elapsed ..  ', ' .. distancia
end
  
  
  
onTextMessage(function(mode, text)
  if mode == 20 then
    local regex = "([a-z A-Z]*) is ([a-z -A-Z]*)to the ([a-z -A-Z]*)."
      local senseData = regexMatch(text, regex)[1]
      if senseData then
          if senseData[2] and senseData[3] and senseData[4] then
            Sense.setPosition(Sense.actualPosition(senseData[4]:trim()))
            Sense.setPrimary(senseData[2]:trim(), senseData[3]:trim())
            Sense.lastPosition = player:getPosition()
          end
      end
  end
end)


-------------------------------------------------LAST SENSE----------------------------------------------------

local panelName = "tcLastExiva"
local tcLastExiva = setupUI([[
ExivaLabel < Label
  height: 12
  background-color: #00000055
  opacity: 0.89
  anchors.horizontalCenter: parent.horizontalCenter
  text-auto-resize: true
  font: verdana-11px-rounded

Panel
  id: msgPanel
  height: 26
  width: 100
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  margin-bottom: 20

  ExivaLabel
    id: lblMessage
    color: green
    anchors.bottom: parent.bottom
    !text: 'None.'

  ExivaLabel
    id: lblExiva
    color: orange
    anchors.bottom: prev.top
    !text: 'Last Sense: None'

]], modules.game_interface.getMapPanel())

local tclastExivaUI = setupUI([[
Panel
  margin: 3
  height: 66
  layout:
    type: verticalBox

  HorizontalSeparator
    id: separator

  Label
    id: title
    text: Last Sense
    margin-top: 1
    text-align: center
    font: verdana-11px-rounded

  Panel
    id: time
    height: 22
    Label
      !text: 'Time in seconds:'
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: next.left
      text-align: center
      height: 15
      margin-right: 6
      font: verdana-11px-rounded

    BotTextEdit
      id: text
      text: 5
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      margin-left: 5
      height: 17
      width: 55
      font: verdana-11px-rounded

  ]], parent)

if not storage[panelName] then
  storage[panelName] = {
    name = '',
    timer = 5,
  }
end

tclastExivaUI.time.text:setText(storage[panelName].timer)
tclastExivaUI.time.text.onTextChange = function(widget, text)
  storage[panelName].timer = tonumber(text)
end

local lastExiva = ''
lastExiva = storage[panelName].name
tcLastExiva.lblExiva:setText('Last Sense: ' .. lastExiva)

onTalk(function(name, level, mode, text, channelId, pos)
  if name ~= player:getName() then return end
  text = text:lower()
  -- uncomment the warn below to find the channel mode if this doesn't work
  -- cast exiva and you should see NUMBER :  sense "name"
  -- warn(mode.. ':'..text)
  if (mode == 34 or mode == 44) and text:find('exiva ') then
   lastExiva = string.match(text, [[sense "([^"]+)]])
    if lastExiva then
      storage[panelName].name = lastExiva
      tcLastExiva.lblExiva:setText('Last Exiva: ' .. lastExiva)
    end
  end
end)

onTextMessage(function(mode, text)
  if mode ~= 20 then return end
  local regex = "([a-z A-Z]*) is ([a-z -A-Z]*)(?:to the|standing|below|above) ([a-z -A-Z]*)."
  local data = regexMatch(text, regex)[1]
  if data and data[2] and data[3] then
    schedule(10, function()
      tcLastExiva.lblMessage:setText(text)
    end)
  end
end)

tclastExivaMacro = macro(3000, "Enable", "F12", function()
  if lastExiva:len() > 0 then
    say('sense "' .. lastExiva)
  end
  delay(tonumber(storage[panelName].timer) * 1000)
end, tclastExivaUI)
UI.Separator(tclastExivaUI)


macro(3000, function()
    if storage.Sense then
        locatePlayer = getPlayerByName(storage.Sense)
        if not (locatePlayer and locatePlayer:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), locatePlayer:getPosition()) <= 6) then
            say('sense "' .. storage.Sense)
            delay(5000)
        end
    end
end)


onTalk(function(name, level, mode, text, channelId, pos)
    if player:getName() == name then
        if string.sub(text, 1, 1) == 'x' then
            local checkMsg = string.sub(text, 2, 1000):trim()
            if checkMsg == '0' then
                storage.Sense = false
            else
                storage.Sense = checkMsg
            end
        end
    end
end)
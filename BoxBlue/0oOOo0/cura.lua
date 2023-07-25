macro(100, "Heal Party/Guild", function()
    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and (spec:getEmblemm() == 3 or spec:getEmblemm() == 1) and spec:getHealthPercent() <= 60 then
              say('Heal Friend "' .. spec ..)
        end
     end
end)



macro(100, "Heal Friend 04", function()
    local friend = getPlayerByName(storage.friendName)
      if friend and friend:getHealthPercent() < 90 then
       say('Heal Friend"' .. storage.friendName)
      delay(1000)
     end
   end)
   
   UI.Label("Player Name:")
   addTextEdit("friendName", storage.friendName or "", function(widget, text)
    storage.friendName = text
   end)
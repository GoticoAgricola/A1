-- tools tab
setDefaultTab("HTK")


UI.Separator();
local rootWidget = g_ui.getRootWidget();
local mapPanel = modules.game_interface.getMapPanel();

local Spells  = {
  ['moku shouheki no jutsu'] = { text = 'Trap Target', activeCooldown = 5000, totalCooldown = 1 * 40000, position = { x = -150, 
y = -30} },
  ['jukai meikai koutan'] = { text = 'Trap AREA', activeCooldown = 4000, totalCooldown = 1 * 60000, position = { x = -150, y = 
-50 } },
  ['izanagi'] = { text = 'IZANAGI', activeCooldown = 20000, totalCooldown = 1 * 75000, position 
= { x = 80, y = -30 } },
  ['kawarimi no jutsu'] = { text = 'Kawarimi', activeCooldown = 10000, totalCooldown = 1 * 59000, position = { x 
= 80, y = -50 } },


}

local spellWidget = [[
Panel
  background-color: black
  padding: 0 5
]]

local function insertNewSpell(key, object)
    storage.cooldowns[key] = {
        text = object.text,
        activeCooldown = object.activeCooldown,
        totalCooldown = object.totalCooldown,
        position = object.position,
    };
end

local TimeSpell = macro(1, "Time Spell", function()
    local width = mapPanel:getWidth() / 2;
    local height = mapPanel:getHeight() / 2;

    for jutsu, spell in pairs(Spells) do
        if (spell.widget == nil) then
            spell.widget = setupUI(spellWidget, mapPanel);
        end
        if (not storage.cooldowns[jutsu].totalTime or storage.cooldowns[jutsu].totalTime < now) then
            spell.widget:setText(spell.text .. ': OK!');
            spell.widget:setColor('green');
        elseif (storage.cooldowns[jutsu].activeTime >= now) then
            spell.widget:setColor('blue');
            spell.widget:setText(spell.text .. ': ' .. string.format("%.0f", (storage.cooldowns[jutsu].activeTime - now) / 
1000).. "s ");
        else
            spell.widget:setColor('red');
            spell.widget:setText(spell.text .. ': ' .. string.format("%.0f", (storage.cooldowns[jutsu].totalTime - now) / 
1000).. "s ");
        end
        spell.widget:setPosition({ x = width + spell.position.x, y = height + spell.position.y });
    end
end);

onTalk(function(name, level, mode, text, channelId, pos)
    if (name ~= player:getName()) then return; end

    text = text:lower();
    if (Spells[text] == nil) then return; end
    if (Spells[text].activeCooldown > 0) then
        storage.cooldowns[text].activeTime = now + Spells[text].activeCooldown;
    end
    storage.cooldowns[text].totalTime = now + Spells[text].totalCooldown;
end);

if type(storage.cooldowns) ~= 'table' then
    storage.cooldowns = {};
    for jutsu, object in ipairs(Spells) do
        insertNewSpell(jutsu, object)
    end
end

for jutsu, object in pairs(Spells) do
    if (storage.cooldowns[jutsu] == nil) then
        insertNewSpell(jutsu, object);
    end
    if (storage.cooldowns[jutsu].totalTime == nil) then 
        storage.cooldowns[jutsu].totalTime = 0;
    end

    if (storage.cooldowns[jutsu].activeTime == nil) then 
        storage.cooldowns[jutsu].activeTime = 0;
    end
    
    if (storage.cooldowns[jutsu].activeCooldown ~= object.activeCooldown) then
        storage.cooldowns[jutsu].activeCooldown = object.activeCooldown;
    end
    
    if (storage.cooldowns[jutsu].totalCooldown ~= object.totalCooldown) then
        storage.cooldowns[jutsu].totalCooldown = object.totalCooldown;
    end
    
    if (storage.cooldowns[jutsu].totalTime - now > storage.cooldowns[jutsu].totalCooldown) then
        storage.cooldowns[jutsu].totalTime = 0;
        storage.cooldowns[jutsu].activeTime = 0;
    end

end

UI.Button("Remover Tempos", function()
    if (TimeSpell:isOff()) then return; end
    TimeSpell.setOff();
    for jutsu, spell in pairs(Spells) do
        spell.widget:destroy();
        spell.widget = nil;
    end
end);
UI.Separator();
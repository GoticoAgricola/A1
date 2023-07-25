-- tools tab
setDefaultTab("Tools")

Stairs = {}

Stairs.saveStatus = {}

Stairs.checkTile = function(tile)
    if not tile then
        return false
    end

    local tilePos = tile:getPosition()

    if not tilePos then
        return
    end

    local posOnString = Stairs.postostring(tilePos)

    local checkStatus, itemsOnTile = Stairs.saveStatus[posOnString], tile:getItems()

    if checkStatus ~= nil and tile.itemsOnTile == #itemsOnTile then
        return checkStatus
    end

    local topThing = tile:getTopUseThing() or itemsOnTile[#itemsOnTile]

    if not topThing then
        return false
    end
	
	tile.itemsOnTile = #itemsOnTile

    for _, x in ipairs(itemsOnTile) do
        if excludeIds[x:getId()] then
            Stairs.saveStatus[posOnString] = false
            return false
        end
    end

    if stairsIds[topThing:getId()] then
        Stairs.saveStatus[posOnString] = true
        return true
    end

    local cor = g_map.getMinimapColor(tile:getPosition())
    if cor >= 210 and cor <= 213 and not tile:isPathable() and tile:isWalkable() then
        Stairs.saveStatus[posOnString] = true
        return true
    else
        Stairs.saveStatus[posOnString] = false
        return false
    end
end

Stairs.postostring = function(pos)
    return pos.x .. "," .. pos.y .. "," .. pos.z
end

function Stairs.accurateDistance(p1, p2)
    if type(p1) == "userdata" then
        p1 = p1:getPosition()
    end
    if type(p2) ~= "table" then
        p2 = pos()
    end
    return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end

Stairs.nextPosition = {
	{x = 0, y = -1},
	{x = 1, y = 0},
	{x = 0, y = 1},
	{x = -1, y = 0},
	{x = 1, y = -1},
	{x = 1, y = 1},
	{x = -1, y = 1},
	{x = -1, y = -1}
}

Stairs.getPosition = function(pos, dir)
	local nextPos = Stairs.nextPosition[dir + 1]
	
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

Stairs.reverseDirection = {
	2,
	3,
	0,
	1,
	6,
	7,
	4,
	5
}

function reverseDirection(dir)
	return Stairs.reverseDirection[dir + 1]
end

Stairs.actualTile = nil
Stairs.actualPos = nil

Stairs.getDistance = function(pos)
	pos = pos or player:getPosition()
	return Stairs.actualPos and Stairs.actualPos.z == pos.z and Stairs.accurateDistance(Stairs.actualPos, pos)
end


markOnThing = function(thing, color)
    if thing then
		local useThing = thing:getItems()[#thing:getItems()]
        if not useThing then
            if color == "#00FF00" then
                thing:setText("AQUI", "green")
            elseif color == "#FF0000" then
                thing:setText("AQUI", "red")
            else
                thing:setText("")
			end
        else
			useThing:setMarked(color)
		end
	end
end

Stairs.verifyTiles = function(pos)
	for _, tile in ipairs(g_map.getTiles(pos.z)) do
		local tilePos = tile:getPosition()
		local stairDistance = Stairs.getDistance(pos)
		if not stairDistance or stairDistance > Stairs.accurateDistance(tilePos, pos) then
			if Stairs.checkTile(tile) and (getDistanceBetween(pos, tilePos) <= 1 or findPath(tilePos, pos)) then
				markOnThing(Stairs.actualTile)
				Stairs.actualTile, Stairs.actualPos = tile, tilePos
			end
		end
	end
end

onAddThing(function(tile, thing)
	if not thing:isItem() then
		return
	end
	local tilePos, isStair, pos = tile:getPosition(), Stairs.checkTile(tile), pos()
	if tilePos.z ~= pos.z then
		return
	end
	if Stairs.actualPos then
		if table.equals(Stairs.actualPos, tilePos) and (not isStair and (not findPath(tilePos, pos) and getDistanceBetween(tilePos, pos) > 1)) then
			Stairs.actualTile, Stairs.actualPos = nil, nil
			markOnThing(Stairs.actualTile)
		end
	end
	if isStair and (getDistanceBetween(tilePos, pos) <= 1 or findPath(tilePos, pos)) then
		local stairDistance = Stairs.getDistance()
		if not stairDistance or stairDistance > Stairs.accurateDistance(tilePos) then
			markOnThing(Stairs.actualTile)
			Stairs.actualTile, Stairs.actualPos = tile, tilePos
			Stairs.isTrying = nil
		end
	end
end)

onRemoveThing(function(tile, thing)
	if not thing:isItem() then
		return
	end
	local tilePos, isStair, pos = tile:getPosition(), Stairs.checkTile(tile), pos()
	if tilePos.z ~= pos.z then
		return
	end
	if Stairs.actualPos then
		if table.equals(Stairs.actualPos, tilePos) and (not isStair and (not findPath(tilePos, pos) and getDistanceBetween(tilePos, pos) > 1)) then
			Stairs.actualTile, Stairs.actualPos = nil, nil
			markOnThing(Stairs.actualTile)
		end
	end
	if isStair and (getDistanceBetween(tilePos, pos) <= 1 or findPath(tilePos, pos)) then
		local stairDistance = Stairs.getDistance()
		if not stairDistance or stairDistance > Stairs.accurateDistance(tilePos) then
			markOnThing(Stairs.actualTile)
			Stairs.actualTile, Stairs.actualPos = tile, tilePos
			Stairs.isTrying = nil
		end
	end
end)


Stairs.goUse = function(pos)
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
        playerPos = Stairs.getPosition(playerPos, reverseDirection(v))
    end
	local tile = g_map.getTile(playerPos)
	local topThing = tile and tile:getTopUseThing()
    if topThing then
		if storage.kunaiId and storage.useKunai then
			useWith(storage.kunaiId, topThing)
		end
		use(topThing)
	end
end



Stairs.verifyTiles(pos())

local standing = now

onPlayerPositionChange(function(newPos, oldPos)
	Stairs.tryWalk = nil
	Stairs.tryToStep = nil
	Stairs.verifyTiles(newPos)
end)

isKeyPressed = modules.corelib.g_keyboard.isKeyPressed


g_game.disableFeature(37)


Stairs.doWalk = function()
	-- player:lockWalk(300)
	-- if not Stairs.tryWalk and getDistanceBetween(Stairs.actualPos, pos()) == 1 and Stairs.actualTile:isWalkable() then
		-- autoWalk(Stairs.actualPos, 1)
		-- Stairs.tryWalk = true
	-- end
	-- Stairs.goUse(Stairs.actualPos)
	if not Stairs.tryToStep and autoWalk(Stairs.actualPos, 1) then
		Stairs.tryToStep = true
	end
	Stairs.goUse(Stairs.actualPos)
	Stairs.isTrying = true
end



UI.Separator()

Jump.upOrdown = function()
    if isKeyPressed(Jump.saveUp) then
        return 1
    elseif isKeyPressed(Jump.saveDown) then
        return 2
    end
    return false
end

Jump.removeIt = function(position)
    if not position then
        return
    end
    position = Jump.postostring(position)
    if storage.jumps[position] then
        storage.jumps[position] = nil
        player:setText("Removed:\n" .. position)
        schedule(
            1000,
            function()
                player:clearText()
            end
        )
        if position == Jump.postostring(Jump.Pos) then
            local tile = g_map.getTile(Jump.Pos)
            if tile then
                tile:setText("")
            end
            Jump.lastPos = nil
            return true
        end
        Jump.lastPos = nil
    end
end

Jump.preciseDistance = function(pos1, pos2)
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

Jump.postostring = function(pos)
    return pos.x .. "," .. pos.y .. "," .. pos.z
end

if type(storage.jumps) ~= "table" then
    storage.jumps = {}
elseif #storage.jumps > 0 then
    for index, value in ipairs(storage.jumps) do
        storage.jumps[index] = nil
        storage.jumps[Jump.postostring(value)] = {
            direction = value.direction,
            jumpTo = value.jumpTo
        }
    end
end

function Jump.actualDirection()
    local dir = player:getDirection()
    if dir > 3 then
        if dir < 6 then
            return 1
        else
            return 3
        end
    else
        return dir
    end
end

Jump.convertPos = function(position)
    local pos = pos()
    pos.x = position.x
    pos.y = position.y
    pos.z = position.z
    return pos
end

Jump.findJump = function()
    local pos, nearest = pos(), {pos = {x = 0, y = 0, z = 0}, jumpTo = "Jump Up", direction = 0}
    for _, tile in pairs(g_map.getTiles(pos.z)) do
		local tilePos = tile:getPosition()
		if tilePos then
			local hasInfo = storage.jumps[Jump.postostring(tilePos)]
			if hasInfo then
				local distance = Jump.preciseDistance(pos, tilePos)
				if not nearest.distance or nearest.distance > distance then
					if findPath(pos, tilePos) then
						nearest = table.copy(hasInfo)
						nearest.distance = distance
						nearest.pos = tilePos
					end
				end
            end
        end
    end
    return nearest
end

Jump.removeText = function()
    local tile = g_map.getTile(Jump.Pos)
    if tile then
        tile:setText("")
    end
end

Jump.oldPos = nil

onPlayerPositionChange(function(newPos, oldPos)
	Jump.oldPos = oldPos
end)
onTalk(function(name, _, _, text)
	if name == player:getName() and Jump.autoMark and Jump.autoMark.isOn() then
		if text:lower():find('jump') then
			local oldPos = Jump.postostring(Jump.oldPos)
			if not storage.jumps[oldPos] then
				storage.jumps[oldPos] = {
					direction = Jump.actualDirection(),
					jumpTo = text:trim()			
				}
				player:setText('Saved:\n' .. oldPos .. "\n" .. text:trim())
				schedule(1000, function()
					player:clearText()
				end)
			end
		end
	end
end)


Jump.Pos = {x = 0, y = 0, z = 0}

onPlayerPositionChange(
    function(newPos, oldPos)
        Jump.waitToWalk = nil
    end
)


Jump.autoMark = macro(1, 'Auto Marca Jump', function() end)


Jump.nextPosition = {
	{x = 0, y = -1},
	{x = 1, y = 0},
	{x = 0, y = 1},
	{x = -1, y = 0},
	{x = 1, y = -1},
	{x = 1, y = 1},
	{x = -1, y = 1},
	{x = -1, y = -1}
}

Jump.getPosition = function(pos, dir)
	local nextPos = Stairs.nextPosition[dir + 1]
	
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

Jump.reverseDirection = {
	2,
	3,
	0,
	1,
	6,
	7,
	4,
	5
}

function Jump.doReverse(dir)
	return Jump.reverseDirection[dir + 1]
end



Jump.goUse = function(pos)
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
        playerPos = Jump.getPosition(playerPos, Jump.doReverse(v))
    end
	local tile = g_map.getTile(playerPos)
	local topThing = tile and tile:getTopUseThing()
    if topThing then
		if storage.kunaiId and storage.useKunai then
			useWith(storage.kunaiId, topThing)
		end
		use(topThing)
	end
end


Jump.macro =
    macro(
    1,
    "Jump 'F'",
    function()
        if isKeyPressed(Jump.remove) then
            local tile = getTileUnderCursor()
            return Jump.removeIt(tile and tile:getPosition())
        end
        checarSave = Jump.upOrdown()
        local pos = pos()
        local textPos = Jump.postostring(pos)
        if checarSave then
            save = "Jump down"
            if checarSave == 1 then
                save = "Jump up"
            end
            player:setText("Saved:\n" .. textPos .. "\n" .. save)
            schedule(
                1000,
                function()
                    player:clearText()
                end
            )
            storage.jumps[textPos] = {
                jumpTo = save,
                direction = Jump.actualDirection()
            }
            Jump.lastPos = nil
            return
        end
        if
            storage.jumps and Jump.lastPos ~= textPos and
                not (isKeyPressed(Jump.tecla) and Jump.Pos.z == pos.z)
         then
            Jump.removeText()
            Jump.actual = Jump.findJump()
            Jump.Pos = Jump.actual.pos
            Jump.lastPos = textPos
        end
        Jump.tile = g_map.getTile(Jump.Pos)
        if Jump.tile then
            local distance = getDistanceBetween(Jump.Pos, pos)
            if isKeyPressed(Jump.tecla) then
                Jump.tile:setText(Jump.actual.jumpTo, "green")
                if distance >= 1 then
                    if not Jump.waitToWalk and autoWalk(Jump.Pos, 1) then
                        Jump.waitToWalk = true
                    end
					Jump.goUse(Jump.Pos)
                else
                    g_game.turn(Jump.actual.direction)
                    say('Jump "' .. Jump.actual.jumpTo:split(" ")[2])
                    say(Jump.actual.jumpTo)
                end
            else
                Jump.tile:setText(Jump.actual.jumpTo, "red")
            end
        end
    end
)

extraJumpDirections = {

	['W'] = {x = 0, y = -1, dir = 0},
	['D'] = {x = 1, y = 0, dir = 1},
	['S'] = {x = 0, y = 1, dir = 2},
	['A'] = {x = -1, y = 0, dir = 3},


}


local timeStand = now


onPlayerPositionChange(function(newPos, oldPos)
	timeStand = now
end)

standingTime = function()
	return now - timeStand
end



UI.Separator()

-- Magic wall & Wild growth timer

-- config
local magicWallId = 2128
local magicWallTime = 20000
local wildGrowthId = 2130
local wildGrowthTime = 45000

-- script
local activeTimers = {}

onAddThing(function(tile, thing)
  if not thing:isItem() then
    return
  end
  local timer = 0
  if thing:getId() == magicWallId then
    timer = magicWallTime
  elseif thing:getId() == wildGrowthId then
    timer = wildGrowthTime
  else
    return
  end
  
  local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
  if not activeTimers[pos] or activeTimers[pos] < now then    
    activeTimers[pos] = now + timer
  end
  tile:setTimer(activeTimers[pos] - now)
end)

onRemoveThing(function(tile, thing)
  if not thing:isItem() then
    return
  end
  if (thing:getId() == magicWallId or thing:getId() == wildGrowthId) and tile:getGround() then
    local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
    activeTimers[pos] = nil
    tile:setTimer(0)
  end  
end)


UI.Separator()


Stairs.macro = macro(1, "Auto-Escadas 'Espaco' ", function()
	if Stairs.actualPos then
		Stairs.actualTile = g_map.getTile(Stairs.actualPos)
	end
	if isKeyPressed("Space") then
		if modules.game_console:isChatEnabled() then
			modules.game_textmessage.displayFailureMessage('Desative o chat para usar o auto-escadas.')
		elseif Stairs.actualTile then
			markOnThing(Stairs.actualTile, "#00FF00")
			Stairs.doWalk()
		else
			modules.game_textmessage.displayFailureMessage('Sem escadas por perto.')
		end
	elseif Stairs.actualTile then
		if Stairs.isTrying then
			Stairs.isTrying = nil
			for i = 1, 10 do
				player:lockWalk(100)
				player:stopAutoWalk()
				g_game.stop()
			end
		end
		markOnThing(Stairs.actualTile, "#FF0000")
	end
end)



function checkPos(x, y)
    local xyz = g_game.getLocalPlayer():getPosition()
    xyz.x = xyz.x + x
    xyz.y = xyz.y + y
    local tile = g_map.getTile(xyz)
	local topThing = tile and tile:getTopUseThing()
    if topThing then
		if storage.useKunai and storage.idKunai then
			useWith(storage.idKunai, topThing)
		end
		use(topThing)
	end
end

function getClosest(table)
    local closest
    if type(table) ~= "table" then
        return
    end
    for v, x in pairs(table) do
        if not closest or Stairs.accurateDistance(closest) > Stairs.accurateDistance(x:getPosition()) then
            closest = x
        end
    end
    return closest and Stairs.accurateDistance(closest) or false
end

function hasNonWalkable(direc)
    local tabela = {}
    for i = 1, #direc do
        local tile =
            g_map.getTile(
            {
                x = player:getPosition().x + direc[i][1],
                y = player:getPosition().y + direc[i][2],
                z = player:getPosition().z
            }
        )
        if tile and not tile:isWalkable(false) and tile:canShoot() then
            table.insert(tabela, tile)
        end
    end
    return tabela
end

function getClosestBetween(x, y)
    if not x and not y then
        return false
    end
    if x and not y then
        return 1
    elseif y and not x then
        return 2
    end
    if x < y then
        return 1
    else
        return 2
    end
end

function getDash(dir)
    if not dir then
        return false
    end
    local dirs = {}
    local tiles = {}
    local dirs = {}
    if dir == "n" then
        dirs = {{0, -1}, {0, -2}, {0, -3}, {0, -4}, {0, -5}, {0, -6}, {0, -7}, {0, -8}}
    elseif dir == "s" then
        dirs = {{0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}, {0, 7}, {0, 8}}
    elseif dir == "w" then
        dirs = {{-1, 0}, {-2, 0}, {-3, 0}, {-4, 0}, {-5, 0}, {-6, 0}}
    elseif dir == "e" then
        dirs = {{1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}}
    end
    for i = 1, #dirs do
        local tile =
            g_map.getTile(
            {
                x = player:getPosition().x + dirs[i][1],
                y = player:getPosition().y + dirs[i][2],
                z = player:getPosition().z
            }
        )
        if tile and Stairs.checkTile(tile) and tile:canShoot() then
            table.insert(tiles, tile)
        end
    end
    if not tiles[1] or getClosestBetween(getClosest(hasNonWalkable(dirs)), getClosest(tiles)) == 1 then
        return false
    else
        return true
    end
end


UI.Separator()

UI.Button("Zoom In map [ctrl + =]", function() zoomIn() end)
UI.Button("Zoom Out map [ctrl + -]", function() zoomOut() end)

UI.Separator()
  
  
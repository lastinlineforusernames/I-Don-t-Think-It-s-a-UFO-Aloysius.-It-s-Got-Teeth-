-- Random math
function rando(noiseSeed, randSeed, scaleFactor)
    randoValue = math.floor(mapHeight * scaleFactor + remap(
        love.math.noise(noiseSeed) * math.random(randSeed), 0, randSeed, 
        0 - randSeed / 2, randSeed / 2))
    return randoValue
end

-- Remap values to new scale
function remap(oldValue, oldMin, oldMax, newMin, newMax)
    newValue = (((oldValue - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin
    return newValue
end

-- Generate coordinate for a star
function star()
    s = love.math.random(mapWidth)
    return s
end

-- Generate table of coordinates used for terrian generation
function generateGround(noiseSeed, randSeed, divisions, xWidth, yHeight, scaleFactor)
    local startWidth = 100
    local groundWidth = xWidth - startWidth * 2
    table.insert(ground, xWidth / 2)
    table.insert(ground, yHeight + yHeight)
    table.insert(ground, 0)
    table.insert(ground, yHeight)
    table.insert(ground, 0)
    table.insert(ground, math.floor(mapHeight * scaleFactor))
    table.insert(ground, startWidth)
    table.insert(ground, math.floor(mapHeight * scaleFactor))
    
    for x = 1, divisions - 1 do
        table.insert(ground, startWidth + (groundWidth / divisions) * x)
        table.insert(ground, rando(noiseSeed, randSeed, scaleFactor))
    end

    table.insert(ground, xWidth - startWidth)
    table.insert(ground, math.floor(mapHeight * scaleFactor))
    table.insert(ground, xWidth)
    table.insert(ground, math.floor(mapHeight * scaleFactor))
    table.insert(ground, xWidth)
    table.insert(ground, yHeight)

    return ground
end

-- Fills the sky with stars
function generateStars(a)
    
    for x = 1, a do
        table.insert(stars, star())
        table.insert(stars, star())
    end

    return stars
end

-- Create the world and boundaries
function generateWorld()
    world = p.newWorld(0, GRAVITY, true)
    
    bounds.shape = p.newChainShape(true, 0, 0, 0, mapHeight, mapWidth, mapHeight, mapWidth, 0)
    bounds.body = p.newBody(world, 0, 0, 'static')
    bounds.fixture = p.newFixture(bounds.body, bounds.shape)
end

-- Initialize the world
function startWorld()
    generateWorld()
    map = Map()
    player = Player()
    ufo1 = UFO()
    home = Home()
end

-- Control functionality
function k.wasPressed(key)
    if (k.keysPressed[key]) then
        return true
    else
        return false
    end
end

function k.wasReleased(key)
    if (k.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'c' then
        if gamestate == 'gameover' then
            sounds['start']:play()
            continue = true
            continues = continues + 1
        end
    end
    anyKey = anyKey + 1
    k.keysPressed[key] = true
end

function love.keyreleased(key)
    k.keysReleased[key] = true
    anyKey = anyKey - 1
end

-- Returns positive or negative for input value
function sign(n)
    return n == 0 and 0 or n / math.abs(n)
end
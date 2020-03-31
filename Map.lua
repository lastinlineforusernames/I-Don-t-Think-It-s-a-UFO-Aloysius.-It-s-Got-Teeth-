Map = Class{}


function Map:init()
    ground = generateGround(math.random(), terrainSeed, terrainDensity, mapWidth, mapHeight, MAPSCALE)
    stars = generateStars(starCount)

    terrain.shape = love.physics.newChainShape(true, ground)
    terrain.body = love.physics.newBody(world, 0, 0, 'static')
    terrain.fixture = love.physics.newFixture(terrain.body, terrain.shape)

end

function Map:update(dt)

end

function Map:render()
    -- Render Map
    g.setColor(1, 1, 1, 1)
    g.points(stars)

    g.setColor(.5, .5, .5, 1)
    g.polygon('fill', terrain.shape:getPoints())
    g.setColor(0, 0, 0, 1)
    g.line(terrain.shape:getPoints())
end
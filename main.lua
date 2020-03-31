--[[ I Don't Think It's a UFO, Aloysius. It's Got Teeth
    Project created by Kat for CS50
    class.lua by Matthias Richter, Animation.lua by Colton Ogden
    pewpew code adapted from https://yal.cc/love2d-shooting-things/
    home.png is a vector graphic included with Serif's Affinity Designer
    additional code inspiration & ideas from the incredibly helpful Love2d forums 
]]

-- Coding shortcuts
p = love.physics
g = love.graphics
k = love.keyboard

-- Set up constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
MOVE_SPEED = 225
GRAVITY = 9.8 * 24
MAPSCALE = 0.85

-- Set up globals
gamestate = 'start'
anyKey = 0
continue = false
continues = 0
wins = 0
maxWins = 10
score = 0
world = {}
terrain = {}
objects = {}
bounds = {}
mapFactorStart = 1
mapFactor = mapFactorStart
mapWidth = WINDOW_WIDTH * mapFactor
mapHeight = WINDOW_HEIGHT
ground = {}
stars = {}
starCount = 500 * mapFactor
terrainSeed = 150
terrainDensity = 50 * mapFactor
direction = 0
dx = 0
dy = 0
ballSize = 16
ball2Size = 16
ballX = 0
ball2X = 0

-- Set up file dependancies
Class = require 'class'
require 'Utility'
require 'Map'
require 'Animation'
require 'UFO'
require 'Player'
require 'Home'

function love.load()

    -- Set up window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle("I Don't Think It's a UFO, Aloysius. It's got Teeth.")

    -- Set up title screen
    title = {
        sprite = g.newImage('graphics/Title.png'),
        width = 1495,
        height = 1383
    }

    -- Audio set up
    sounds = {
        ['start'] = love.audio.newSource('audio/Start.wav', 'static'),
    }

    music = love.audio.newSource('audio/BeepBox.wav', 'static')
    music:setLooping(true)
    music:play()

    -- Random seed for procedural generation
    math.randomseed(os.time())

    -- Function to create world elements
    startWorld()
    
    -- Set up camera position
    camX = 0
    camY = 0

    -- Set up keys
    k.keysPressed = {}
    k.keysReleased = {}
end

function love.update(dt)
    -- Update world state
    world:update(dt)
    player:update(dt)
    ufo1:update(dt)
    home:update(dt)

    -- Set up camera movement
    camX = math.max(0, math.min(objects.ball.body:getX() - WINDOW_WIDTH / 2,
        math.min(mapWidth - WINDOW_WIDTH, objects.ball.body:getX())))

    -- Gamestate management
    if gamestate == 'gameover' then
        ufo1.sounds['readyBeam']:stop()
        camX = 0
        camY = 0
        objects.ball.body:setLinearVelocity(0, 0)
        objects.ball2.body:setLinearVelocity(0, 0)
        -- player:init()
        if continue == true then
            if wins >= maxWins then
                continue = false
                score = 0
                wins = 0
                continues = 0
                mapFactor = mapFactorStart
                terrainDensity = 50 * mapFactor
                mapWidth = WINDOW_WIDTH * mapFactor
                home.xPos = mapWidth - 50
                generateWorld()
                gamestate = 'play'
                ground = {}
                map:init()
                player:init()
                ufo1:init()
            else
                continue = false
                gamestate = 'play'
                player:init()
                ufo1:init()
            end
        end
    elseif gamestate == 'win' then
        ufo1.sounds['readyBeam']:stop()
        score = score + 1000 * wins
        mapFactor = mapFactor + 0.25
        terrainDensity = 50 * mapFactor
        mapWidth = WINDOW_WIDTH * mapFactor
        home.xPos = mapWidth - 50
        generateWorld()
        gamestate = 'play'
        ground = {}
        map:init()
        player:init()
        ufo1:init()
    elseif gamestate == 'start' then
        if anyKey > 0 then
            sounds['start']:play()
            gamestate = 'play'
            player:init()
            ufo1:init()
        end
    end

    -- Reset keys
    k.keysPressed = {}
    k.keysReleased = {}
end

function love.draw()
    -- Set Camera Movement
    g.translate(math.floor(-camX + 0.5), math.floor(-camY + 0.5))
    
    -- Set Background
    g.clear(.1, .08, .15, 0)
    
    -- Draw gamestate
    if gamestate == 'gameover' then
        if wins >= maxWins then
            g.printf('HUZZAH! MORT AND ALOYSIUS ARE SAFE! THINGS GOT A LITTLE HAIRY AROUND WORLD 7 THERE, BUT NICE JOB PULLING THOUGH AND SAVING THE DAY', 
                0, WINDOW_HEIGHT / 2 - 40, WINDOW_WIDTH, 'center')
            g.printf('SCORE ' .. string.format('%06d', score), 0, WINDOW_HEIGHT / 2 - 20, WINDOW_WIDTH, 'center')
            g.printf('CONTINUES ' .. continues, 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')
            if continues > 0 then
                g.printf('PRESS C TO RELIVE THE GLORY YOU JUST EXPERIENCED, BUT MAYBE TRY TO NOT LET MORTIMER GET ABDUCTED THIS TIME', 
                    0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, 'center')
            else
                g.printf('PRESS C TO RELIVE THE GLORY YOU JUST EXPERIENCED', 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, 'center')
            end
            g.printf('THANKS FOR PLAYING!', 0, WINDOW_HEIGHT / 2 + 40, WINDOW_WIDTH, 'center')
        else
            g.printf('GAME OVER', 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, 'center')
            g.printf('PRESS C TO TRY TO DO BETTER. YOU OWE IT TO POOR MORTIMER', 0, WINDOW_HEIGHT / 2 + 30, WINDOW_WIDTH, 'center')
        end
    elseif gamestate == 'start' then
        g.draw(title.sprite, 125, WINDOW_HEIGHT / 2, 0, 0.4, 0.4, 0, title.height / 2)
        g.printf("PRESS ANY KEY TO BEGIN YOUR LIFE'S GREATEST ADVENTURE", 0, WINDOW_HEIGHT / 2 - 40, WINDOW_WIDTH - 125, 'right')
        g.printf('KEEP MORTIMER AND ALOYSIUS SAFE FROM THE TOOTHY INVADER!', 0, WINDOW_HEIGHT / 2 - 20, WINDOW_WIDTH - 125, 'right')
        g.printf('USE LEFT AND RIGHT ARROWS TO MOVE ALOYSIUS, MORT WILL FOLLOW', 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH - 125, 'right')
        g.printf('PRESS ENTER TO THROW YOUR MIGHTY BEANS WITH A VIGOROUS FORCE', 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH - 125, 'right')
        g.printf('PRESS SPACE TO GRACEFULLY LEAP THROUGH THE AIR LIKE A GAZELLE', 0, WINDOW_HEIGHT / 2 + 40, WINDOW_WIDTH - 125, 'right')
    elseif gamestate == 'play' then
        map:render()
        ufo1:render()
        player:render()
        home:render()
        g.printf('WORLD ' .. string.format('%02d', wins + 1), camX + 30, 15, WINDOW_WIDTH - 60, 'left')
        g.printf('SCORE ' .. string.format('%06d', score), camX + 30, 15, WINDOW_WIDTH - 60, 'right')
    end
end
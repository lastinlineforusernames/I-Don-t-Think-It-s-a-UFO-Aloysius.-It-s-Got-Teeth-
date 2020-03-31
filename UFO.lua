UFO = Class{}


function UFO:init()
    -- UFO setup
    self.direction = 'left'
    self.speed = 2
    self.timer = 0
    self.delay = 2
    
    self.width = 128
    self.height = 64
    self.xOffset = self.width / 2
    self.yOffset = self.height / 2
    self.posX = WINDOW_WIDTH - self.width
    self.posY = self.height * 2

    beam = false
    beamLeft = self.posX - 20
    beamRight = self.posX + 20
    ufoY = self.posY + self.yOffset

    tractorBeam = {}
    
    self.sprite = g.newImage('graphics/UFO.png')
    self.sounds = {
        ['readyBeam'] = love.audio.newSource('audio/TractorBeam.wav', 'static')
    }
    self.sounds['readyBeam']:setLooping(true)

    self.frames = {}

    self.currentFrame = nil

    self.state = 'idle'

    -- Animation setup
    self.animations = {
        ['idle'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(0, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(128, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(0, 0, 128, 64, self.sprite:getDimensions()),
            },
            interval = 0.2
        }),
        ['readyBeam'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(256, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(128, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(256, 0, 128, 64, self.sprite:getDimensions())
            },
            interval = 0.15
        }),
        ['hit'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(256, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(384, 0, 128, 64, self.sprite:getDimensions()),
                g.newQuad(512, 0, 128, 64, self.sprite:getDimensions())
            },
            interval = 0.1
        })
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- Set up behavior logic
    self.behaviors = {
        ['idle'] = function(dt)
            self.animation = self.animations['idle']
            self.sounds['readyBeam']:stop()
            if self.direction == 'left' then
                self.posX = self.posX - self.speed
            else
                self.posX = self.posX + self.speed
            end
            tractorBeam = {self.posX - 20, self.posY, self.posX - 100, 
                mapHeight, self.posX + 100, mapHeight, 
                self.posX + 20, self.posY}
        end,
        ['readyBeam'] = function(dt)
            self.animation = self.animations['readyBeam']
            self.sounds['readyBeam']:play()
            tractorBeam = {self.posX - 20, self.posY, self.posX - 100, 
                mapHeight, self.posX + 100, mapHeight, 
                self.posX + 20, self.posY}
        end,
        ['hit'] = function(dt)
            self.animation = self.animations['hit']
            self.sounds['readyBeam']:stop()
            beam = false
            -- self.timer = 0
            tractorBeam = {}
        end
    }
end

function UFO:update(dt)
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()

    -- Movement
    if self.posX < camX + self.width then
        self.direction = 'right'
    elseif self.posX > camX + WINDOW_WIDTH - self.width then
        self.direction = 'left'
    end
    
    beamLeft = self.posX - 20
    beamRight = self.posX + 20

    -- State management
    if self.state == 'idle' then
        if ball2X > beamLeft and ball2X < beamRight then
            self.timer = 0
            self.state = 'readyBeam'
            beam = true
        end
    elseif self.state == 'readyBeam' then
        if self.timer < self.delay then
            self.timer = self.timer + 1 * dt
        elseif self.timer > self.delay then
            self.state = 'idle'
            beam = false
        end
    elseif self.state == 'hit' then
        if self.timer < self.delay then
            self.timer = self.timer + 1 * dt
        elseif self.timer > self.delay then
            self.state = 'idle'
        end 
    end
end

function UFO:render()
    -- Sprite flipping
    local scaleX

    if self.direction == 'left' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- Draw tractor beam
    if self.state == 'readyBeam' then
        g.setColor(0, 0.8, 0.9, 0.1)
        g.polygon('fill', tractorBeam)
    end

    -- Draw UFO
    g.setColor(1, 1, 1, 1)
    g.draw(self.sprite, self.currentFrame,
        self.posX, self.posY, 0, scaleX, 1, self.xOffset, self.yOffset)
end
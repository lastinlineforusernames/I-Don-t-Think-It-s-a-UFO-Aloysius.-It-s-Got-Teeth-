Player = Class{}


function Player:init()
    -- Player setup
    self.direction = 'right'
    self.moveFactor = 3
    self.jumpFactor = 1.2

    self.width = 32
    self.height = 32
    self.xOffset = self.width / 2
    self.yOffset = self.height / 2
    self.rotate = 0
    
    self.sprite = g.newImage('graphics/aloysius2.png')

    self.sounds = {
        ['hit'] = love.audio.newSource('audio/Explosion4.wav', 'static'),
        ['jump1'] = love.audio.newSource('audio/Jump6.wav', 'static'),
        ['jump2'] = love.audio.newSource('audio/Jump10.wav', 'static'),
        ['pew'] = love.audio.newSource('audio/Beans.wav', 'static'),
        ['lose'] = love.audio.newSource('audio/Lose.wav', 'static')
    }
    
    self.frames = {}

    self.currentFrame = nil
    
    self.state = 'idle'
    self.timer = 0
    self.delay = 0.33
    self.jump = false
    
    pew = 0
    pewPause = .4
    pewpew = {}

    -- Animation setup
    self.animations = {
        ['idle'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(64, 0, 32, 32, self.sprite:getDimensions())
            }
        }),
        ['moving'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(64, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(32, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(0, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(0, 0, 32, 32, self.sprite:getDimensions())
            },
            interval = 0.1
        }),
        ['throw'] = Animation({
            texture = self.sprite,
            frames = {
                g.newQuad(64, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(96, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(128, 0, 32, 32, self.sprite:getDimensions()),
                g.newQuad(64, 0, 32, 32, self.sprite:getDimensions())
            },
            interval = 0.1
        })

    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()
    
        -- Setup physics and collision for Aloysius
        objects.ball = {}
        objects.ball.body = p.newBody(world, ground[7] - ballSize / 2, ground[8] - ballSize, "dynamic")
        objects.ball.shape = p.newRectangleShape(ballSize * 0.9, ballSize * 2 * 1.25)
        objects.ball.fixture = p.newFixture(objects.ball.body, objects.ball.shape)
        objects.ball.body:setMass(1)
    
        -- Setup physics and collision for Mortimer
        objects.ball2 = {}
        objects.ball2.body = p.newBody(world, ground[7] - (ballSize / 2 + ball2Size * 2), ground[8] - ball2Size, "dynamic")
        objects.ball2.shape = p.newRectangleShape(ball2Size, ball2Size * 2)
        objects.ball2.fixture = p.newFixture(objects.ball2.body, objects.ball2.shape)
        objects.ball2.body:setMass(1)

    -- Setup behaviors
    self.behaviors = {
        ['idle'] = function(dt)
            if k.wasPressed('space') and gamestate == 'play' then
                self.state = 'moving'
                self.timer = 0
                self.jump = true
                self.animation = self.animations['moving']
                if objects.ball.body:isTouching(terrain.body) or
                    objects.ball.body:isTouching(objects.ball2.body) then
                    objects.ball.body:setLinearVelocity(dx, -MOVE_SPEED * self.jumpFactor)
                    self.sounds['jump1']:play()
                end
            elseif k.isDown('return') then
                self.state = 'throw'
                self.animation = self.animations['throw']
            elseif k.isDown('left') then
                self.direction = 'left'
                self.state = 'moving'
                self.animation = self.animations['moving']
                direction = MOVE_SPEED * -1
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            elseif k.isDown('right') then
                self.direction = 'right'
                self.state = 'moving'
                self.animation = self.animations['moving']
                direction = MOVE_SPEED
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            else
                direction = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end
        end,
        ['throw'] = function(dt)
            if k.wasPressed('space') and gamestate == 'play' then
                self.state = 'moving'
                self.timer = 0
                self.jump = true
                self.animation = self.animations['moving']
                if objects.ball.body:isTouching(terrain.body) or
                    objects.ball.body:isTouching(objects.ball2.body) then
                    objects.ball.body:setLinearVelocity(dx, -MOVE_SPEED * self.jumpFactor)
                    self.sounds['jump1']:play()
                end
            elseif k.isDown('return') then
                self.state = 'throw'
                self.animation = self.animations['throw']
            elseif k.isDown('left') then
                self.direction = 'left'
                self.state = 'moving'
                self.animation = self.animations['moving']
                direction = MOVE_SPEED * -1
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            elseif k.isDown('right') then
                self.direction = 'right'
                self.state = 'moving'
                self.animation = self.animations['moving']
                direction = MOVE_SPEED
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            else
                direction = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end
        end,
        ['moving'] = function(dt)
            if k.wasPressed('space') and gamestate == 'play' then
                self.state = 'moving'
                self.timer = 0
                self.jump = true
                if objects.ball.body:isTouching(terrain.body) or
                    objects.ball.body:isTouching(objects.ball2.body) then
                    objects.ball.body:setLinearVelocity(dx, -MOVE_SPEED * self.jumpFactor)
                    self.sounds['jump1']:play()
                end
            elseif k.isDown('return') then
                self.state = 'throw'
                self.animation = self.animations['throw']
            elseif k.isDown('left') then
                self.direction = 'left'
                self.state = 'moving'
                direction = MOVE_SPEED * -1
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            elseif k.isDown('right') then
                self.direction = 'right'
                self.state = 'moving'
                direction = MOVE_SPEED
                objects.ball.body:setLinearVelocity(direction / self.moveFactor, dy)
            else
                direction = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end
        end
    }

end

function shoot_update(dt)
    -- Pewpew movement
    for i, o in ipairs(pewpew) do 
        o.pewX = o.pewX + math.cos(o.pewDir) * o.pewSpeed * dt
        o.pewY = o.pewY + math.sin(o.pewDir) * o.pewSpeed * dt
    end

    -- Remove old pewpews
    for i = #pewpew, 1, -1 do
        local o = pewpew[i]
        if (o.pewX < -10) or (o.pewX > mapWidth + 10) or (o.pewY < -10) or (o.pewY > mapHeight + 10) then
            table.remove(pewpew, i)
        end
        if (o.pewX < ufo1.posX + 60) and (o.pewX > ufo1.posX - 60) and (o.pewY < ufo1.posY + 10) and (o.pewY > ufo1.posY - 10) then
            table.remove(pewpew, i)
            ufo1.state = 'hit'
            ufo1.timer = 0
            player.sounds['hit']:play()
            score = score + 100
        end
    end
end

function Player:update(dt)
    -- Get current velocity
    dx, dy = objects.ball.body:getLinearVelocity()
    mort_dx, mort_dy = objects.ball2.body:getLinearVelocity()

    -- Update animation & movement
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
   
    ballX = objects.ball.body:getX()
    ballY = objects.ball.body:getY()
    ball2X = objects.ball2.body:getX()
    ball2Y = objects.ball2.body:getY()

    -- Make with the pewpew
    if k.wasPressed('return') and pew <= 0 and ufo1.state ~= 'hit' and gamestate == 'play' then
        local pewDirection = math.atan2(ufo1.posY - ballY, ufo1.posX - ballX)
        self.sounds['pew']:play()
        table.insert(pewpew, {
            pewX = ballX,
            pewY = ballY,
            pewDir = pewDirection,
            pewSpeed = 200
        })
        pew = pewPause
    end
    pew = math.max(0, pew - dt)
  
    shoot_update(dt)

    -- Tractor beam interaction and Mortimer's movement
    if beam == true then
        objects.ball2.body:setLinearVelocity(0, -MOVE_SPEED / 2)
        self.rotate = self.rotate + .05
        if ball2Y < ufoY then
            beam = false
            self.sounds['lose']:play()
            gamestate = 'gameover'
        end
    elseif beam == false then
        self.rotate = 0
        if math.abs(ballX - ball2X) > ballSize * 6 then
            local aloysiusVector = MOVE_SPEED * sign(ballX - ball2X)
            if objects.ball2.body:isTouching(terrain.body) then
                objects.ball2.body:setLinearVelocity(aloysiusVector / self.moveFactor, -MOVE_SPEED)
                self.sounds['jump2']:play()
            else
                objects.ball2.body:setLinearVelocity(aloysiusVector / self.moveFactor, mort_dy)
            end
        end
    end
    
end

function Player:render()
    -- Sprite flipping
    local scaleX1
    local scaleX2

    if self.direction == 'right' then
        scaleX1 = 0.9
    else
        scaleX1 = -0.9
    end

    if objects.ball.body:getX() > objects.ball2.body:getX() then
        scaleX2 = 1
    else
        scaleX2 = -1
    end

    -- Draw Aloysius
    g.setColor(1, 1, 1, 1)
    g.draw(self.sprite, self.currentFrame, 
        objects.ball.body:getX(), objects.ball.body:getY(), 
        0, scaleX1, 1.25, self.xOffset, self.yOffset)
    -- Draw Mortimer
    g.draw(self.sprite, self.currentFrame, 
        objects.ball2.body:getX(), objects.ball2.body:getY(), 
        self.rotate, scaleX2, 1, self.xOffset, self.yOffset)

    -- Draw the pewpew
    for i, o in ipairs(pewpew) do
        g.circle('fill', o.pewX, o.pewY, 2, 8)
    end
end
Home = Class{}


function Home:init()
    self.sprite = g.newImage('graphics/home.png')
    self.height = 128
    self.width = 128
    self.xOffset = self.width / 2
    self.yOffset = self.height
    self.scale = 0.5
    self.xPos = mapWidth - 50
    self.yPos = math.floor(mapHeight * MAPSCALE)
    self.sounds = {
        ['win'] = love.audio.newSource('audio/Win.wav', 'static')
    }
end

function Home:update(dt)
    -- Set up conditions to beat level
    if ballX > self.xPos - (self.width / 2 * self.scale) and
        ballX < self.xPos + (self.width / 2 * self.scale) and
        ballY > self.yPos - (self.height / 2 * self.scale) and
        ballY < self.yPos + (self.height / 2 * self.scale) then 
            if math.abs(ballX - ball2X) < 32 and math.abs(ballY - ball2Y) < 32 then
                wins = wins + 1
                if wins < maxWins then
                    gamestate = 'win'
                    self.sounds['win']:play()
                else
                    gamestate = 'gameover'
                    self.sounds['win']:play()
                end
            elseif math.abs(ballX - ball2X) > 32 or math.abs(ballY - ball2Y) > 32 then
                local aloysiusVector = MOVE_SPEED * sign(ballX - ball2X)
                if objects.ball2.body:isTouching(terrain.body) then
                    objects.ball2.body:setLinearVelocity(aloysiusVector / player.moveFactor, -MOVE_SPEED)
                    player.sounds['jump2']:play()
                else
                    objects.ball2.body:setLinearVelocity(aloysiusVector / player.moveFactor, mort_dy)
                end
            end
    end
end

function Home:render()
    -- Draw house
    g.setColor(1, 1, 1, 1)
    g.draw(self.sprite, self.xPos, self.yPos, 0, self.scale, self.scale, self.xOffset, self.yOffset)
end
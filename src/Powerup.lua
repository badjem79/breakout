--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Fabio Gemesio
    badjem79@gmail.com

    Represents a Powerup which will fall to the paddle and givin a powerup
    to the player
]]

Powerup = Class{}

function Powerup:init(type)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the Powerup can move in two dimensions
    self.dy = POWERUP_SPEED
    self.dx = 0

    -- this will effectively be the type of our Powerup, and we will index
    -- our table of Quads relating to the global block texture using this
    self.type = type
    self.inPlay = true
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:execute(paddle, balls)
    --Type 8 means: spawn 2 more balls
    if self.type == 8 then
        for i=1, 2, 1 do
            newBall = Ball()
            newBall.skin = math.random(7)
            --set position
            newBall.x = paddle.x + (paddle.width / 2) - 4
            newBall.y = paddle.y - 8
            --set veocity
            newBall.dx = math.random(-200, 200)
            newBall.dy = math.random(-50, -60)
            table.insert(balls, newBall)
        end
    elseif self.type == 10 then
        paddle.unlock = true 
    end
end
--[[
    Places the Powerup in the middle of the screen, with no movement.
]]
function Powerup:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Powerup:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- gPowerupFrames is a table of quads mapping to each individual Powerup type in the texture
    love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type],
        self.x, self.y)
end
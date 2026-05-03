Pipe = Class({})

local PIPE_IMG = love.graphics.newImage("pipe.png")
local PIPE_SCROLL = -60
PIPE_WIDTH = PIPE_IMG:getWidth()
PIPE_HEIGHT = PIPE_IMG:getHeight()

function Pipe:init()
	self.x = VIRTUAL_WIDTH
	self.y = math.random(VIRTUAL_WIDTH / 5, VIRTUAL_HEIGHT - 10)

	self.gap = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT / 2)
  self.scored = false

	self.width = PIPE_IMG:getWidth()
end

function Pipe:update(dt)
	self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:draw()
  -- Bottom pipe
	love.graphics.draw(PIPE_IMG, self.x, self.y)

  -- Top pipe
	if self.y - self.gap > 0 then
		love.graphics.draw(PIPE_IMG, self.x, self.y - self.gap, 0, 1, -1, 0)
	end
end

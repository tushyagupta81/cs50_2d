Bird = Class({})

GRAVITY = 980

function Bird:init()
	self.img = love.graphics.newImage("bird.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()

	self.x = VIRTUAL_WIDTH / 2 - self.width / 2
	self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

	self.dy = 0
end

function Bird:reset()
	self.x = VIRTUAL_WIDTH / 2 - self.width / 2
	self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

	self.dy = 0
end

function Bird:update(dt)
	self.dy = self.dy + GRAVITY * dt

	if love.keyboard.wasPressed("space") or love.mouse.wasPressed(1) then
		self.dy = self.dy - 500
		gSounds["jump"]:play()
	end

	self.dy = math.max(-300, self.dy)

	self.y = self.y + self.dy * dt
	-- self.y = math.max(self.y, 0)
end

function Bird:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

function Bird:collides(pipe)
	if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
		if (self.y + 2) + (self.height - 4) >= pipe.y then
			return true
		else
			if self.y + 2 <= pipe.y - pipe.gap then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class({ __includes = BaseState })
function PlayState:init()
	self.bird = Bird()
	self.pipes = {}
	self.timer = SPAWN_DIFF
	self.score = 0
end

function PlayState:update(dt)
	-- update timer for pipe spawning
	self.timer = self.timer + dt

	-- spawn a new pipe pair every second and a half
	if self.timer > SPAWN_DIFF then
		table.insert(self.pipes, Pipe())
		self.timer = 0
	end

	for _, pipe in pairs(self.pipes) do
		pipe:update(dt)
		if not pipe.scored and pipe.x + PIPE_WIDTH <= self.bird.x then
			self.score = self.score + 1
			pipe.scored = true
			gSounds["score"]:play()
		end
	end

	for k, pipe in pairs(self.pipes) do
		if pipe.x < -pipe.width then
			table.remove(self.pipes, k)
		end
	end

	self.bird:update(dt)

	for _, pipe in pairs(self.pipes) do
		pipe:update(dt)
		if self.bird:collides(pipe) then
			gSounds["hurt"]:play()
			gStateMachine:change("end", { ["score"] = self.score })
		end
	end

	-- reset if we get to the ground
	if self.bird.y < 0 or self.bird.y > VIRTUAL_HEIGHT - (self.bird.height + ground:getHeight()) then
		gSounds["explosion"]:play()
		gStateMachine:change("end", { ["score"] = self.score })
	end
end

function PlayState:draw()
	for _, pipe in pairs(self.pipes) do
		pipe:draw()
	end

	drawScore(self.score)

	self.bird:draw()
end

function drawScore(score)
	love.graphics.setFont(mediumFont)
	love.graphics.print("Score - " .. tostring(score), 3, 1)
end

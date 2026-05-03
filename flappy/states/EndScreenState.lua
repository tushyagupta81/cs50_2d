EndScreenState = Class({ __includes = BaseState })

function EndScreenState:enter(params)
  self.score = params.score
end

function EndScreenState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		score = 0
		gStateMachine:change("count")
	end
end

function EndScreenState:draw()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Game Over!", 0, 64, VIRTUAL_WIDTH, "center")

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Score - " .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, "center")
	love.graphics.printf("Press Enter to restart", 0, 120, VIRTUAL_WIDTH, "center")
end

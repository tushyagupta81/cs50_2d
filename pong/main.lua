WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_HEIGHT = 20

PADDLE_SPEED = 200

push = require("push")

Class = require("class")

require("Paddle")
require("Ball")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	smallFont = love.graphics.newFont("font.ttf", 8)
	scoreFont = love.graphics.newFont("font.ttf", 32)

	math.random(os.time())

	love.graphics.setFont(smallFont)

	score = {
		p1 = 0,
		p2 = 0,
	}

	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

	leftPaddle = Paddle(10, 30, 5, 20)
	rightPaddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

	serve = {
		p1 = true,
		p2 = false,
	}

	gameState = "start"

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		resizable = false,
		vsync = true,
		fullscreen = false,
	})

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { upscale = "normal" })
end

function love.draw()
	push:start()

	love.graphics.clear(40 / 255, 45 / 255, 20 / 255, 255 / 255)

	love.graphics.setFont(smallFont)
	if gameState == "start" then
		love.graphics.printf("Press enter to start", 0, 20, VIRTUAL_WIDTH, "center")
	elseif gameState == "serve" then
		if serve.p1 then
			love.graphics.printf("Player 1 to serve, press enter", 0, 20, VIRTUAL_WIDTH, "center")
		else
			love.graphics.printf("Player 2 to serve, press enter", 0, 20, VIRTUAL_WIDTH, "center")
		end
	end

	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(score.p1), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(score.p2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

	love.graphics.setFont(smallFont)

	leftPaddle:render()
	rightPaddle:render()

  ball:render()

	push:finish()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "enter" or key == "return" then
		if gameState == "start" then
			gameState = "serve"
		else
			gameState = "play"
      ball:reset()
		end
	end
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		rightPaddle.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown("down") then
		rightPaddle.dy = PADDLE_SPEED
	else
		rightPaddle.dy = 0
	end
	if love.keyboard.isDown("w") then
		leftPaddle.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown("s") then
		leftPaddle.dy = PADDLE_SPEED
	else
		leftPaddle.dy = 0
	end

	if gameState == "play" then
    ball:update(dt)
	end

	leftPaddle:update(dt)
	rightPaddle:update(dt)
end

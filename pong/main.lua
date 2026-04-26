WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_HEIGHT = 20

PADDLE_SPEED = 200

push = require("push")

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

	ball = {
		x = VIRTUAL_WIDTH / 2 - 2,
		y = VIRTUAL_HEIGHT / 2 - 2,
	}

	BALL_DX = math.random(2) == 1 and 100 or -100
	BALL_DY = math.random(-50, 50)

	paddle = {
		left = 10,
		right = VIRTUAL_HEIGHT - 30,
	}

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

	-- Paddle 1 LEFT
	love.graphics.rectangle("fill", 10, paddle.left, 5, PADDLE_HEIGHT)

	-- Paddle 2 RIGHT
	love.graphics.rectangle("fill", VIRTUAL_WIDTH - 15, paddle.right, 5, PADDLE_HEIGHT)

	-- BALL
	love.graphics.rectangle("fill", ball.x, ball.y, 4, 4)

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
			ball.x = VIRTUAL_WIDTH / 2 - 2
			ball.y = VIRTUAL_HEIGHT / 2 - 2
			BALL_DX = math.random(2) == 1 and 100 or -100
			BALL_DY = math.random(-50, 50) * 1.5
		end
	end
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		paddle.right = math.max(0, paddle.right - PADDLE_SPEED * dt)
	end
	if love.keyboard.isDown("down") then
		paddle.right = math.min(VIRTUAL_HEIGHT - PADDLE_HEIGHT, paddle.right + PADDLE_SPEED * dt)
	end
	if love.keyboard.isDown("w") then
		paddle.left = math.max(0, paddle.left - PADDLE_SPEED * dt)
	end
	if love.keyboard.isDown("s") then
		paddle.left = math.min(VIRTUAL_HEIGHT - PADDLE_HEIGHT, paddle.left + PADDLE_SPEED * dt)
	end

	if gameState == "play" then
		ball.x = ball.x + BALL_DX * dt
		ball.y = ball.y + BALL_DY * dt
	end
end

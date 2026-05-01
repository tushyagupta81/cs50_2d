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
	love.window.setTitle("Pongy")

	smallFont = love.graphics.newFont("font.ttf", 8)
	largeFont = love.graphics.newFont("font.ttf", 16)
	scoreFont = love.graphics.newFont("font.ttf", 32)

	math.random(os.time())

	love.graphics.setFont(smallFont)

	sounds = {
		["paddle_hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
		["score"] = love.audio.newSource("sounds/score.wav", "static"),
		["wall_hit"] = love.audio.newSource("sounds/wall_hit.wav", "static"),
	}

	score = {
		p1 = 0,
		p2 = 0,
	}

	serve = {
		p1 = true,
		p2 = false,
	}

	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	leftPaddle = Paddle(10, 30, 5, 20)
	rightPaddle = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

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

	love.graphics.clear(40 / 255, 40 / 255, 52 / 255, 255 / 255)

	love.graphics.setFont(smallFont)
	if gameState == "start" then
		love.graphics.printf("Press enter to start", 0, 20, VIRTUAL_WIDTH, "center")
	elseif gameState == "serve" then
		if serve.p1 then
			love.graphics.printf("Player 1 to serve, press enter", 0, 20, VIRTUAL_WIDTH, "center")
		else
			love.graphics.printf("Player 2 to serve, press enter", 0, 20, VIRTUAL_WIDTH, "center")
		end
	elseif gameState == "done" then
		-- UI messages
		love.graphics.setFont(largeFont)
		love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, "center")
		love.graphics.setFont(smallFont)
		love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_WIDTH, "center")
	end

	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(score.p1), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(score.p2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

	love.graphics.setFont(smallFont)

	leftPaddle:render()
	rightPaddle:render()

	ball:render()

	displayFPS()

	push:finish()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "enter" or key == "return" then
		if gameState == "start" then
			gameState = "serve"
		elseif gameState == "serve" then
			gameState = "play"
		elseif gameState == "done" then
			gameState = "serve"

			ball:reset()

			-- reset scores to 0
			score.p1 = 0
			score.p2 = 0

			serve.p1 = true
			serve.p2 = false
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

	if gameState == "serve" then
		ball.dy = math.random(-50, 50)
		if serve.p1 then
			ball.dx = math.random(140, 200)
		else
			ball.dx = -math.random(140, 200)
		end
	elseif gameState == "play" then
		if ball:collides(leftPaddle) then
			ball.dx = -ball.dx * 1.03
			ball.x = leftPaddle.x + 5

			-- keep velocity going in the same direction, but randomize it
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end

			sounds["paddle_hit"]:play()
		end

		if ball:collides(rightPaddle) then
			ball.dx = -ball.dx * 1.03
			ball.x = rightPaddle.x - 4

			-- keep velocity going in the same direction, but randomize it
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end

			sounds["paddle_hit"]:play()
		end

		-- detect upper and lower screen boundary collision and reverse if collided
		if ball.y <= 0 then
			ball.y = 0
			ball.dy = -ball.dy
			sounds["wall_hit"]:play()
		end

		-- -4 to account for the ball's size
		if ball.y >= VIRTUAL_HEIGHT - 4 then
			ball.y = VIRTUAL_HEIGHT - 4
			ball.dy = -ball.dy
			sounds["wall_hit"]:play()
		end

		ball:update(dt)

		if ball.x < 0 then
			serve.p1 = false
			serve.p2 = true
			sounds["score"]:play()

			score.p2 = score.p2 + 1
			if score.p2 >= 10 then
				gameState = "done"
				winningPlayer = 2
			else
				ball:reset()
				gameState = "serve"
			end
		end

		if ball.x > VIRTUAL_WIDTH then
			serve.p1 = true
			serve.p2 = false
			sounds["score"]:play()

			servingPlayer = 2
			score.p1 = score.p1 + 1
			if score.p1 >= 10 then
				gameState = "done"
				winningPlayer = 1
			else
				ball:reset()
				gameState = "serve"
			end
		end
	end

	leftPaddle:update(dt)
	rightPaddle:update(dt)
end

function displayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	love.graphics.setColor(1, 1, 1, 1)
end

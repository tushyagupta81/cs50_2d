WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require("push")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

  smallFont = love.graphics.newFont("font.ttf", 8)
  scoreFont = love.graphics.newFont("font.ttf", 32)

  love.graphics.setFont(smallFont)

  score = {
    p1 = 0,
    p2 = 0,
  }

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		resizable = false,
		vsync = true,
		fullscreen = false,
	})

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { upscale = "normal" })
end

function love.draw()
	push:start()

  love.graphics.clear(40/255, 45/255, 20/255, 255/255)

  love.graphics.setFont(smallFont)
	love.graphics.printf("Hello, pong!", 0, 20, VIRTUAL_WIDTH, "center")

  love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(score.p1), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(score.p2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  love.graphics.setFont(smallFont)
  love.graphics.rectangle("fill", 10, 10, 5, 20)

  love.graphics.rectangle("fill", VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

  love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	push:finish()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

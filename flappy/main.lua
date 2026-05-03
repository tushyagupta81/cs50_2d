push = require("push")

Class = require("class")

require("Bird")
require("Pipe")
require("StateMachine")
require("states.BaseState")
require("states.TitleScreenState")
require("states.CountdownState")
require("states.EndScreenState")
require("states.PlayState")

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- in seconds
SPAWN_DIFF = 2

-- background starting scroll location (X axis)
local backgroundScroll = 0

-- ground starting scroll location (X axis)
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

function love.load()
	math.random(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setTitle("Fifty bird")

	background = love.graphics.newImage("background.png")
	ground = love.graphics.newImage("ground.png")

	smallFont = love.graphics.newFont("font.ttf", 8)
	mediumFont = love.graphics.newFont("flappy.ttf", 14)
	flappyFont = love.graphics.newFont("flappy.ttf", 28)
	hugeFont = love.graphics.newFont("flappy.ttf", 56)
	love.graphics.setFont(flappyFont)

	gSounds = {
		["jump"] = love.audio.newSource("sounds/jump.wav", "static"),
		["explosion"] = love.audio.newSource("sounds/explosion.wav", "static"),
		["hurt"] = love.audio.newSource("sounds/hurt.wav", "static"),
		["score"] = love.audio.newSource("sounds/score.wav", "static"),

		-- https://freesound.org/people/xsgianni/sounds/388079/
		["music"] = love.audio.newSource("sounds/marios_way.mp3", "static"),
	}
	gSounds["music"]:setLooping(true)
	gSounds["music"]:play()

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = true,
	})

	---@diagnostic disable-next-line: redundant-parameter
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { upsacle = "normal" })

	gStateMachine = StateMachine({
		["title"] = TitleScreenState,
		["count"] = CountdownState,
		["play"] = PlayState,
		["end"] = EndScreenState,
	})
	gStateMachine:change("title")

	love.keyboard.keyPressed = {}
	love.buttonsPressed = {}
end

function love.resize(w, h)
	push.resize(w, h)
end

function love.update(dt)
	-- Slow scroll further away
	-- Fast scroll closer obj
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

	gStateMachine:update(dt)

	love.keyboard.keyPressed = {}
	love.buttonsPressed = {}
end

function love.mousepressed(x, y, button)
  love.buttonsPressed[button] = true
end

function love.keypressed(key)
	love.keyboard.keyPressed[key] = true

	if key == "escape" then
		love.event.quit()
	end
end

function love.mouse.wasPressed(button)
	if love.buttonsPressed[button] then
		return true
	else
		return false
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keyPressed[key] then
		return true
	else
		return false
	end
end

function love.draw()
	push:start()

	love.graphics.draw(background, -backgroundScroll, 0)
	gStateMachine:draw()
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	push:finish()
end

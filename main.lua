push = require 'push'
Class = require 'class'

require 'Bird'
require 'pipe'
require 'pipePair'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720 

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

cheriFont = love.graphics.newFont('cheri.ttf', 16)

local ground = love.graphics.newImage('images/ground.png')
local bg = love.graphics.newImage('images/bg.png')

local bgScroll = 0
local groundScroll = 0

local BG_SCROLL_SPEED = 60
local GROUND_SCROLL_SPEED = 120

local BG_LOOPING_POINT = 1536 - 512
local GROUND_LOOPING_POINT = 1536 - 512

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  love.keyboard.keysPressed = {} -- our own table in love.keyboard
end

local bird = Bird()
local pipePairs = {}
local spawnTimer = 0
local lastY = -PIPE_HEIGHT  + math.random(80) + 20

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  if key == 'escape' then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key) -- our own function
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.update(dt) 
  bgScroll = (bgScroll + BG_SCROLL_SPEED * dt)
    % BG_LOOPING_POINT

  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
    % VIRTUAL_WIDTH

  spawnTimer = spawnTimer + dt

  if spawnTimer > 1 then
    local y = math.max(-PIPE_HEIGHT + 10,
      math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    
    lastY = y

    table.insert(pipePairs, PipePair(y))
    spawnTimer = 0
  end

  bird:update(dt)

  for k, pair in pairs(pipePairs) do
    pair:update(dt)
  end

  for k, pair in pairs(pipePairs) do
    if pair.remove then
      table.remove(pipePairs, k)
    end
  end

  love.keyboard.keysPressed = {}


end

function love.draw() 
  love.graphics.clear(255, 230, 180, 255)
  push:start()
  love.graphics.draw(bg, -bgScroll, 42)

  for k, pair in pairs(pipePairs) do
    pair:render()
  end

  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-22)

  bird:render()

  displayFPS()

  push:finish()
end

function displayFPS()
  love.graphics.setFont(cheriFont)
  love.graphics.setColor(255,175,255,200 )
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
push = require 'push'
Class = require 'class'

require 'Bird'
require 'pipe'
require 'pipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/ScoreState'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720 

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local ground = love.graphics.newImage('images/ground.png')
local bg = love.graphics.newImage('images/bg.png')

local bgScroll = 0
local groundScroll = 0

BG_SCROLL_SPEED = 60
GROUND_SCROLL_SPEED = 120

local BG_LOOPING_POINT = 1536 - 512
local GROUND_LOOPING_POINT = 1536 - 512

local scrolling = true

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
  cheriFont = love.graphics.newFont('cheri.ttf', 64)
  cheriFont2 = love.graphics.newFont('cheri.ttf', 32)
  cheriFont3 = love.graphics.newFont('cheri.ttf', 64)
  love.graphics.setFont(cheriFont2)

  sounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['point'] = love.audio.newSource('sounds/point.wav', 'static'),
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['medal'] = love.audio.newSource('sounds/medal.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/RV428I.mp3', 'static'),
  }

  sounds['music']:setLooping(true)
  sounds['music']:play()
  
  medals = {
    ['medal1'] = love.graphics.newImage('images/quality.png'),
    ['medal2'] = love.graphics.newImage('images/badge.png'),
    ['medal3'] = love.graphics.newImage('images/medal.png')
  }

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,

  }
  gStateMachine:change('title')

  love.keyboard.keysPressed = {} -- our own table in love.keyboard
end

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
    % BG_LOOPING_POINT

  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}

end

function love.draw() 
  love.graphics.clear(255, 230, 180, 255)
  push:start()

  love.graphics.draw(bg, -bgScroll, 42)
  gStateMachine:render()


  -- for k, pair in pairs(pipePairs) do
  --   pair:render()
  -- end

  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-22)


  push:finish()
  -- displayFPS()

end

function displayFPS()
  love.graphics.setFont(cheriFont)
  love.graphics.setColor(255,255,255,255 )
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
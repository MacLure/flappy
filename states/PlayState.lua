PlayState = Class{__includes = BaseState}

PIPE_SPEED = 120
PIPE_HEIGHT = 100
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init(dt)
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0
  self.score = 0
  self.interval = 0
  self.lastY = -PIPE_HEIGHT  + math.random(80) + 20
  self.isPaused = false
  self.pauseText = ''
  self.medal1 = false
  self.medal2 = false
  self.medal3 = false

end

function PlayState:update(dt)
  if not self.isPaused then
    self.timer = self.timer + dt
    self.interval = math.random(0.8, 20)
    if self.timer > self.interval then
      local y = math.max(-PIPE_HEIGHT + 10,
        math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      self.lasyY = y
      table.insert(self.pipePairs, PipePair(y))
      self.timer = 0
    end


  for k, pair in pairs(self.pipePairs) do
    if not pair.scored then
      if pair.x + PIPE_WIDTH < self.bird.x then
        sounds['point']:play()
        self.score = self.score + 1
        pair.scored = true
        if self.score == 5 then
          sounds['medal']:play()
          self.medal1 = true
        end
        if self.score == 10 then
          sounds['medal']:play()
          self.medal2 = true
        end
        if self.score == 15 then
          sounds['medal']:play()
          self.medal3 = true
        end
      end
    end
    pair:update(dt)
  end

  for k, pair in pairs(self.pipePairs) do
    if pair.remove then
      table.remove(self.pipePairs, k)
    end
  end

  self.bird:update(dt)

  for k, pair in pairs(self.pipePairs) do
    for l, pipe in pairs(pair.pipes) do
      if self.bird:collides(pipe) then
        sounds['death']:play()
        gStateMachine:change('score', {
          score = self.score,
          medal1 = self.medal1,
          medal2 = self.medal2,
          medal3 = self.medal3,
        })
      end
    end
  end

  if self.bird.y > VIRTUAL_HEIGHT-42 then
    sounds['death']:play()
    gStateMachine:change('score', {
      score = self.score,
      medal1 = self.medal1,
      medal2 = self.medal2,
      medal3 = self.medal3,
    })
  end
end

  if love.keyboard.wasPressed('p')  then
    if not self.isPaused then
      sounds['music']:pause()
      sounds['pause']:play()
      PIPE_SPEED = 0
      BG_SCROLL_SPEED = 0
      GROUND_SCROLL_SPEED = 0
      self.pauseText = 'PAUSE'
      self.isPaused = true
    else
      sounds['music']:play()
      PIPE_SPEED = 120
      BG_SCROLL_SPEED = 60
      GROUND_SCROLL_SPEED = 120
      self.pauseText = ''
      self.isPaused = false
    end
  end
end

function PlayState:render()
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end
  if self.medal1 then
    love.graphics.draw(medals['medal1'], 10, 5)
  end
  if self.medal2 then
    love.graphics.draw(medals['medal2'], 50, 5)
  end
  if self.medal3 then
    love.graphics.draw(medals['medal3'], 90, 5)
  end
  love.graphics.setFont(cheriFont2)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 36)
  self.bird:render()
  love.graphics.setFont(cheriFont3)
  love.graphics.printf(self.pauseText, 0, 100, VIRTUAL_WIDTH, 'center')    
end
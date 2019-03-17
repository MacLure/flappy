ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
  self.medal1 = params.medal1
  self.medal2 = params.medal2
  self.medal3 = params.medal3

end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end 
end

function ScoreState:render()
  love.graphics.setFont(cheriFont3)
  love.graphics.printf('Wow! You lost!', 0, 50, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(cheriFont2)
  love.graphics.printf('Score: '.. tostring(self.score), 0, 120, VIRTUAL_WIDTH, 'center')
  if self.medal1 then
    love.graphics.draw(medals['medal1'], VIRTUAL_WIDTH / 2 - 16, 160)
  end
  if self.medal2 then
    love.graphics.draw(medals['medal2'], VIRTUAL_WIDTH / 2 - 56, 160)
  end
  if self.medal3 then
    love.graphics.draw(medals['medal3'], VIRTUAL_WIDTH / 2 + 24, 160)
  end
  love.graphics.printf('Press Enter to Play Again', 0, 200, VIRTUAL_WIDTH, 'center')
end
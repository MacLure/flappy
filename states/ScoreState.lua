ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end 
end

function ScoreState:render()
love.graphics.setFont(cheriFont3)
love.graphics.printf('Wow! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
love.graphics.setFont(cheriFont2)
love.graphics.printf('Score: '.. tostring(self.score), 0, 140, VIRTUAL_WIDTH, 'center')
love.graphics.printf('Press Enter to Play Again', 0, 200, VIRTUAL_WIDTH, 'center')
end
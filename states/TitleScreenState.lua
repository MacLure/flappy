TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(cheriFont3)
  love.graphics.printf('Bird that Flaps', 0, 64, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(cheriFont2)
  love.graphics.printf('Press Enter', 0, 150, VIRTUAL_WIDTH, 'center')
end

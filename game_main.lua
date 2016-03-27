local game = {}

function game.reloaded()
  print("Reloaded game_main.lua")
end

function game.update(dt, state)
  if love.keyboard.isDown("left") then
    state.player_x = state.player_x - 1
  elseif love.keyboard.isDown("right") then
    state.player_x  = state.player_x + 1
  end
end

function game.draw(state)
  love.graphics.rectangle("fill", state.player_x, 10, 100, 100)
end

return game

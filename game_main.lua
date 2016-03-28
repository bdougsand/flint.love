local game = {}

local entity = require("src/entity")

function game.reloaded()
  print("Reloaded game_main.lua")
end

function game.update(dt, state)
  local x = 0
  local y = 0
  local mod = 1
  if love.keyboard.isDown("left") then
    x = -1
  elseif love.keyboard.isDown("right") then
    x = 1
  end

  if love.keyboard.isDown("up") then
    y = -1
  elseif love.keyboard.isDown("down") then
    y = 1
  end

  if love.keyboard.isDown("lshift") then
    mod = 2
  end

  entity.move(state.player, mod*x, mod*y)
end

function game.draw(state)
  entity.draw(state.player)
  --love.graphics.rectangle("fill", state.player.x, 10, 100, 100)
end

return game

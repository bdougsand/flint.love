local game = {}

local entity = require("src/entity")

function game.reloaded()
  print("Reloaded game_main.lua")
end

function game.update(dt, state)
end

function game.update_input(state)
  for k, v in pairs(state.input) do
    state.input[k] = v + 1
  end
end

function game.update_entities(dt, state)
  local tick_rate = state.tick_rate or 1
  state.tick = state.tick + tick_rate
  for i, entity in ipairs(state.entities) do
    -- Maybe I'll use this?
    entity.tick = entity.tick + ((entity.tick_rate or 1) * tick_rate)

    -- Run behaviors on all entities:
    for j, behave in ipairs(entity.behaviors) do
      behave(entity, state.tick, dt)
      -- TODO: Prioritizing behaviors?
    end
  end
end

function game.draw(state)
  entity.draw(state.player)
  love.graphics.print("Hello, world")
end

function game.keypressed(state, code)
  state.input[code] = 0
end

function game.keyreleased(state, code)
  state.input[code] = nil
end

return game

local game_state = require("game_state")
local game = require("game_main")

local autoload = true
local check_file_countdown = 60
local last_load_time = os.time()

function love.update(dt)
  if autoload then
    if check_file_countdown == 0 then
      modtime, err = love.filesystem.getLastModified("game_main.lua")
      if modtime > last_load_time then
        print("Reloading game_main.lua")
        game_chunk, err = loadfile("game_main.lua")

        if game_chunk then
          game = game_chunk()
          game.reloaded()
        else
          print("Encountered an error while loading game_main.lua:")
          print(err)
        end

        last_load_time = modtime
      end
      check_file_countdown = 60
    else
      check_file_countdown = check_file_countdown - 1
    end
  end

  game.update(dt, game_state)
end

function love.draw()
  game.draw(game_state)
  love.graphics.print("Hello, world")
end

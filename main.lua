local filesys = require("src/filesys")

function load_file_modifications(since, dir)
  local loaded = false

  for filepath in filesys.dir_modifications(since, dir) do
    if filepath:match(".lua$") then
      local module_name = string.gsub(filepath, ".lua$", "")
      loaded = true

      local mod, err = filesys.checked_load(filepath)
      if mod then
        local old_mod = package.loaded[module_name]
        if old_mod then
          for k, v in pairs(mod) do
            local old_v = old_mod[k]
            if old_v and string.dump(v) ~= string.dump(old_v) then
              print("Loading", module_name, k)
              old_mod[k] = v
            end
          end
        else
          print("Loaded new file:", filepath)
          package.loaded[module_name] = mod
        end
      else
        print("Error while loading file:", filepath)
        print(err)
      end
    end
  end

  return loaded
end


local autoload = true
local check_file_countdown = 60
local last_load_time = os.time()
local last_src_time = os.time()

local game_state = require("game_state")
local game = require("game_main")

function love.update(dt)
  if autoload then
    if check_file_countdown == 0 then
      if load_file_modifications(last_src_time, "src", true) then
        last_src_time = os.time()
      end

      modtime, err = love.filesystem.getLastModified("game_main.lua")
      if modtime > last_load_time then
        print("Reloading game_main.lua")
        local maybe_game, err = filesys.checked_load("game_main.lua")

        if maybe_game then
            game = maybe_game
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
end

function love.keypressed(key, scancode, isRepeat)
  if not isRepeat then
    game.keypressed(game_state, scancode)
  end
end

function love.keyreleased(key, scancode)
  game.keyreleased(game_state, scancode)
end

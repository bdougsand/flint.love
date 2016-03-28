local game_state = require("game_state")
local game = require("game_main")


function dir_modifications(since, dir)
  local items = love.filesystem.getDirectoryItems(dir)
  local i = 0
  local n = #items

  return function()
    while i < n do
      i = i+1
      local filename = items[i]
      local filepath = dir .. "/" .. filename
      local mod = love.filesystem.getLastModified(filepath)

      if mod and mod > since then
        return filepath
      end
    end

    return nil
  end
end


function checked_load(filepath)
  local mod_chunk, err = loadfile(filepath)
  if mod_chunk then
    local succ, maybe_mod = pcall(mod_chunk)
    if succ then
      return maybe_mod, nil
    end
    err = maybe_mod
  end
  return nil, err
end


function load_file_modifications(since, dir)
  local loaded = false

  for filepath in dir_modifications(since, dir) do
    print(filepath, "modified")
    if filepath:match(".lua$") then
      local module_name = string.gsub(filepath, ".lua$", "")
      loaded = true

      local mod, err = checked_load(filepath)
      if mod then
        local old_mod = package.loaded[module_name]
        if old_mod then
          for k, v in pairs(mod) do
            print("Loading", module_name, k)
            old_mod[k] = v
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

function love.update(dt)
  if autoload then
    if check_file_countdown == 0 then
      if load_file_modifications(last_src_time, "src") then
        last_src_time = os.time()
      end

      modtime, err = love.filesystem.getLastModified("game_main.lua")
      if modtime > last_load_time then
        print("Reloading game_main.lua")
        local maybe_game, err = checked_load("game_main.lua")

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
  love.graphics.print("Hello, world")
end

local world = {}

local utils = require("src/utils")


local abbrev_map = {
  x = nil,
  O = {color="white"}
}

local abbrev = utils.getter(abbrev_map)

function world.quick_map_line(line)
  return utils.map(abbrev, line)
end


function world.quick_map(lines)
  return utils.map(world.quick_map_line, utils.line_iter)
end


world.rooms = {
  start = {
    map = world.quick_map(
      [[xxOOxx
        xOOOxx
        xOOOOO
        xOOOOO]])
  }
}

return world

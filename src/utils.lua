local utils = {}

function utils.map(fn, iter)
  local out = {}

  for val in iter do
    table.insert(out, fn(val))
  end

  return out
end


function utils.map_replace(fn, coll)
  for i = 1, #coll do
    coll[i] = fn(coll[i])
  end
  return coll
end



function utils.keep(fn, iter)
  local out = {}

  for val in iter do
    local new_val = fn(val)
    if new_val then
      table.insert(out, new_val)
    end
  end

  return out
end


function utils.getter(m)
  return function(k)
    return m[k]
  end
end


function str_iter(s)
  return string.gmatch(s, "[^%s]")
end


function line_iter(s)
  return string.gmatch(s, "(.*)\n")
end


return utils

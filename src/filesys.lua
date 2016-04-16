local filesys = {}

-- Returns an iterator of files modified since the given timestamp
function filesys.dir_modifications(since, dir, recurse)
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
        if love.filesystem.isDirectory(filepath) and recurse then
          for subpath in filesys.dir_modifications(since,
                                                   filepath,
                                                   recurse) do
            return subpath
          end
        else
          return filepath
        end
      end
    end

    return nil
  end
end


-- Attempts to load and execute the file at filepath
function filesys.checked_load(filepath)
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


return filesys

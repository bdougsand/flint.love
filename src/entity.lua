local entity = {}

function entity.draw(entity)
  if entity.color then
    local c = entity.color
    love.graphics.setColor(c[1], c[2], c[3], c[4])
  end
  love.graphics.rectangle("fill",
                          entity.x, entity.y,
                          entity.width, entity.height)
end

function entity.move(entity, x, y)
  if x then
    entity.x = entity.x + x
  end
  if y then
    entity.y = entity.y + y
  end
end

return entity

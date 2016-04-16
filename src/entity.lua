local entity = {}

function entity.draw(entity)
  if entity.color then
    local c = entity.color
    love.graphics.setColor(c[1], c[2], c[3], c[4])
  end
  love.graphics.push()
  love.graphics.translate(entity.x, entity.y)
  love.graphics.rectangle("fill", 0, 0,
                          entity.width, entity.height)
  love.graphics.pop()
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

world_object = {}

--defines prisoner types.
prisoners = {'brute', 'swift', 'heavy'}

-- defines all world object types and creates their functions there.
-- This is another example of an object structure.
world_object.types = {}
world_object.types['prisoner_unlocked'] = {
  image = love.graphics.newImage('/assets/prisoner_unlocked.png'),
  func = function(x, y, wo, i)
    hero.new(x, y, prisoners[math.random(#prisoners)])
    game.say("You unshackle the prisoner")
    return true
  end,
}
world_object.types['prisoner_locked'] = {
  image = love.graphics.newImage('/assets/prisoner_locked.png'),
  func = function(x, y, wo, i)
    for l = 1, #hero[i].items do
      if hero[i].items[l].name == 'key' then
        hero.new(x, y, prisoners[math.random(#prisoners)])
        table.remove(hero[i].items, l)
        game.say("You use a key to release the prisoner")
        return true
      end
    end
    game.say("You need a key to release this prisoner")
    return false
  end,
}
world_object.types['gate_locked'] = {
  image = love.graphics.newImage('/assets/gate_locked.png'),
  func = function(x, y, wo, i)
    for l = 1, #hero[i].items do
      if hero[i].items[l].name == 'key' then
        table.remove(hero[i].items, l)
        game.say("Used key to open gate")
        return true
      end
    end
    game.say("You need a key to open this gate")
    return false
  end,
}

world_object.types['next_level'] = {
  image = love.graphics.newImage('/assets/hole-ladder.png'),
  func = function(x, y, wo, i)
    for l = 1, #hero[i].items do
      if hero[i].items[l].name == 'key' then
        game.next_level()
        table.remove(hero[i].items, l)
        game.say("You tumble further down the rabbit hole.")
        return true
      end
    end
    game.say("You need a key to descend further.")
    return false
  end,
}

--Spawns all the world objects basically a repeat of the loot spawn thing exception-reporting
-- with specific items and amounts
function world_object.init()

  iter = 0
  while iter < 2 do
    x = love.math.random(1, settings.map.width)
    y = love.math.random(1, settings.map.height)
    if map[x][y] == 'floor' and not world_object.atpos(x, y) then
      world_object.new(x, y, 'next_level')
      iter = iter + 1
    end
  end

  iter = 0
  while iter < 1 do
    x = love.math.random(1, settings.map.width)
    y = love.math.random(1, settings.map.height)
    if map[x][y] == 'floor' and not world_object.atpos(x, y) then
      world_object.new(x, y, 'prisoner_unlocked')
      iter = iter + 1
    end
  end

  iter = 0
  while iter < 4 do
    x = love.math.random(1, settings.map.width)
    y = love.math.random(1, settings.map.height)
    if map[x][y] == 'floor' and not world_object.atpos(x, y) then
      world_object.new(x, y, 'prisoner_locked')
      iter = iter + 1
    end
  end

  iter = 0
  while iter < 12 do
    x = love.math.random(1, settings.map.width)
    y = love.math.random(1, settings.map.height)
    if map[x][y] == 'floor' and not world_object.atpos(x, y) then
      if (map[x + 1][y] == 'wall' and map[x - 1][y] == 'wall') or (map[x][y + 1] == 'wall' and map[x][y - 1] == 'wall')then
        world_object.new(x, y, 'gate_locked')
        --print(x..', '..y)
        iter = iter + 1
      end
    end
  end

end
-- iterates and returns a world object at x, y or false
function world_object.atpos(x, y)
  for i = 1, #world_object do
    if world_object[i].x == x and world_object[i].y == y then
      return i
    end
  end
  return false
end
-- calls the wo world object's function with argument i
function world_object.interact(wo, i)
  r = world_object[wo].func(world_object[wo].x, world_object[wo].y, wo, i)
  if r then
    table.remove(world_object, wo)
  end
end
-- creates a new world_object t at coords x, y
function world_object.new(x, y, t)
  --print('world_object: '..t)
  table.insert(world_object, {
		name = world_object.types[t].name,
		x = x,
		y = y,
		typ = t,
		img = world_object.types[t].image,
		func = world_object.types[t].func,
	})
end
-- iterates and draws
function world_object.drawAll()
	for i = 1, #world_object do
		world_object.draw(i)
	end
end
-- draws the image of each world object after calulating luminance
function world_object.draw(i)
  --print(world_object[i].x..', '..world_object[i].y)
	luminance = util.calc_lum(world_object[i].x, world_object[i].y)
	love.graphics.setColor(255 * luminance, 255 * luminance, 255 * luminance)
	love.graphics.draw(world_object[i].img, world_object[i].x * settings.render.tile_size, world_object[i].y * settings.render.tile_size, nil, settings.render.tile_size/128)
end

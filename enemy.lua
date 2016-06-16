enemy = {}
--[[
You ready for this 200 line *masterpiece*?
I'm not.
]]

--To begin with we define classes, which is a list of... you guessed it, classes
enemy.classes = {}
-- same thing here except special refers to special attacks
enemy.classes.special = {}
--the default do nothing special
 enemy.classes.special['nothing'] = function (e, h, v)
end
--this special poisons the attacked player, adding that status effect
enemy.classes.special['poison'] = function (e, h, v)
	game.say("The "..enemy[e].name.." poisons you")
	hero.status.add(h, 'poisoned', v)
end
--this special breaks the attacked player's sheild, turning it into a broken shield
enemy.classes.special['break'] = function (e, h, v)
	if hero[h].armour then
		game.say("The "..enemy[e].name.." damages your shield")
		hero[h].maxhealth = hero[h].maxhealth - hero[h].armour.funcValue

		hero[h].armour.name = "broken shield"
		hero[h].armour.flavor = "A broken shield. It looks as though it could fall apart at any moment."
		hero[h].armour.funcValue = "5"

		hero[h].maxhealth = hero[h].maxhealth + hero[h].armour.funcValue
		hero[h].health = math.min(hero[h].health, hero[h].maxhealth)
	end
end
--Here we define some classes. I had to do this below the special definitions because
-- they store these in their special attack thingy. Or at least they did at one point.
--These values are manually set so they're pretty self explanatory.
enemy.classes['neath dweller'] = {
	name = 'neath dweller',
	attack = 10,
	maxhealth = 20,
	speed = 10,
	special_attack = 'nothing',
	special_attack_value = 0,
}

enemy.classes['giant spider'] = {
	name = 'giant spider',
	attack = 15,
	maxhealth = 10,
	speed = 7,
	special_attack = 'poison',
	special_attack_value = 5,
}

enemy.classes['golem'] = {
	name = 'golem',
	attack = 30,
	maxhealth = 100,
	speed = 2,
	special_attack = 'nothing',
	special_attack_value = 0,
}
enemy.classes['imp'] = {
	name = 'imp',
	attack = 5,
	maxhealth = 13,
	speed = 17,
	special_attack = 'break',
	special_attack_value = 0,
}

--This creates a new enemy at x, y of type t
function enemy.new(x, y, t)
	i = #enemy + 1
  --manually set values, some from class definitions, some from parameters.
	enemy[i] = {
		x = x,
		y = y,
		rx = x,
		ry = y,
		class = t,
		name = enemy.classes[t].name,
		attack = enemy.classes[t].attack,
		health = enemy.classes[t].maxhealth,
		maxhealth = enemy.classes[t].maxhealth,
		speed = enemy.classes[t].speed,
		special_attack = enemy.classes[t].special_attack,
		special_attack_value = enemy.classes[t].special_attack_value,
		path = {},
	}
end
--This animates the enemy to move along a path.
-- NB: this needs to be fixed. It works, but I don't like it. See hero.move_path
function enemy.move_path(i, dt)
	if #enemy[i].path > 0 then
		if not enemy[i].time then
			enemy[i].time = 0
		elseif enemy[i].time == 1 then
			enemy[i].time = 0
			if #enemy[i].path < 2 then
				enemy[i].rx = enemy[i].path[2].x
				enemy[i].ry = enemy[i].path[2].y
			end
			table.remove(enemy[i].path, 1)
		else
			if #enemy[i].path > 1 then
				enemy[i].time = enemy[i].time + dt * settings.render.animate_speed
				enemy[i].time = util.clamp(enemy[i].time, 0, 1)
				enemy[i].rx = util.lerp(enemy[i].path[1].x, enemy[i].path[2].x, enemy[i].time)
				enemy[i].ry = util.lerp(enemy[i].path[1].y, enemy[i].path[2].y, enemy[i].time)
			end
		end
	end
end
--goes through each enemy and calls turn on them
function enemy.turnAll()
	for i = 1, #enemy do
		enemy.turn(i)
	end
end
--[[
This is the enemy's logic.
First It finds the nearest hero and checks if they're adjacent. There's some cool
maths to do this but I literally couldn't be bothered changing it to the math and These
if statements work find, even if this could be acheived in one line.
After that if it's not adjacent it double checks if x and y exist because edge cases
Then it figues out if the hero is within 10 tiles using manhattan distance (see util)
If it is then it calulates a path and removes the first node because that is the hero's
position (the way pathfinding works it returns the target pos which is the hero)
It then clips the path by removing the first value until the path is 4 or less long.
NB: Link the speed there.
It then inserts the raw path into the enemy's path, using a reverse for loop.
LEARNIN TIME: see that for loop? n = #node.path, 1, -1? The n is the variable and that
equals is the assigner. The other stuff is less obvious. The first value is the ORIGIN
value, which N starts at, the second is the TARGET value, which it ends at, and the
-1 is the INCREMENTOR, which is automatically 1 if it isn't present. By starting at the
end we can reverse the list.
After the enemy has the path we set the x and y to the last tile in it's path (not the
render just the logic [see hero.move_path for clarification on that])
]]
function enemy.turn(i)
	x, y = enemy.closestHero(i)
	u = hero.atpos(enemy[i].x, enemy[i].y - 1)
	d = hero.atpos(enemy[i].x, enemy[i].y + 1)
	l = hero.atpos(enemy[i].x - 1, enemy[i].y)
	r = hero.atpos(enemy[i].x + 1, enemy[i].y)
	if u or d or l or r then

		if u then
			enemy.attack(i, u)
		elseif d then
			enemy.attack(i, d)
		elseif l then
			enemy.attack(i, l)
		elseif r then
			enemy.attack(i, r)
		end
	else
		if x and y then
			if util.manhattan(x, y, enemy[i].x, enemy[i].y) < 10 then
				pathfind.calculate(enemy[i].x, enemy[i].y, x, y, 5, false)
				table.remove(node.path, 1)
				while #node.path >= 5 do
					table.remove(node.path, 1)
				end
				for n = #node.path, 1, -1 do
					table.insert(enemy[i].path, node.path[n])
				end

				if node.path[1] then
					enemy[i].x = node.path[1].x
					enemy[i].y = node.path[1].y
				end

			end
		end
	end
end
-- This is called when the enemy attacks. it decreases the health and runs the
-- special function of the enemy. If the hero dies it moves the enemy to the hero's
-- tile
function enemy.attack(e, h)
	game.say("Enemy attacked dealing "..enemy[e].attack.." damage")
	hero[h].health = math.max(0, hero[h].health - enemy[e].attack)
 	enemy.classes.special[enemy[e].special_attack](e, h, enemy[e].special_attack_value)
	if hero[h].health == 0 then
    table.insert(enemy[e].path, {x = hero[h].x, y = hero[h].y})
		enemy[e].x = hero[h].x
		enemy[e].y = hero[h].y
		hero.kill(h)
	end
end
-- Simple function. Checks if the enemy or hero is selected, if so deselects them
-- and sets selected to i (the enemy that was clicked on)
-- changes that enemy's selected variable for rendering reasons
function enemy.select(i)
	if enemy.selected then
		enemy[enemy.selected].selected = nil
	end
	if hero.selected then
		hero[hero.selected].selected = nil
		hero.selected = nil
	end
	enemy.selected = i
	enemy[i].selected = true
end

-- Goes through each enemy and iterations the amount of that enemy type, picking
-- a random value and placing an enemy there if it's a floor and there's not already
-- an enemy or a world object there.
function enemy.makeabunchofenemies()
	for t = 1, #settings.balance.enemy do
		for i = 1, settings.balance.enemy[t].amount do
			x = love.math.random(1, settings.map.width)
			y = love.math.random(1, settings.map.height)
			if map[x][y] == 'floor' then
				if not enemy.atpos(x, y) and not world_object.atpos(x, y) then
					enemy.new(x, y, settings.balance.enemy[t].name)
				end
			end
		end
	end
end
--finds the closes hero using manhattan distance.
function enemy.closestHero(i)
	for h = 1, #hero do
		if d then
			if util.manhattan(enemy[i].x, enemy[i].y, hero[h].x, hero[h].y) < d then
				d = util.manhattan(enemy[i].x, enemy[i].y, hero[h].x, hero[h].y)
				x = hero[h].x
				y = hero[h].y
			end
		else
			d = util.manhattan(enemy[i].x, enemy[i].y, hero[h].x, hero[h].y)
			x = hero[h].x
			y = hero[h].y
		end
	end
	if d then
		return x, y
	else
		return false, false
	end
end
-- checks through the enemy table for an enemy and returns the enemy index if one exists
-- at the given coordinate
function enemy.atpos(x, y)
	for i = 1, #enemy do
		if enemy[i].x == x and enemy[i].y == y then
			return i
		end
	end
	return false
end
-- iterates and draws
function enemy.drawAll()
	love.graphics.setColor(255, 0, 255)
	for i = 1, #enemy do
		enemy.draw(i)
	end
end
-- calculates luminance and then draws teh enemy to the screen.
function enemy.draw(i)
	luminance = util.calc_lum(enemy[i].rx, enemy[i].ry)
	love.graphics.setColor(255 * luminance	, 0, 0)
	w = enemy[i].health / enemy[i].maxhealth
	w = w * 2 * math.pi
	love.graphics.arc("fill", (enemy[i].rx + 0.5) * settings.render.tile_size, (enemy[i].ry + 0.5) * settings.render.tile_size, settings.render.tile_size/2, 0 - math.pi/2, w - math.pi/2, 24)


	love.graphics.setColor(255 * luminance, 255 * luminance, 255 * luminance)
	if enemy[i].selected then
		--love.graphics.setColor(255 * luminance,255 * luminance,255 * luminance)
		--love.graphics.rectangle("line", enemy[i].x * settings.render.tile_size, enemy[i].y * settings.render.tile_size, settings.render.tile_size, settings.render.tile_size)
		love.graphics.setColor(255 * luminance, 120 * luminance, 120 * luminance)
	end
	--love.graphics.setColor(180, 0, 50)
	--love.graphics.rectangle("fill", enemy[i].x * settings.render.tile_size + 2, enemy[i].y * settings.render.tile_size + 2, settings.render.tile_size - 4, settings.render.tile_size - 4)
	love.graphics.draw(images.enemies[enemy[i].name], enemy[i].rx * settings.render.tile_size + 5, enemy[i].ry * settings.render.tile_size + 5, nil, (settings.render.tile_size - 10)/256)



end
-- empty. The stuff in comments is a debug thing that I had in version 0.0000000000001
function enemy.drawUI(i, p)
  --[[
	uiheight = 70
	love.graphics.setColor(20, 20, 20)
	love.graphics.rectangle("fill", p * 200 - 200, settings.window.height - uiheight, 200, uiheight)
	love.graphics.setColor(180, 100, 100)
	love.graphics.print(
		'Class: '..enemy[i].class..
		'\nHealth: '..enemy[i].health..'/'..enemy[i].maxhealth..
		'\nPosition: '..enemy[i].x..', '..enemy[i].y
		, 10 + p * 200 - 200, settings.window.height - uiheight + 10)
    ]]
end
-- checks if an enemy is at the position and if so selects the enemy.
function enemy.mousepressed(x, y, button, istouch)
	if button == 1 then
		ix, iy = util.pointtogrid(x, y)
		i = enemy.atpos(ix, iy)
		if i then
			enemy.select(i)
		end
	end
end

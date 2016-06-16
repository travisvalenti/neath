hero = {}
hero.selected = nil
-- Defines all the hero classes. They're not actually named in game so name doesn't
-- really matter.
--Each hero has speed, attack, max health, max actions and an image.
hero.classes = {}
hero.classes['hero'] = {
	speed = 10,
	attack = 10,
	maxhealth = 50,
	maxactions = 2,
	img = love.graphics.newImage('/assets/hero.png')
}
hero.classes['brute'] = {
	speed = 8,
	attack = 15,
	maxhealth = 60,
	maxactions = 2,
	img = love.graphics.newImage('/assets/brute.png')

}
hero.classes['swift'] = {
	speed = 7,
	attack = 8,
	maxhealth = 50,
	maxactions = 3,
	img = love.graphics.newImage('/assets/swift.png')

}
hero.classes['heavy'] = {
	speed = 6,
	attack = 25,
	maxhealth = 80,
	maxactions = 2,
	img = love.graphics.newImage('/assets/heavy.png')

}
--Creats a new hero at x,y of type c
function hero.new(ix, iy, c)
	table.insert(hero, {x = ix, y = iy, class = c, items = {}, rx = ix, ry = iy})
	if not hero[#hero].class then
		hero[#hero].class = 'hero'
		c = 'hero'
	end
	hero[#hero].health = hero.classes[c].maxhealth
	hero[#hero].maxhealth = hero.classes[c].maxhealth
	hero[#hero].attack = hero.classes[c].attack
	hero[#hero].speed = hero.classes[c].speed
	hero[#hero].maxactions = hero.classes[c].maxactions
	hero[#hero].actions = hero.classes[c].maxactions
	hero[#hero].vision = 25
	hero[#hero].status = {}
	hero[#hero].path = {}
	hero[#hero].capacity = 16
end

inventory = {}
inventory.x = 300
inventory.y = 225
inventory.w = 200

inventory.sword = {
	x = 300,
	y = 95,
}

inventory.armour = {
	x = 300,
	y = 150,
}
-- finds the manhattan distance closest hero
function hero.closest(x, y)
	for i = 1, #hero do
		d = util.manhattan(x, y, hero[i].x, hero[i].y)
		if max then
			if d < max then
				max = d
				c = i
			end
		else
			max = d
			c = i
		end
	end
	if c then return c end
end
-- iterates and calls turn()
function hero.turnAll()
	for i = 1, #hero do
		hero.turn(i)
	end
end
-- reset actions and apply status effects and end effects.
function hero.turn(i)
	hero[i].actions = hero[i].maxactions
	remove = {}
	for s = 1, #hero[i].status do
		if hero[i] then
			if hero[i].status[s] then
				hero[i].status[s].time = hero[i].status[s].time - 1
				if hero[i].status[s].time == 0 then
					if hero.status.endeffect[hero[i].status[s].name] then
						hero.status.endeffect[hero[i].status[s].name](i)
					end
					table.remove(hero[i].status, s)
				else
					if hero.status.effect[hero[i].status[s].name] then
						hero.status.effect[hero[i].status[s].name](i)
					end
				end
			end
		end
	end
end
-- heals the i hero by v Can be negative health to damage. If health == 0 then kill
-- Health can't be below 0 because of the clamp so that logic is fine.
function hero.heal(i, v)
	hero[i].health = hero[i].health + v
	hero[i].health = math.min(hero[i].health, hero[i].maxhealth)
	hero[i].health = math.max(0, hero[i].health)
	if hero[i].health == 0 then
		hero.kill(i)
	end
end

--kills the hero. Removes it from the table and deselects it.
function hero.kill(h)
	table.remove(hero, h)
	if hero.selected == h then
		hero.selected = nil
	end
end
-- selects the hero at x, y
function hero.getselect(x, y)
	for i = 1, #hero do
		if hero[i].x == x and hero[i].y == y then
			hero.select(i)
			break
		end
	end
end
-- selects a hero by index
-- deslects any other selected thing.
function hero.select(i)
	if hero.selected then

		if hero.selected == i then
			hero.selected = nil
			hero[i].selected = nil
					game.say("You deselected that thing")
		else
			hero[hero.selected].selected = nil
			hero.selected = i
			hero[i].selected = true
		end

	else
		if enemy.selected then
			enemy[enemy.selected].selected = nil
			enemy.selected = nil
		end
		hero.selected = i
		hero[i].selected = true
	end
end
-- moves the hero. Yeah, seems too complicated for moving aye? I'll break it down
-- Finds the grid point of the x, y coords
-- Checks if a path exists, then checks if there arte enough actions
-- unfortifies if needed.
-- sets the logic location to the end of the path.
-- takes an action
-- adds the reversed path to the hero's animation path
-- sets the final location to grab if there's a loot there
-- checks if there's a world object at the gridpos and if there is it uses it.
-- at the end tells the user if they're out of actions.
function hero.move(i, x, y)
	ix, iy = util.pointtogrid(x, y)
	if path then
		if hero[i].actions > 0 then
			if hero[i].fortified then
				hero[i].fortified = false
				game.say("No longer fortified")
				hero.status.unfortify(i)
			end
			hero[i].x = node.path[1].x
			hero[i].y = node.path[1].y
			hero[i].actions = hero[i].actions - 1
			for n = #node.path, 1, -1  do
				table.insert(hero[i].path, {x = node.path[n].x, y = node.path[n].y, grab = false})
			end
			if hero[i].path[#hero[i].path] then
				hero[i].path[#hero[i].path].grab = loot.at(hero[i].path[#hero[i].path].x, hero[i].path[#hero[i].path].y)
			end

			wo = world_object.atpos(ix, iy)
			if wo then
				world_object.interact(wo, i)
			end
			--hero[i].selected = nil
			--hero.selected = nil
			if hero[i].actions == 0 then
				game.say("You're out of actions")
			end
		else
			game.say("You can't move, you're out of actions")
		end
	end
end
-- drops an item. adds it to the loot list.
function hero.drop(h, i)
	loot.new(hero[h].x, hero[h].y, hero[h].items[i].name)
	table.remove(hero[h].items, i)
end
-- just another good ol draw.
-- iterates through the possible locations and uses a fancy formula I made up to figure out
-- which item to render
--[[
LEARNIN TIME:
the grid render goes from 1 to 4 in x and from 1 to capacity/4 in y. That means an x by y gridpos
the formula [x + (y - 1) * 4] for the index means that it will be index 1 when x is
1 and y is 1, then 2 when x is 2 and y is 1 and so on.
Then when y is 2 and x is 1, it will be 5, and iterate like that. This way
it reverse engineers the index based on location, isntead of location based
on index. I did it this way to avoid extra loops and also cause it's easier to
get 1 variable from 2 than 2 variables from one
]]
function hero.drawInventory(h)
	if hero[h] then
	love.graphics.setColor(150, 150, 150)
	--love.graphics.rectangle("fill", 100, 100, 50, 50)
	--love.graphics.rectangle("fill", 100, 160, 50, 50)

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', love.graphics.getWidth() - inventory.sword.x, inventory.sword.y, 50, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('line', love.graphics.getWidth() - inventory.sword.x, inventory.sword.y, 50,50)
	if hero[h].sword then
		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].sword.name, love.graphics.getWidth() - inventory.sword.x + 60, inventory.sword.y + 10)
		love.graphics.print("+"..hero[h].sword.funcValue.." attack", love.graphics.getWidth() - inventory.sword.x + 60, inventory.sword.y + 30)
		love.graphics.draw(hero[h].sword.image, love.graphics.getWidth() - inventory.sword.x, inventory.sword.y, nil, 100/256)
	else
		love.graphics.print('No Weapon', love.graphics.getWidth() - inventory.sword.x + 60, inventory.sword.y + 10)
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', love.graphics.getWidth() - inventory.armour.x, inventory.armour.y, 50, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('line', love.graphics.getWidth() - inventory.armour.x, inventory.armour.y, 50,50)
	if hero[h].armour then
		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].armour.name, love.graphics.getWidth() - inventory.armour.x + 60, inventory.armour.y + 10)
		love.graphics.print("+"..hero[h].armour.funcValue.." max health", love.graphics.getWidth() - inventory.armour.x + 60, inventory.armour.y + 30)
		love.graphics.draw(hero[h].armour.image, love.graphics.getWidth() - inventory.armour.x, inventory.armour.y, nil, 50/128)

	else
		love.graphics.print('No Armour', love.graphics.getWidth() - inventory.armour.x + 60, inventory.armour.y + 10)
	end

	for x = 1, 4 do
		for y = 1, hero[h].capacity / 4 do
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill", love.graphics.getWidth() - inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, 50, 50)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", love.graphics.getWidth() - inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, 50, 50)
			if hero[h].items[x + (y - 1) * 4] then
				love.graphics.draw(hero[h].items[x + (y - 1) * 4].image, love.graphics.getWidth() - inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, nil, 50/128)
			end
		end
	end
end

	--this is the old list render, which I'm keeping in for nostalgia reasons :p
	--[[
	o = 0

	love.graphics.setColor(0, 0, 0, 50)
	love.graphics.rectangle("fill", inventory.x, inventory.y, inventory.w, 20)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", inventory.x, inventory.y, inventory.w, 20)
	love.graphics.print("Inventory", inventory.x + 10, inventory.y + 5)

	if #hero[h].items == 0 then
		love.graphics.setColor(0, 0, 0, 50)
		love.graphics.rectangle("fill", inventory.x, inventory.y + 20, inventory.w, 20)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line", inventory.x, inventory.y + 20, inventory.w, 20)
		love.graphics.print("Empty  :(", inventory.x + 10, inventory.y + 25)
	end

	for i = 1, #hero[h].items do
		love.graphics.setColor(0, 0, 0, 50)
		love.graphics.rectangle("fill", inventory.x, i * 20 + inventory.y, inventory.w, 20)

		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].items[i].typ, inventory.x + 10, i * 20 + inventory.y + 5)
		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].items[i].value, inventory.x + 160, i * 20 + inventory.y + 5)

		o = i
	end
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", inventory.x, inventory.y + 20, inventory.w, 20 * o)
	]]
end
-- iterates and draws
function hero.drawAll()
	for i = 1, #hero do
		hero.draw(i)
	end
end
-- Draws all the hero images and adds their status effects on top.
-- Also draw's their render path.
-- oh, i forgot. It calculates luminosity first.
function hero.draw(i)
	love.graphics.setColor(255, 255, 255)
	if hero[i].selected then
		x, y = util.mousetogrid()
		enemy_atpos = enemy.atpos(x, y)
		if enemy_atpos then
			if 		(math.abs(x - hero[hero.selected].x) == 1 and y == hero[hero.selected].y)
				or	(math.abs(y - hero[hero.selected].y) == 1 and x == hero[hero.selected].x) then
				love.graphics.setColor(200, 20, 20)
				love.graphics.draw(images.attack_hover, x * settings.render.tile_size, y * settings.render.tile_size, nil, 200/256)
			end
		end
		world_object_atpos = world_object.atpos(x, y)
		if world_object_atpos then
			if 		(math.abs(x - hero[hero.selected].x) == 1 and y == hero[hero.selected].y)
				or	(math.abs(y - hero[hero.selected].y) == 1 and x == hero[hero.selected].x) then
				love.graphics.setColor(20, 20, 200)
				love.graphics.draw(images.use_hover, x * settings.render.tile_size, y * settings.render.tile_size, nil, 200/256)
			end
		end
		at = loot.at(x, y)
		if at and not enemy_atpos then
			l = util.calc_lum(x, y)
			love.graphics.setColor(200 * l, 200 * l, 0)
			--love.graphics.setColor(255 * l, 255 * l, 255 * l)
			--love.graphics.draw(images.hand, x * settings.render.tile_size + 50, y * settings.render.tile_size + 50, nil, 100/256)
		end
	if #hero[i].path > 1 then
		love.graphics.setColor(0, 250, 0)
		for p = 2, #hero[i].path - 1 do
			love.graphics.line((hero[i].path[p].x + 0.5) * settings.render.tile_size, (hero[i].path[p].y + 0.5) * settings.render.tile_size, (hero[i].path[p + 1].x + 0.5) * settings.render.tile_size, (hero[i].path[p + 1].y + 0.5) * settings.render.tile_size)
		end
		for p = 1, #hero[i].path do
			if hero[i].path[p].grab then
				love.graphics.draw(images.hand, hero[i].path[p].x * settings.render.tile_size + 50, hero[i].path[p].y * settings.render.tile_size + 50, nil, 100/256)
			end
		end
		if loot.at(hero[i].path[#hero[i].path].x, hero[i].path[#hero[i].path].y) then
			love.graphics.draw(images.hand, hero[i].path[#hero[i].path].x * settings.render.tile_size + 50, hero[i].path[#hero[i].path].y * settings.render.tile_size + 50, nil, 100/256)
		else
			love.graphics.draw(images.path_marker, hero[i].path[#hero[i].path].x * settings.render.tile_size + 50, hero[i].path[#hero[i].path].y * settings.render.tile_size + 3, nil, 100/128)
		end
	end


		--love.graphics.setColor(0, 100, 255)
		--love.graphics.rectangle("fill", hero[i].rx * settings.render.tile_size - 2, hero[i].ry * settings.render.tile_size - 2, settings.render.tile_size + 4, settings.render.tile_size + 4)
		love.graphics.setColor(120, 120, 255)
	end

	--love.graphics.setColor(0, 0, 200)
	--love.graphics.rectangle("fill", hero[i].x * settings.render.tile_size + 2, hero[i].y * settings.render.tile_size + 2, settings.render.tile_size - 4, settings.render.tile_size - 4)
	love.graphics.draw(hero.classes[hero[i].class].img, hero[i].rx * settings.render.tile_size, hero[i].ry * settings.render.tile_size, nil, settings.render.tile_size/512)
	love.graphics.setColor(255, 0, 0)
	health_percentage = hero[i].health/hero[i].maxhealth
	love.graphics.rectangle("fill", hero[i].rx * settings.render.tile_size, (hero[i].ry + 1) * settings.render.tile_size - 7,  health_percentage * settings.render.tile_size, 7)
	love.graphics.setColor(255, 255, 255)
	for s = 1, #hero[i].status do
		love.graphics.draw(images.status[hero[i].status[s].name], hero[i].rx * settings.render.tile_size + (s-1) * 70, hero[i].ry * settings.render.tile_size, nil, 64/64)
	end

	--if hero[i].fortified then
		--love.graphics.draw(images.fortified, hero[i].rx * settings.render.tile_size, hero[i].ry * settings.render.tile_size)
	--end
end
-- iterates through the hero's statuses and returns true if status is found
function hero.has_status(i, status)
	for s = 1, #hero[i].status do
		if hero[i].status[s].name == status then
			return true
		end
	end
	return false
end
--iterates through the hero and returns the index of the hero at x, y or false
function hero.atpos(x, y)
	for i = 1, #hero do
		if hero[i].x == x and hero[i].y == y then
			return i
		end
	end
	return false
end

--here all the status effects are defined, and any turn based effects
hero.status = {}
hero.status.effect = {}
hero.status.effect['fortified'] = function(i)
	hero.heal(i, 5)
	hero[i].status[1].time = 2
end
hero.status.effect['poisoned'] = function(i)
	hero.heal(i, -5)
	game.say("You lose 5 health from being poisoned")
end
hero.status.effect['permeating sight'] = function(i)
end
hero.status.effect['night sight'] = function(i)
end
hero.status.endeffect = {}
hero.status.endeffect['fortified'] = function(i)
end
hero.status.endeffect['poisoned'] = function(i)
end
hero.status.endeffect['permeating sight'] = function(i)
end
hero.status.endeffect['night sight'] = function(i)
end

-- this is all then status flavors. I tried a different object structure this time.
-- It turned out pretty alright I guess
hero.status.flavor = {
	['poisoned'] = {'Poisoned:', 'You take 5hp per turn. Wears off in 3-5 turns.'},
	['permeating sight'] = {'Permeating sight:', 'See what is inside chests before you open them by mousing over them.'},
	['night sight'] = {'Night sight:', 'Have a higher view radius'},
	['fortified'] = {'Fortified:', 'You heal 5hp per turn. You will automatically unfortify if you move or attack.'},
}
-- Draws the statuses in the top right
	function hero.status.draw(i)
		love.graphics.setColor(255, 255, 255)
		for s = 1, #hero[i].status do
			love.graphics.draw(images.status[hero[i].status[s].name], love.graphics.getWidth() - s * 74, 10)
		end
		s = hero.status.over(i)
		if s then
			mouse.drawtooltip(hero.status.flavor[hero[1].status[s].name][1], hero.status.flavor[hero[1].status[s].name][2])
		end
	end
	--checks if the mouse is above a drawn status
function hero.status.over(i)
	x, y = love.mouse.getPosition()
	for s = 1, #hero[i].status do
		if util.inside(x, y, love.graphics.getWidth() - s * 74, 10, 64, 64) then
			return s
		end
	end
	return false
end
--adds a status effect
	function hero.status.add(i, stat, time)
		for s = 1, #hero[i].status do
			if hero[i].status[s].name == stat then
				hero[i].status[s].time = hero[i].status[s].time + hero[i].status[s].time
				hero[i].status[s].total = hero[i].status[s].total + hero[i].status[s].total
				return
			end
		end
		table.insert(hero[i].status, {name = stat, time = time, total = time})
	end
	--removes a status effect
	function hero.status.remove(i, stat)
		for s = 1, #hero[i].status do
			if hero[i].status[s] == stat then
				table.remove(hero[i].status, s)
			end
		end
	end
	--fortify was done like this because it was already linked in in so many places
	--as this so I just did it this way
	function hero.status.fortify(i)
		table.insert(hero[i].status, 1, {name='fortified', time = 2, total = 2})
	end
	--ditto for unfortify
	function hero.status.unfortify(i)
		table.remove(hero[i].status, 1)
	end

-- cycles through the heros. called when the user presses enter
function hero.cycle()
	if hero.selected then
		i = hero.selected
		hero[i].selected = false
		i = i + 1
		if i > #hero then
			i = 1
		end
		hero.selected = i
		hero[i].selected = true
	else
		if hero[1] then
			if enemy.selected then
				enemy[enemy.selected].selected = false
				enemy.selected = false
			end
			hero.selected = 1
			hero[1].selected = true
		end
	end
end
--draws the hero's UI.
function hero.drawUI(i, p)
	if hero[i] then
		ui_size = 80

		love.graphics.setColor(30, 30, 30)
		love.graphics.rectangle('fill', 10, 20, ui_size, ui_size)
		love.graphics.setColor(255, 0, 0)

		h = hero[i].health / hero[i].maxhealth
		h = h * ui_size
		love.graphics.rectangle('fill', 10, 20 + ui_size - h, ui_size, h)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.health, 10, 20, nil, ui_size/128)

		action_size = 40
		for a = 1, hero[i].maxactions do
			x = 50 + (action_size + 10) * a
			y = 20
			if hero[i].actions >= a then
				love.graphics.setColor(0, 100, 200)
			else
				love.graphics.setColor(30, 30, 30)
			end
			love.graphics.rectangle("fill", x, y, action_size, action_size)
			love.graphics.draw(images.time, x, y, nil, action_size/128)
			--debug.debug()
			hero.status.draw(i)
		end
	end
end
-- attacks enemy e with hero i
function hero.attack(i, e)
	if hero[i].actions >= 1 then
		game.say("You attacked")
		if hero[i].fortified then
			hero[i].fortified = false
			game.say("No longer fortified")
			hero.status.unfortify(i)
		end
		enemy[e].health = math.max(0, enemy[e].health - hero[i].attack)
		hero[i].actions = 0
		if enemy[e].health == 0 then
			table.insert(hero[i].path, {x = enemy[e].x, y = enemy[e].y, grab = true})
			hero[i].x = enemy[e].x
			hero[i].y = enemy[e].y
			game.say("Enemy killed")

			table.remove(enemy, e)
		end
		game.say("You're out of actions")
	else
		game.say("You can't attack, you're out of actions")
	end
end
-- animates the hero along the path
--[[
LEARNIN TIME:
the hero has a render pos (rx and ry) as well as a logic pos (x and y). This is
also true for the enemy. Basically for all intensive purposes, the game thinks
the hero is at the logic position, but it is drawn at the render position.
This way it takes up space and can be attacked at the logic position.
I could, in future, make an end turn impossible until the rendered position
catches up with the logic position, but I believe it will slow the pace of the
game down.
]]
function hero.move_path(i, dt)
	if #hero[i].path > 0 then
		if not hero[i].time then
			hero[i].time = 0
		elseif hero[i].time == 1 then
			hero[i].time = 0

			table.remove(hero[i].path, 1)

			if hero[i].path[1].grab then
				l = loot.at(hero[i].path[1].x, hero[i].path[1].y)
				l2 = true
				while l and l2 do
					l2 = loot.pickup(l, i)
					l = loot.at(hero[i].path[1].x, hero[i].path[1].y)
				end
			end
		else
			if #hero[i].path > 1 then
				hero[i].time = hero[i].time + dt * settings.render.animate_speed
				hero[i].time = util.clamp(hero[i].time, 0, 1)
				hero[i].rx = util.lerp(hero[i].path[1].x, hero[i].path[2].x, hero[i].time)
				hero[i].ry = util.lerp(hero[i].path[1].y, hero[i].path[2].y, hero[i].time)
			end
		end
	end
end


--called when the mouse it pressed. Checks if the hero can move, or attack, or
-- be selected or use an item. If so, it does it.
function hero.mousepressed(x, y, button, istouch)
	ix, iy = util.pointtogrid(x, y)
	if button == 1 then
		if hero.selected and showInventory == true then
			i = mouse.overInventoryItem(hero.selected)
			if i then
				hero[hero.selected].items[i].func(hero.selected, i, hero[hero.selected].items[i].funcValue)
			else
				hero.getselect(ix, iy)
			end
		else
			hero.getselect(ix, iy)
		end
	elseif button == 2 then
		if hero.selected then
			i = mouse.overInventoryItem(hero.selected)
			if showInventory == true and i then
				hero.drop(hero.selected, i)
			else
				ix, iy = util.mousetogrid(x, y)
				if ix == hero[hero.selected].x and iy == hero[hero.selected].y then
					l = loot.at(hero[hero.selected].x, hero[hero.selected].y)
					l2 = true
					while l and l2 do
						l2 = loot.pickup(l, hero.selected)
						l = loot.at(hero[hero.selected].x, hero[hero.selected].y)
					end
				end
				e = enemy.atpos(ix, iy)
				if e then
					if 		(math.abs(ix - hero[hero.selected].x) == 1 and iy == hero[hero.selected].y)
						or	(math.abs(iy - hero[hero.selected].y) == 1 and ix == hero[hero.selected].x) then
						hero.attack(hero.selected, e)
					end
				end
				wo = world_object.atpos(ix, iy)
				if wo then
					if 		(math.abs(ix - hero[hero.selected].x) == 1 and iy == hero[hero.selected].y)
						or	(math.abs(iy - hero[hero.selected].y) == 1 and ix == hero[hero.selected].x) then
						world_object.interact(wo, hero.selected)
					end
				end
				hero.move(hero.selected, x, y)
			end
		end
	end
end

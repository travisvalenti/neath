hero = {}
hero.selected = nil

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
inventory.x = 900
inventory.y = 225
inventory.w = 200

inventory.sword = {
	x = 900,
	y = 95,
}

inventory.armour = {
	x = 900,
	y = 150,
}

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

function hero.turnAll()
	for i = 1, #hero do
		hero.turn(i)
	end
end

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

function hero.heal(i, v)
	hero[i].health = hero[i].health + v
	hero[i].health = math.min(hero[i].health, hero[i].maxhealth)
	hero[i].health = math.max(0, hero[i].health)
	if hero[i].health == 0 then
		hero.kill(i)
	end
end

function hero.kill(h)
	table.remove(hero, h)
	if hero.selected == h then
		hero.selected = nil
	end
end

function hero.getselect(x, y)
	for i = 1, #hero do
		if hero[i].x == x and hero[i].y == y then
			hero.select(i)
			break
		end
	end
end

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

	--[[if hero.selected then
		if hero.selected == i then
			hero.selected = nil
			hero[i].selected = nil
			hero[hero.selected].selected = nil
		else
			hero.selected = i
			hero[i].selected = true
			hero[hero.selected].selected = nil
		end

	else
		if enemy.selected then
			enemy[enemy.selected].selected = nil
			enemy.selected = nil
		end
		hero.selected = i
		hero[i].selected = true
	end]]
end

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
			hero[i].path[#hero[i].path].grab = true

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

function hero.drop(h, i)
	loot.new(hero[h].x, hero[h].y, hero[h].items[i].name)
	table.remove(hero[h].items, i)
end

function hero.drawInventory(h)
	if hero[h] then
	love.graphics.setColor(150, 150, 150)
	--love.graphics.rectangle("fill", 100, 100, 50, 50)
	--love.graphics.rectangle("fill", 100, 160, 50, 50)

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', inventory.sword.x, inventory.sword.y, 50, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('line', inventory.sword.x, inventory.sword.y, 50,50)
	if hero[h].sword then
		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].sword.name, inventory.sword.x + 60, inventory.sword.y + 10)
		love.graphics.print("+"..hero[h].sword.funcValue.." attack", inventory.sword.x + 60, inventory.sword.y + 30)
		love.graphics.draw(hero[h].sword.image, inventory.sword.x, inventory.sword.y, nil, 100/256)
	else
		love.graphics.print('No Weapon', inventory.sword.x + 60, inventory.sword.y + 10)
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', inventory.armour.x, inventory.armour.y, 50, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('line', inventory.armour.x, inventory.armour.y, 50,50)
	if hero[h].armour then
		love.graphics.setColor(255,255,255)
		love.graphics.print(hero[h].armour.name, inventory.armour.x + 60, inventory.armour.y + 10)
		love.graphics.print("+"..hero[h].armour.funcValue.." max health", inventory.armour.x + 60, inventory.armour.y + 30)
		love.graphics.draw(hero[h].armour.image, inventory.armour.x, inventory.armour.y, nil, 50/128)

	else
		love.graphics.print('No Armour', inventory.armour.x + 60, inventory.armour.y + 10)
	end

	for x = 1, 4 do
		for y = 1, hero[h].capacity / 4 do
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill", inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, 50, 50)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, 50, 50)
			if hero[h].items[x + (y - 1) * 4] then
				love.graphics.draw(hero[h].items[x + (y - 1) * 4].image, inventory.x + (x - 1) * 50, inventory.y + (y - 1) * 50, nil, 50/128)
			end
		end
	end
end

	--love.graphics.draw(images.armour, 100, 160)
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

function hero.drawAll()
	for i = 1, #hero do
		hero.draw(i)
	end
end

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

function hero.has_status(i, status)
	for s = 1, #hero[i].status do
		if hero[i].status[s].name == status then
			return true
		end
	end
	return false
end

function hero.atpos(x, y)
	for i = 1, #hero do
		if hero[i].x == x and hero[i].y == y then
			return i
		end
	end
	return false
end
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


hero.status.flavor = {
	['poisoned'] = {'Poisoned:', 'You take 5hp per turn. Wears off in 3-5 turns.'},
	['permeating sight'] = {'Permeating sight:', 'See what is inside chests before you open them by mousing over them.'},
	['night sight'] = {'Night sight:', 'Have a higher view radius'},
	['fortified'] = {'Fortified:', 'You heal 5hp per turn. You will automatically unfortify if you move or attack.'},
}

	function hero.status.draw(i)
		love.graphics.setColor(255, 255, 255)
		for s = 1, #hero[i].status do
			love.graphics.draw(images.status[hero[i].status[s].name], settings.window.width - s * 74, 10)
		end
		s = hero.status.over(i)
		if s then
			mouse.drawtooltip(hero.status.flavor[hero[1].status[s].name][1], hero.status.flavor[hero[1].status[s].name][2])
		end
	end
function hero.status.over(i)
	x, y = love.mouse.getPosition()
	for s = 1, #hero[i].status do
		if util.inside(x, y, settings.window.width - s * 74, 10, 64, 64) then
			return s
		end
	end
	return false
end
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
	function hero.status.remove(i, stat)
		for s = 1, #hero[i].status do
			if hero[i].status[s] == stat then
				table.remove(hero[i].status, s)
			end
		end
	end
	function hero.status.fortify(i)
		table.insert(hero[i].status, 1, {name='fortified', time = 2, total = 2})
	end
	function hero.status.unfortify(i)
		table.remove(hero[i].status, 1)
	end


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

function hero.move_path(i, dt)
	if #hero[i].path > 0 then
		if not hero[i].time then
			hero[i].time = 0
		elseif hero[i].time == 1 then
			hero[i].time = 0
			if #hero[i].path < 2 then
				hero[i].rx = hero[i].path[2].x
				hero[i].ry = hero[i].path[2].y
			end
			--game.say(hero[i].path[1].x..', '..hero[i].path[1].y)
			if hero[i].path[2].grab then
				l = loot.at(hero[i].path[2].x, hero[i].path[2].y)
				l2 = true
				while l and l2 do
					l2 = loot.pickup(l, i)
					l = loot.at(hero[i].path[2].x, hero[i].path[2].y)
				end
			end
			table.remove(hero[i].path, 1)
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
	elseif button == 3 then
		ix, iy = util.pointtogrid(x, y)
		hero.new(ix, iy)
	end
end

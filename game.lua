game = {}

game.runtime = 0

function game.init()
	math.randomseed(os.time()) -- New seed because math.random sucks shittakke mushrooooms
	love.window.setMode(settings.window.width, settings.window.height) -- We can change the window properties in the settings.
	love.window.setIcon(love.image.newImageData('/assets/neath.png'))
	love.window.setTitle(settings.window.title) -- of course, we need a title
	love.mouse.setGrabbed(settings.bGrabMouse)
end

function game.reset()
	map.init(settings.map.width, settings.map.height, settings.map.rooms.amount)
	--sprite.init()
	love.graphics.setFont(font)

	while #world_object > 0 do
		table.remove(world_object, 1)
	end
	while #enemy > 0 do
		table.remove(enemy, 1)
	end
	while #loot > 0 do
		table.remove(loot, 1)
	end

  	world_object.init()
	enemy.makeabunchofenemies()
  	loot.makeabunchofloot()

	new_hero = false
	while not new_hero do
		x = love.math.random(1, settings.map.width)
	    y = love.math.random(1, settings.map.height)
	    if map[x][y] == 'floor' and not world_object.atpos(x, y) and not enemy.atpos(x, y) and not loot.at(x, y) then
			hero.new(x, y)
			camera.setPosition(x * settings.render.tile_size - settings.window.width/2, y * settings.render.tile_size - settings.window.height/2)
			new_hero = true
		end
	end

	love.graphics.setBackgroundColor(settings.render.background.r, settings.render.background.g, settings.render.background.b)
end

function game.turn()
	hero.turnAll()
	enemy.turnAll()
end

game.logs = {}

function game.say(stuff)
	table.insert(game.logs, {v = stuff, t = game.runtime})
end

function game.printlogs()
	offset = 0
	h = 100
	for i = 1, #game.logs do
		if game.logs[i] then
			lines = math.max(1, math.floor(font:getWidth(game.logs[i].v)/200 + 1))
		--if game.logs[i].t + 5 > game.runtime then
			love.graphics.setColor(255,255,255, math.max(0, game.logs[i].t + 2 - game.runtime)*255)

			--love.graphics.print(game.logs[i].v, 20, offset * 20 + 100)
			h = h + lines * 20
			love.graphics.printf(game.logs[i].v, 20, h --[[+ (game.logs[i].t - game.runtime )*100]] , 230)
			offset = offset + lines
		--end
			if math.max(0, game.logs[i].t + 2 - game.runtime)*255 == 0 then
				table.remove(game.logs, i)
			end
		end
	end
	love.graphics.setColor(0, 0, 0, 50)
	--love.graphics.rectangle("fill", 15, 115, 250, 20 * offset)
	love.graphics.setColor(255,255,255)
	--love.graphics.rectangle("line", 15, 115, 250, 20 * offset)
end

function game.move_paths(dt)
	for i = 1, #hero do
		hero.move_path(i, dt)
	end
	for i = 1, #enemy do
		enemy.move_path(i, dt)
	end
end

function game.update(dt)
		camera.update(dt)
		pathfind.reset()

		if hero.selected then
			if hero[hero.selected] then
				ax, ay = love.mouse.getPosition()
				nax, nay = util.pointtogrid(ax, ay)
				if map[nax] and map[1][nay] then
					if map[nax][nay] == 'floor' then
						pathfind.calculate(hero[hero.selected].x, hero[hero.selected].y, nax, nay, hero[hero.selected].speed, true)
					end
				end
			end
		end

		game.move_paths(dt)
end


function game.draw()
	camera.set()
	map.draw()

  world_object.drawAll()

	loot.drawAll()

	if hero.selected then
		--pathfind.debugcalulations()
		pathfind.debugpath()
	end
	enemy.drawAll()

	hero.drawAll()

	x, y = util.mousetogrid()
	camera.unset()
	hover = 1


	if hero.selected then
		hero.drawUI(hero.selected, hover)
		hover = 2
		if showInventory then
			hero.drawInventory(hero.selected)
			item = mouse.overInventoryItem(hero.selected)
			if item then
				mouse.drawtooltip(hero[hero.selected].items[item].typ,
					hero[hero.selected].items[item].flavor)
			end
		end
		if hero.has_status(hero.selected, 'permeating sight') then
			x, y = util.mousetogrid()
			l = loot.at(x, y)
			--print('perm_sight'..x..y)
			if l then
				mouse.drawtooltip(
				loot[l].name, loot[l].flavor
				)
			end
		end
	end
	if enemy.selected then
		hover = 2
		enemy.drawUI(enemy.selected, 1)
	end
	--e = enemy.atpos(x, y)
	--h = hero.atpos(x, y)
	e = false
	h = false
	if h and h ~= hero.selected then
		if hero[h].fortified then
			f = "\nFortified"
		else
			f = ''
		end
		mouse.drawtooltip(
			'Hero',
			'Health: '..hero[h].health..'/'..hero[h].maxhealth..
			'\nAttack: '..hero[h].attack.."   ".."Speed: "..hero[h].speed..
			'\nActions: '..hero[h].actions..'/'..hero[h].maxactions..
			f
		)
	end
	if e then
		mouse.drawtooltip(
		'Class: '..enemy[e].class,
		'Health: '..enemy[e].health..'/'..enemy[e].maxhealth..
		'\nPosition: '..enemy[e].x..', '..enemy[e].y
		)
	end


	love.graphics.setColor(200, 200, 0)
	love.graphics.print('FPS: '..fps, 5, 5)
	--love.graphics.print(camera.vzoom..'|'..camera.offset.x..'|'..camera.offset.y, 20, 20)
	game.printlogs()
end

function game.keypressed(key)
	if key == "i" then
		if showInventory then
			showInventory = false
		else
			showInventory = true
		end
	end

	if key == "f" then
		if hero.selected then
			if hero[hero.selected].fortified then
				hero[hero.selected].actions = hero[hero.selected].actions + 2
				hero[hero.selected].fortified = false
        hero.status.unfortify(hero.selected)
				game.say("No longer fortified")
			else
				if hero[hero.selected].actions >= 2 then
					hero[hero.selected].fortified = true
          hero.status.fortify(hero.selected)
					hero[hero.selected].actions = hero[hero.selected].actions - 2
					game.say("Now Fortified")
				else
					game.say("Cannot fortify, not enough actions")
				end
			end
		end
	end

	if key == "space" then
		game.turn()
		game.say("Next Turn")
	end

	if key == "return"then
		hero.cycle()
	end

	if key == "escape" then
		game.paused = true
		menu.current = menu.scene.paused
	end
end

function game.mousepressed(x, y, button, istouch)
	hero.mousepressed(x, y, button, istouch)
	enemy.mousepressed(x, y, button, istouch)
end

function game.next_level()
	game.say("If there were a level 2, you'd go there now.")
end

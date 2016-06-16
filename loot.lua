loot = {}
loot.amount = 1000

loot.functions = {}
function loot.functions.useless(h, i, v)
	game.say("This "..v.." is useless to you right now. You should probably sell it.")
end

function loot.functions.potato(h, i, v)
	game.say("You eat the eggplant. Raw. What is wrong with you? At least you gain 3 hp.")
	hero.heal(h, 3)
	table.remove(hero[h].items, i)
end

function loot.functions.key(h, i, v)
	game.say("A strange looking key. You wonder what it opens.")

end

function loot.functions.elixir(h, i, v)
	game.say("You drink the elixir and you feel... goooooood.")
	hero.heal(h, v)
	table.remove(hero[h].items, i)
end

function loot.functions.permeating_sight(h, i, v)
	game.say("You drink the strange vial and you feel... like someone just punched you in the eyes.")
	hero.status.add(h, 'permeating sight', 10)
	table.remove(hero[h].items, i)

end

function loot.functions.night_sight(h, i, v)
	game.say("You drink the strange vial and you feel... bright.")
	hero.status.add(h, 'night sight', 10)
	table.remove(hero[h].items, i)

end

loot.functions.equip = {}
function loot.functions.equip.sword(h, i, v)
	if hero[h].sword then
		table.insert(hero[h].items, hero[h].sword)
		hero[h].attack = hero[h].attack - hero[h].sword.funcValue
		game.say("You equip yourself with the new weapon, in hopes it will give you an advantage")
	else
		game.say("You arm yourself; Maybe now you'll stand a chance")
	end
	hero[h].sword = hero[h].items[i]
	hero[h].attack = hero[h].attack + v
	table.remove(hero[h].items, i)
end

function loot.functions.equip.armour(h, i, v)
	if hero[h].armour then
		table.insert(hero[h].items, hero[h].armour)
		hero[h].maxhealth = hero[h].maxhealth - hero[h].armour.funcValue
		game.say("You equip yourself with the new armour, in hopes it will give you an advantage")
	else
		game.say("You put some armour on; Maybe now you'll stand a chance")
	end
	hero[h].armour = hero[h].items[i]
	hero[h].maxhealth = hero[h].maxhealth + v
	hero[h].health = math.min(hero[h].health, hero[h].maxhealth)
	table.remove(hero[h].items, i)
end

function loot.functions.bag(h, i, v)
	if hero[h].capacity < v then
		hero[h].capacity = v
		game.say("Your inventory can now hold "..v.." items.")
		table.remove(hero[h].items, i)
	else
		game.say("You already have a big enough inventory.")
	end
end

loot.types = {
	["treasure"] = {
		name = "treasure",
		value = "100",
		flavor = "Just your standard everyday average treasure, y'know?",
		func = loot.functions.useless,
		funcValue = "treasure",
		color = {
			r = 255,
			g = 255,
			b = 0
		},
		image = love.graphics.newImage('/assets/cash.png')
	},
	["eggplant"] = {
		name = "eggplant",
		value = "1",
		flavor = "You begin to wonder why there are eggplants down here.",
		func = loot.functions.potato,
		funcValue = "1",
		color = {
			r = 50,
			g = 255,
			b = 0
		},
		image = love.graphics.newImage('/assets/eggplant.png')
	},
	["elixir"] = {
		name = "elixir",
		value = "200",
		flavor = "A thick liquid, glowing green in a small vial.",
		func = loot.functions.elixir,
		funcValue = "1000",
		color = {
			r = 50,
			g = 255,
			b = 0
		},
		image = love.graphics.newImage('/assets/bottle-vapors.png')
	},
	["broken shield"] = {
		name = "broken shield",
		value = "1",
		flavor = "A broken shield. It looks as though it could fall apart at any moment.",
		func = loot.functions.equip.armour,
		funcValue = "5",
		color = {
			r = 255,
			g = 0,
			b = 0
		},
		image = love.graphics.newImage('/assets/slashed-shield.png')
	},
	["round shield"] = {
		name = "round shield",
		value = "1",
		flavor = "A slightly worn iron and wood shield",
		func = loot.functions.equip.armour,
		funcValue = "10",
		color = {
			r = 255,
			g = 0,
			b = 0
		},
		image = love.graphics.newImage('/assets/round-shield.png')
	},
	["full armour"] = {
		name = "full armour",
		value = "1",
		flavor = "A fine set of plated armour",
		func = loot.functions.equip.armour,
		funcValue = "25",
		color = {
			r = 255,
			g = 0,
			b = 0
		},
		image = love.graphics.newImage('/assets/battle-gear.png')
	},
	["dagger"] = {
		name = "dagger",
		value = "100",
		flavor = "A puny dagger",
		func = loot.functions.equip.sword,
		funcValue = "3",
		color = {
			r = 225,
			g = 0,
			b = 0
		},
		image = love.graphics.newImage('/assets/dagger.png')
	},
	["key"] = {
		name = "key",
		value = "12",
		flavor = "A rusty old key",
		func = loot.functions.key,
		funcValue = "10",
		color = {
			r = 225,
			g = 255,
			b = 0,
		},
		image = love.graphics.newImage('/assets/key.png')
	},
	["stiletto"] = {
		name = "stiletto",
		value = "100",
		flavor = "A gleaming sword",
		func = loot.functions.equip.sword,
		funcValue = "10",
		color = {
			r = 225,
			g = 0,
			b = 0,
		},
		image = love.graphics.newImage('/assets/stiletto.png')
	},
	["strange unmarked black potion"] = {
		name = "strange unmarked black potion",
		value = "200",
		flavor = "A thick liquid, writhing bright black in a small vial.",
		func = loot.functions.permeating_sight,
		funcValue = "5",
		color = {
			r = 50,
			g = 255,
			b = 0
		},
		image = love.graphics.newImage('/assets/round-bottom-flask.png')
	},
	["strange green glowing potion"] = {
		name = "strange green glowing potion",
		value = "200",
		flavor = "A thick liquid, glowing a bright Blue in a small vial.",
		func = loot.functions.night_sight,
		funcValue = "5",
		color = {
			r = 50,
			g = 255,
			b = 0
		},
		image = love.graphics.newImage('/assets/potion-ball.png')
	},
	["backpack"] = {
		name = "backpack",
		value = "12",
		flavor = "A dirty old backpack",
		func = loot.functions.bag,
		funcValue = 24,
		color = {
			r = 225,
			g = 255,
			b = 0,
		},
		image = love.graphics.newImage('/assets/backpack.png')
	},
	["knapsack"] = {
		name = "knapsack",
		value = "12",
		flavor = "A dirty old knapsack",
		func = loot.functions.bag,
		funcValue = 20,
		color = {
			r = 225,
			g = 255,
			b = 0,
		},
		image = love.graphics.newImage('/assets/knapsack.png')
	},
}

function loot.makeabunchofloot()
	for t = 1, #settings.balance.loot do
		for i = 1, settings.balance.loot[t].amount do
			x = love.math.random(1, settings.map.width)
			y = love.math.random(1, settings.map.height)
			if map[x][y] == 'floor' then
				if not loot.at(x, y) and not world_object.atpos(x, y) and not enemy.atpos(x, y) then
					loot.new(x, y, settings.balance.loot[t].name)
				end
			end
		end
	end
end

function loot.new(ix, iy, t)
	table.insert(loot, {
		name = loot.types[t].name,
		x = ix,
		y = iy,
		typ = t,
		image = loot.types[t].image,
		flavor = loot.types[t].flavor,
		value = loot.types[t].value,
		func = loot.types[t].func,
		funcValue = loot.types[t].funcValue,
		color = loot.types[t].color
	})
end

function loot.pickup(i, h)
	if #hero[h].items < hero[h].capacity then
		game.say("Picked Up: "..loot[i].name)
		table.insert(hero[h].items, {
			name = loot[i].name,
			typ = loot[i].typ,
			value = loot[i].value,
			func = loot[i].func,
			flavor = loot[i].flavor,
			funcValue = loot[i].funcValue,
			image = loot[i].image,
		})
		table.remove(loot, i)
		return true
	else
		game.say("Can't pick up: "..loot[i].name..". Inventory full.")
		return false
	end
end

function loot.at(x, y)
	for i = 1, #loot do
		if loot[i].x == x and loot[i].y == y then
			return i
		end
	end
	return false
end

function loot.drawAll()
	for i = 1, #loot do
		loot.draw(i)
	end
end

function loot.draw(i)
	luminance = util.calc_lum(loot[i].x, loot[i].y)
	love.graphics.setColor(loot[i].color.r * luminance, loot[i].color.g * luminance, loot[i].color.b * luminance)
	--love.graphics.rectangle("fill", loot[i].x * settings.render.tile_size + 6, loot[i].y * settings.render.tile_size + 6, settings.render.tile_size - 12, settings.render.tile_size - 12)
	--love.graphics.draw(loot[i].image, loot[i].x * settings.render.tile_size, loot[i].y * settings.render.tile_size)
	love.graphics.draw(images.item, loot[i].x * settings.render.tile_size, loot[i].y * settings.render.tile_size, nil, settings.render.tile_size/128)
end

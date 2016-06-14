settings = {
	bGrabMouse = false,
	bMuted = false,
	volume = 0.95,
	window = {
		width = 1200,
		height = 720,
		title = "Neath",
	},
	render = {
		tile_size = 200,
		background = {r = 0, g = 0, b = 0},
		animate_speed = 10,
	},
	camera = {
		max_offset = 100,
		speed = {
			x = 900,
			y = 900
		},
		min_zoom = 1.8,
		max_zoom = 10,
		zoom_speed = 10,
	},
	map = {
		rooms = {
			amount = 90,
			min_width = 2,
			min_height = 2,
			max_width = 6,
			max_height = 6,
		},
		width = 100,
		height = 100,
	},
	balance = {
		loot = {
			{
				name = 'eggplant',
				amount = 100,
			},
			{
				name = 'strange unmarked black potion',
				amount = 10,
			},
			{
				name = 'strange green glowing potion',
				amount = 10,
			},
			{
				name = 'elixir',
				amount = 5,
			},
			{
				name = 'treasure',
				amount = 75,
			},
			{
				name = 'dagger',
				amount = 30,
			},
			{
				name = 'knapsack',
				amount = 30,
			},
			{
				name = 'backpack',
				amount = 10,
			},
			--[[
			{
				name = 'broken shield',
				amount = 60,
			},
			]]
			{
				name = 'stiletto',
				amount = 30,
			},
			{
				name = 'full armour',
				amount = 15,
			},
			{
				name = 'round shield',
				amount = 30,
			},
			{
				name = 'key',
				amount = 30,
			},
		},
		enemy = {
			{
				name = 'neath dweller',
				amount = 100,
			},
			{
				name = 'giant spider',
				amount = 120,
			},
			{
				name = 'golem',
				amount = 50,
			},
			{
				name = 'imp',
				amount = 50,
			},
			--[[{
				name = 'heavy',
				amount = 300,
			},]]
		},
	},
}

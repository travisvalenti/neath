-- This sets the walkability of tiles so If I feel like adding more later I can
-- also, wall doesn't use that color anymore it uses a sprite, but i needed to
-- keep the values there cause reasons.
tile = {}

tile['wall'] = {
	walkable = false,
	color = {
		r = 20,
		g = 20,
		b = 20
	},
}

tile['floor'] = {
	walkable = true,
	color = {
		r = 180,
		g = 180,
		b = 180
	},
}

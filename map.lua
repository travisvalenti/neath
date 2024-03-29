map = {}
-- This code is complicated. Let's get started.
map.bitmasks = {}
--Calls generate and sets the width and heigh variables.
-- This function is basically so we can change the map size in game in later levels
function map.init(w, h, r)
	map.generate(w, h, r)
	map.width = w
	map.height = h
end

--Generates the map
--[[
OVERVIEW:
Starts by creating two tables, first is map and second is map.bitmasks.
It sets all the bitmasks as null and the map as 'wall'
then it sets room_amount to the settings of map.rooms.amount
it resets the list of rooms
and defines a buffer. <- No longer Used
It then tries to create rooms for room_amount times, not creating if they intersect
with one another. This results in a bunch of rectangles in the grid, stored as
obejcts with x, y, width and height. Useful as rooms.
It then goes through them all and fills them in with 'floor'
After that it goes through and links each room to an unlinked room then sets
that room as linked. By linked I mean it uses an algorithm to create a 'path'
between the two rooms.
after that it calls calc_bitmasks, which I'll explain later.
]]
function map.generate(w, h, r)
	for x = 1, w do
		map[x] = {}
		map.bitmasks[x] = {}
		for y = 1, h do
			map[x][y] = 'wall'
		end
	end

	room_amount = settings.map.rooms.amount

	--Generate Rooms

	rooms = {}
	buffer = 3

	for r = 1, room_amount do
		i = #rooms + 1
		rooms[i] = {}
		rooms[i].width = math.random(settings.map.rooms.min_width, settings.map.rooms.max_width)
		rooms[i].height = math.random(settings.map.rooms.min_height, settings.map.rooms.max_height)
		rooms[i].x = math.random(2, w - rooms[i].width - 1)
		rooms[i].y = math.random(2, h - rooms[i].height - 1)
		rooms[i].center_x = math.floor(rooms[i].x + rooms[i].width / 2)
		rooms[i].center_y = math.floor(rooms[i].y + rooms[i].height / 2)
		rooms[i].linked = false

		for c = 1, #rooms do
			if r ~= c then
				if util.intersect(rooms[i].x - buffer, rooms[i].y - buffer, rooms[i].width + buffer * 2, rooms[i].height + buffer * 2, rooms[c].x, rooms[c].y, rooms[c].width, rooms[c].height) then
					table.remove(rooms, r)
					break
				end
			end
		end
	end

	for i = 1, #rooms do
		for x = rooms[i].x, rooms[i].x + rooms[i].width do
			for y = rooms[i].y, rooms[i].y + rooms[i].height do
				map[x][y] = 'floor'
			end
		end
	end

	--For each room
	for r = 1, #rooms do
		rooms[r].linked = true
		for c = 1, #rooms do
			if rooms[c].linked ~= true then
				distance = util.manhattan(rooms[r].center_x, rooms[r].center_y, rooms[c].center_x, rooms[c].center_y)
				if closest then
					if distance < closest_distance then
						closest = c
						closest_distance = distance
					end
				else
					closest = c
					closest_distance = distance
				end
			end
		end


		if rooms[r].center_x > rooms[closest].center_x then
			step_x = -1
		else
			step_x = 1
		end
		for x = rooms[r].center_x, rooms[closest].center_x, step_x do
			map[x][rooms[r].center_y] = 'floor'
		end
		if rooms[r].center_y > rooms[closest].center_y then
			step_y = -1
		else
			step_y = 1
		end
		for y = rooms[r].center_y, rooms[closest].center_y, step_y do
			map[rooms[closest].center_x][y] = 'floor'
		end
	end
	map.calc_bitmasks()
end

-- Bitmasking is complicated. Basically this returns some values that help
-- determine what image to draw.
--See http://gamedevelopment.tutsplus.com/tutorials/how-to-use-tile-bitmasking-to-auto-tile-your-level-layouts--cms-25673
-- for an explanation (I based this directly off of that)
function map.calc_bitmasks()
	for x = 1, #map do
		for y = 1, #map[x] do
			bitmask = 0
			if x > 1 then
				if map[x - 1][y] == 'wall' then
					bitmask = bitmask + 2
				end
			else
				bitmask = bitmask + 2
			end
			if x < #map then
				if map[x + 1][y] == 'wall' then
					bitmask = bitmask + 4
				end
			else
				bitmask = bitmask + 4
			end
			if y > 1 then
				if map[x][y - 1] == 'wall' then
					bitmask = bitmask + 1
				end
			else
				bitmask = bitmask + 1
			end
			if y < #map[x] then
				if map[x][y + 1] == 'wall' then
					bitmask = bitmask + 8
				end
			else
				bitmask = bitmask + 8
			end
			map.bitmasks[x][y] = bitmask
		end
	end
end
--Iterates through each tile, calulates luminance and draws it.
function map.draw()
	for x = 1, map.width do
		for y = 1, map.height do
			--c_hero = hero.closest(x, y)
			luminance = util.calc_lum(x, y)
			if map[x][y] == 'floor' then
				love.graphics.setColor(tile[map[x][y]].color.r * luminance, tile[map[x][y]].color.g * luminance, tile[map[x][y]].color.b * luminance)
				love.graphics.rectangle("fill", x * settings.render.tile_size, y * settings.render.tile_size, settings.render.tile_size, settings.render.tile_size)
			else
				love.graphics.setColor(luminance*255, luminance*255, luminance*255)
				love.graphics.draw(wallImage, sprite.quads[map.bitmasks[x][y]], x * settings.render.tile_size, y * settings.render.tile_size)
			end
		end
	end
end

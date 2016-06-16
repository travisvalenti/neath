--[[
Okay. Here's the deal. It's 4am. I'm tired. This is going to be a very simple
and abstracted explanation of the below code.
I used the following pseudo-code from MIT to help:
http://web.mit.edu/eranki/www/tutorials/search/
-----------------------------------------------
initialize the open list
initialize the closed list
put the starting node on the open list (you can leave its f at zero)

while the open list is not empty
    find the node with the least f on the open list, call it "q"
    pop q off the open list
    generate q's 8 successors and set their parents to q
    for each successor
    	if successor is the goal, stop the search
        successor.g = q.g + distance between successor and q
        successor.h = distance from goal to successor
        successor.f = successor.g + successor.h

        if a node with the same position as successor is in the OPEN list \
            which has a lower f than successor, skip this successor
        if a node with the same position as successor is in the CLOSED list \
            which has a lower f than successor, skip this successor
        otherwise, add the node to the open list
    end
    push q on the closed list
end
---------------------------------------------------
That's basically how this works.
]]

pathfind = {}

node = {}
node.open = {}
node.closed = {}

node.path = {}
t = false
--resets all variables
function pathfind.reset()
	path = false
	while table.getn(node) > 0 do
		table.remove(node, 1)
	end

	while table.getn(node.open) > 0 do
		table.remove(node.open, 1)
	end

	while table.getn(node.closed) > 0 do
			table.remove(node.closed, 1)
	end

	while #node.path > 0 do
			table.remove(node.path, 1)
	end
end
-- checks if pos x, y is in the path
function pathfind.inpath(x, y)
	for i = 1, #node.path do
		if node.path[i].x == x and node.path[i].y == y then
			return true
		end
	end
	return false
end
 -- calculates the path
function pathfind.calculate(ox, oy, tx, ty, d, tl)
	node.failed = false
	path = false
	pathfind.reset()
	t = false
	if tl then
		one = hero.atpos(tx, ty)
		two =  enemy.atpos(tx, ty)
		three = world_object.atpos(tx, ty)
	else
		t = true
		one = false
		two =  enemy.atpos(tx, ty)
	end
	if not one and not two and not three then
		pathfind.tx = tx
		pathfind.ty = ty



		found = false

		node[0] = {g = -1}
		node.open.add(ox, oy, 0, tx, ty)
		node[0] = nil
		node[1].isOrigin = true
		x = false

		while not x do
			x = pathfind.step()
		end
		if not node.failed then
			--[[while #node.path > d do
				table.remove(node.path, 1)
			end]]
			if #node.path > d then
				return false
			end
			path = true
			return true
		end
	else
		return false
	end
end
-- steps though the path adding a new node each step
function pathfind.step()
	if #node.open > 0 and found ~= true then
		qi = 1
		q = node.open[1]
		for i = 2, table.getn(node.open) do
			if node.open[i] then
				if node[node.open[i]].f <= node[q].f then
					q = node.open[i]
					qi = i
				end
			end
		end

		table.remove(node.open, qi)

		successors = {}
		if node[q].x + 1 <= table.getn(map) then
			if map[node[q].x + 1][node[q].y] == 'floor' then
				check_wo = world_object.atpos(node[q].x + 1, node[q].y)
				if not check and t and node[q].x + 1 == pathfind.tx and node[q].y == pathfind.ty then
					check = false
				else
					check = hero.atpos(node[q].x + 1, node[q].y)
				end
				if not check and not check_wo and not enemy.atpos(node[q].x + 1, node[q].y) then
					i = table.getn(successors) + 1
					successors[i] = {
						x = node[q].x + 1,
						y = node[q].y,
						parent = q,
						g = node[q].g + 1,
						h = util.manhattan(node[q].x + 1, node[q].y, pathfind.tx, pathfind.ty)
					}
					successors[i].f = successors[i].g + successors[i].h
				end
			end
		end
		if node[q].x - 1 > 0 then
			if map[node[q].x - 1][node[q].y] == 'floor' then
				check_wo = world_object.atpos(node[q].x - 1, node[q].y)
				if not check and  t and node[q].x - 1 == pathfind.tx and node[q].y == pathfind.ty then
					check = false
				else
					check = hero.atpos(node[q].x - 1, node[q].y)
				end
				if not check and not check_wo and not check and not enemy.atpos(node[q].x - 1, node[q].y)then
					i = table.getn(successors) + 1
					successors[i] = {
						x = node[q].x - 1,
						y = node[q].y,
						parent = q,
						g = node[q].g + 1,
						h = util.manhattan(node[q].x - 1, node[q].y, pathfind.tx, pathfind.ty)
					}
					successors[i].f = successors[i].g + successors[i].h
				end
			end
		end

		if node[q].y + 1 <= table.getn(map[node[q].x]) then
			if map[node[q].x][node[q].y + 1] == 'floor' then
				check_wo = world_object.atpos(node[q].x, node[q].y + 1)
				if not check and t and node[q].x == pathfind.tx and node[q].y + 1 == pathfind.ty then
					check = false
				else
					check = hero.atpos(node[q].x, node[q].y + 1)
				end
				if not check and not check_wo and not enemy.atpos(node[q].x, node[q].y + 1)then
					i = table.getn(successors) + 1
					successors[i] = {
						x = node[q].x,
						y = node[q].y + 1,
						parent = q,
						g = node[q].g + 1,
						h = util.manhattan(node[q].x, node[q].y + 1, pathfind.tx, pathfind.ty)
					}
					successors[i].f = successors[i].g + successors[i].h
				end
			end
		end

		if node[q].y - 1 > 0 then
			if map[node[q].x][node[q].y - 1] == 'floor' then
				check_wo = world_object.atpos(node[q].x, node[q].y - 1)
				if t and node[q].x == pathfind.tx and node[q].y - 1 == pathfind.ty then
					check = false
				else
					check = hero.atpos(node[q].x, node[q].y - 1)
				end
				if not check and not check_wo and not enemy.atpos(node[q].x, node[q].y - 1) then
					i = table.getn(successors) + 1
					successors[i] = {
						x = node[q].x,
						y = node[q].y - 1,
						parent = q,
						g = node[q].g + 1,
						h = util.manhattan(node[q].x, node[q].y - 1, pathfind.tx, pathfind.ty)
					}
					successors[i].f = successors[i].g + successors[i].h
				end
			end
		end

		for i = 1, table.getn(successors) do

			if successors[i].x == pathfind.tx and successors[i].y == pathfind.ty then
				found = true
				table.insert(node.closed, q)
				table.insert(node, successors[i])
				pathfind.traceback(table.getn(node))
				return true
			end

			add = true
			remove = false
			for o = 1, table.getn(node.open) do
				if node[node.open[o]].x == successors[i].x and node[node.open[o]].y == successors[i].y then
					if node[node.open[o]].f <= successors[i].f then
						add = false
						--node[node.open[o]].f = successors[i].f
						--node[node.open[o]].parent = successors[i].parent
					else
						remove = o
					end
				end
			end
			if remove then
				--table.remove(node.open, o)
			end

			for c = 1, table.getn(node.closed) do
				if node[node.closed[c]].x == successors[i].x and node[node.closed[c]].y == successors[i].y then
					if node[node.closed[c]].f <= successors[i].f then
						add = false
					end
				end
			end

			if add then
				node.open.add(successors[i].x, successors[i].y, successors[i].parent, pathfind.tx, pathfind.ty)
			end

		end

		table.insert(node.closed, q)

	else
		node.failed = true
		return true
	end
	return false
end
-- traces back from the target through the nodes adding them all to a path list
function pathfind.traceback(c)
	while node[c].isOrigin ~= true do
		table.insert(node.path, {x = node[c].x, y = node[c].y, px = node[node[c].parent].x, py = node[node[c].parent].y})
		c = node[c].parent
	end
	table.insert(node.path, {x = node[c].x, y = node[c].y, px = 0, py = 0})

end
-- adds an open node
function node.open.add(nx, ny, np, tx, ty)
	i = table.getn(node) + 1
	node[i] = {
		x = nx,
		y = ny,
		parent = np,
		g = node[np].g + 1,
		h = util.manhattan(nx, ny, tx, ty),
		index = i
	}
	node[i].f = node[i].g + node[i].h
	table.insert(node.open, i)
	return i
end
-- draws the calculations for debugging. Never called in game.
function pathfind.debugcalulations()
	for i = 1, table.getn(node.closed) do
		love.graphics.setColor(0, 0, 200)
		love.graphics.rectangle("fill", node[node.closed[i]].x * settings.render.tile_size, node[node.closed[i]].y * settings.render.tile_size, settings.render.tile_size, settings.render.tile_size)
	end
	for i = 1, table.getn(node.open) do
		love.graphics.setColor(200, 0, 0)
		love.graphics.rectangle("fill", node[node.open[i]].x * settings.render.tile_size + 1, node[node.open[i]].y * settings.render.tile_size + 1, settings.render.tile_size - 2, settings.render.tile_size - 2)
	end
	for i = 1, table.getn(node.open) do
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(node[node.open[i]].f, node[node.open[i]].x * settings.render.tile_size, node[node.open[i]].y * settings.render.tile_size)
	end
end
-- draws the path for debugging. A modified version of this is called in another
-- file.
function pathfind.debugpath()
	if path then
		for i = 1, table.getn(node.path)-1 do
			love.graphics.setColor(200, 100, 0)
			love.graphics.line(node.path[i].x * settings.render.tile_size + settings.render.tile_size / 2,
				node.path[i].y * settings.render.tile_size + settings.render.tile_size / 2,
				node.path[i].px * settings.render.tile_size + settings.render.tile_size / 2,
				node.path[i].py * settings.render.tile_size + settings.render.tile_size / 2
			)
			if loot.at(node.path[1].x, node.path[1].y) then
				love.graphics.draw(images.hand, node.path[1].x * settings.render.tile_size + 50, node.path[1].y * settings.render.tile_size + 50, nil, 100/256)
			else
				love.graphics.draw(images.path_marker, node.path[1].x * settings.render.tile_size + 50, node.path[1].y * settings.render.tile_size + 3, nil, 100/128)
			end
		end
	end
end

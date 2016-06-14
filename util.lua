util = {}

function util.intersect(ax, ay, aw, ah, bx, by, bw, bh) return ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by end
function util.inside(ax, ay, bx, by, bw, bh) return ax >= bx and ax <= bx + bw and ay >= by and ay <= by + bh end
function util.distance(ax, ay, bx, by) return math.sqrt(math.pow(ax - bx, 2) + math.pow(ay - by, 2)) end
function util.manhattan(ax, ay, bx, by) return math.abs(ax - bx) + math.abs(ay - by) end
function util.pointtogrid(ax, ay) return math.floor((ax*camera.vzoom + camera.offset.x)/settings.render.tile_size), math.floor((ay*camera.vzoom + camera.offset.y)/settings.render.tile_size) end
function util.mousetogrid()
	ax, ay = love.mouse.getPosition()
	return math.floor((ax*camera.vzoom + camera.offset.x)/settings.render.tile_size), math.floor((ay*camera.vzoom + camera.offset.y)/settings.render.tile_size)
end
function util.clamp(v, min, max) return math.min(math.max(v, min), max) end

function util.lerp(a,b,t) return (1-t)*a + t*b end

function util.calc_lum(x, y)
	luminance = 0
	for i = 1, #hero do
		d = util.distance(x, y, hero[i].rx, hero[i].ry)
		if d < hero[i].vision then
			luminance = luminance + hero[i].vision / (d)^3

			hx = math.floor(hero[i].rx + 0.5)
			hy = math.floor(hero[i].ry + 0.5)

			for mx = hx - hero[i].vision, hx + hero[i].vision do
				for my = hy - hero[i].vision, hy + hero[i].vision do
					if map[mx][my] ~= 'floor' then
						if util.raycast((x + 0.5)*settings.render.tile_size, (y + 0.5)*settings.render.tile_size, (hero[i].rx + 0.5)*settings.render.tile_size, (hero[i].ry + 0.5)*settings.render.tile_size, mx*settings.render.tile_size, my*settings.render.tile_size, 1*settings.render.tile_size, 1*settings.render.tile_size) then
							luminance = 0
							--print("intersect: "..x)
						end
					end
				end
			end
		end
	end
	luminance = util.clamp(luminance, 0, 1)
	return luminance
end

function util.raycast(ax, ay, bx, by, cx, cy, cw, ch)
	if
			checkIntersect({x = ax, y = ay}, {x = bx, y = by}, {x = cx, y = cy}, {x = cx + cw, y = cy})
	or	checkIntersect({x = ax, y = ay}, {x = bx, y = by}, {x = cx, y = cy}, {x = cx, y = cy + ch})
	or	checkIntersect({x = ax, y = ay}, {x = bx, y = by}, {x = cx + cw, y = cy}, {x = cx, y = cy + ch})
	or	checkIntersect({x = ax, y = ay}, {x = bx, y = by}, {x = cx, y = cy + ch}, {x = cx + cw, y = cy})
	then
		return true
	end
	return false
end

function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

function checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3) return math.sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
	return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

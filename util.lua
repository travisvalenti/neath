--These are random utilities that are basically solid math. I'll try my best to
-- explain the functions of them but the maths and reasoning is pretty abstract

util = {}

--checks if one rect intersects with another
function util.intersect(ax, ay, aw, ah, bx, by, bw, bh) return ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by end
--checks if a point is inside a rectangle
function util.inside(ax, ay, bx, by, bw, bh) return ax >= bx and ax <= bx + bw and ay >= by and ay <= by + bh end
-- returns the distance between a and b
function util.distance(ax, ay, bx, by) return math.sqrt(math.pow(ax - bx, 2) + math.pow(ay - by, 2)) end
--returns the manhattan distance between a and b
function util.manhattan(ax, ay, bx, by) return math.abs(ax - bx) + math.abs(ay - by) end
-- converts a screen position to a grid position
function util.pointtogrid(ax, ay) return math.floor((ax*camera.vzoom + camera.offset.x)/settings.render.tile_size), math.floor((ay*camera.vzoom + camera.offset.y)/settings.render.tile_size) end
-- returns the grid position of the mouse.
function util.mousetogrid()
	ax, ay = love.mouse.getPosition()
	return math.floor((ax*camera.vzoom + camera.offset.x)/settings.render.tile_size), math.floor((ay*camera.vzoom + camera.offset.y)/settings.render.tile_size)
end
-- clamps v between min and max
function util.clamp(v, min, max) return math.min(math.max(v, min), max) end
max_luminance = 1
-- returns a value between 0 and 1 for position x, y simulating light falloff
-- from all heroes. uses inverse cube law instead of inverse square law for
-- balancing reasons.
function util.calc_lum(x, y)
	luminance = 0
	for i = 1, #hero do
		d = util.distance(x, y, hero[i].rx, hero[i].ry)
		luminance = luminance + hero[i].vision / (d)^3
	end
	luminance = util.clamp(luminance, 0, max_luminance)
	--luminance = 1
	return luminance
end

--returns a value that is t percentage between a and b
-- e.g. 0.5 is half way between a and b, 0.75 is 3 quarters of the way from
-- a to be, and 1 quarter from b to a
function util.lerp(a,b,t) return (1-t)*a + t*b end

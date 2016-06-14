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
max_luminance = 1
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

function util.lerp(a,b,t) return (1-t)*a + t*b end

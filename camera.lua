camera = {}

camera.offset = {
	x = 0,
	y = 0,
}
camera.vzoom = 8

function camera.set()
	love.graphics.push()
	love.graphics.scale(1 / camera.vzoom, 1 / camera.vzoom)
	love.graphics.translate(-camera.offset.x, -camera.offset.y)
end

function camera.unset()
	love.graphics.pop()
end

function camera.move(dx, dy)
	camera.offset.x = camera.offset.x + (dx or 0)
	camera.offset.y = camera.offset.y + (dy or 0)
	camera.clampPosition()
end

function camera.setPosition(x, y)
	camera.offset.x = x or camera.offset.x
	camera.offset.y = y or camera.offset.y
	camera.clampPosition()
end

function camera.clampPosition()
	mx = settings.camera.max_offset
	camera.offset.x = util.clamp(camera.offset.x, 0, mx + settings.map.width * settings.render.tile_size - settings.window.width * camera.vzoom)
	camera.offset.y = util.clamp(camera.offset.y, 0, mx + settings.map.height * settings.render.tile_size - settings.window.height * camera.vzoom)
end

function camera.zoom(dz)
	oz = camera.vzoom + dz/settings.camera.zoom_speed
	camera.vzoom = util.clamp(oz, settings.camera.min_zoom, settings.camera.max_zoom)
	difference = oz - camera.vzoom
	ax, ay = love.mouse.getPosition()
	camera.move(ax * (difference - dz / settings.camera.zoom_speed), ay * (difference - dz / settings.camera.zoom_speed))
end

function camera.update(dt)
	if love.keyboard.isDown("w") then
		camera.move(nil, -dt * settings.camera.speed.y)
	end
	if love.keyboard.isDown("a") then
		camera.move(-dt * settings.camera.speed.x, nil)
	end
	if love.keyboard.isDown("s") then
		camera.move(nil, dt * settings.camera.speed.y)
	end
	if love.keyboard.isDown("d") then
		camera.move(dt * settings.camera.speed.x, nil)
	end

	if love.keyboard.isDown("q") then
		camera.zoom(100 * dt)
	end
	if love.keyboard.isDown("e") then
		camera.zoom(-100 * dt)
	end
end

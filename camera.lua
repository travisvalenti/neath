camera = {}

camera.offset = {
	x = 0,
	y = 0,
}
camera.vzoom = 8
--The two functions below let you set and unset the camera transforms so that
--UI can be drawn above the scene without being affected (unlike if you just
--changed it in the global draw permanently)
--Basically it makes anything drawn between these two function calls act as though it
--were in the camera's view, i.e. the scale and offset would change
--This function sets the graphics settings to the camera settings
function camera.set()
	love.graphics.push()
	love.graphics.scale(1 / camera.vzoom, 1 / camera.vzoom)
	love.graphics.translate(-camera.offset.x, -camera.offset.y)
end
-- This function reverses the function above
function camera.unset()
	love.graphics.pop()
end
--moves the camera. Simple. dx and dy are delta x and delta y, i.e. change in x and y
--A little explanation of the LUA code here for you:
-- there is no += that is why it is offset.x + offset.x + ()
-- The brackets mean that if there is no dx input, then it will add 0 instead of dx
-- because nil evaluates as false, so (false or 0) == 0, but (10 or 0) == 10.
-- It will always return the first.
-- This is interesting because when doing an or statement, it doesn't actually return
-- true or false, it returns the first non-nil or false value, which will evaluate to
--true when automatically cast as a boolean.
function camera.move(dx, dy)
	camera.offset.x = camera.offset.x + (dx or 0)
	camera.offset.y = camera.offset.y + (dy or 0)
	camera.clampPosition()
end
--This is a useful function to actually set the position of the camera
--It's really only called at the beginning when the player spawns.
-- It uses the same concept as explained above
function camera.setPosition(x, y)
	camera.offset.x = (x or camera.offset.x)
	camera.offset.y = (y or camera.offset.y)
	camera.clampPosition()
end
-- This function uses util.clamp (which is a standard clamp) to make sure the camera
-- is within the bounds of the world. There is also an 'mx' which is an allowed offset,
-- so the camera can actually see past the edge as though it were a border.
function camera.clampPosition()
	mx = settings.camera.max_offset
	camera.offset.x = util.clamp(camera.offset.x, 0, mx + settings.map.width * settings.render.tile_size - settings.window.width * camera.vzoom)
	camera.offset.y = util.clamp(camera.offset.y, 0, mx + settings.map.height * settings.render.tile_size - settings.window.height * camera.vzoom)
end
-- This adds the dz (delta zoom or change in zoom) to the rendered zoom
-- It's a little complicated but basically it temporarily stores the new zoom, then
-- sets the zoom to a clamped version of that temp, then sets difference to the unclamped
-- minus the clamped. After that it gets the mouse x and y and zooms in on that position_marker
-- by the difference minus the delta z divided by the speed. This is multiplied by the
-- mouse position to make it zoom to that position, otherwise it would zoom to the top
-- left. I sorta just changed around variables till it worked so yeah.
function camera.zoom(dz)
	oz = camera.vzoom + dz/settings.camera.zoom_speed
	camera.vzoom = util.clamp(oz, settings.camera.min_zoom, settings.camera.max_zoom)
	difference = oz - camera.vzoom
	ax, ay = love.mouse.getPosition()
	camera.move(ax * (difference - dz / settings.camera.zoom_speed), ay * (difference - dz / settings.camera.zoom_speed))
end

--Called every frame. Move the camera around and zooms it n stuff. Uses the basic
-- isDown if statement thing so yeah, not much to it.
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

menu.scene = {}

menu.scene.main = {
	button_y = 360,
	button_size = 100,
	margin = 20,
	middle = love.graphics.getWidth() / 2,
	click = function(x, y)
		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		elseif util.inside(x, y, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Start")
			game.paused = false
			game.started = true
		elseif util.inside(x, y, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Settings")
			menu.scene.settings.last = menu.scene.main
			menu.current = menu.scene.settings
		elseif util.inside(x, y, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y, 128, 128) then
			print("Quit")
			love.event.quit()
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.off, love.graphics.getWidth() - 38, 6)

		love.graphics.draw(images.menu.main.start, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Play", love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.main.settings, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Settings", love.graphics.getWidth() / 2 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


		love.graphics.draw(images.menu.main.quit, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Quit", love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


	end
}

menu.scene.lost = {
	click = function(x, y)

		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		elseif util.inside(x, y, love.graphics.getWidth() / 2 - 132, 490, 128, 128) then
			game.reset()
			game.paused = false
			game.started = true
		elseif util.inside(x, y, love.graphics.getWidth() / 2 + 10, 490, 128, 128) then
			game.reset()
			game.paused = true
			game.started = false
			menu.current = menu.scene.main
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255, 255,255)
		love.graphics.draw(images.logo, love.graphics.getWidth() / 2 - 80, 150)
		width = font:getWrap("You have failed. And quite spectacularly I might add.", 1000)
		love.graphics.printf("You have failed. And quite spectacularly I might add.", love.graphics.getWidth() / 2 - width/2, 350, width, "center")
		love.graphics.draw(images.retry, love.graphics.getWidth() / 2 - 132, 490)
		love.graphics.draw(images.quit, love.graphics.getWidth() / 2 + 10, 490)
		love.graphics.draw(images.off, settings.window.width - 38, 6)
		love.graphics.printf("Play Again?", love.graphics.getWidth() / 2 - 128, 638, 128, "center")
		love.graphics.printf("Give Up", love.graphics.getWidth() / 2 + 10, 638, 128, "center")
	end,
}



menu.scene.splash = {
	click = function(x, y)
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255,255,255)

		love.graphics.draw(images.logo_big, 350, 110)
		width = font:getWrap("Press any key", 1000)
		love.graphics.printf("Press any key", 600-width/2, 690, width, "center")
		width = font:getWrap("Neath\nA game by Travis Valenti", 1000)
		love.graphics.printf("Neath\nA game by Travis Valenti", 600-width/2, 650, width, "center")

	end,

}

menu.scene.settings = {
	click = function(x, y)

		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		end

		if util.inside(x, y, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y + 128 + 50, 128, 128) then
			menu.current = menu.scene.settings.last
		end

		if util.inside(x, y, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y, 128, 128) then
			if menu.subMenu == menu.scene.settings.sound then
				menu.subMenu = nil
			else
				menu.subMenu = menu.scene.settings.sound
			end
		end

		if util.inside(x, y, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y, 128, 128) then
			if menu.subMenu == menu.scene.settings.graphics then
				menu.subMenu = nil
			else
				menu.subMenu = menu.scene.settings.graphics
			end
		end

		if util.inside(x, y, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y, 128, 128) then
			if menu.subMenu == menu.scene.settings.controls then
				menu.subMenu = nil
			else
				menu.subMenu = menu.scene.settings.controls
			end
		end

		if menu.subMenu then
			menu.subMenu.click(x, y)
		end

	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.off, love.graphics.getWidth() - 38, 6)
		love.graphics.draw(images.menu.settings.controls, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Controls", love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.settings.graphics, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Graphics", love.graphics.getWidth() / 2 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.go_back, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y + 128 + 50)
		love.graphics.printf("Go Back", love.graphics.getWidth() / 2 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin + 128 + 50, 128, "center")


		love.graphics.draw(images.menu.settings.sound, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Sound", love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		if menu.subMenu then
			menu.subMenu.draw()
		end

	end,

}

menu.scene.settings.sound = {
	click = function(x, y)
		if util.inside(x, y, love.graphics.getWidth() / 2 - 32, 100, 64, 64) then
			settings.bMuted = not settings.bMuted
			if settings.bMuted then
				music:setVolume(0)
			else
				music:setVolume(settings.volume)
			end
		end

		if util.inside(x, y, love.graphics.getWidth() / 2 - 128, 200, 254, 20) then
			settings.volume = (x - love.graphics.getWidth() / 2 + 128)/254
			if settings.bMuted then
				music:setVolume(0)
			else
				music:setVolume(settings.volume)
			end
		end

	end,
	draw = function ()
		love.graphics.setColor(255,255,255)
		if settings.bMuted then
			love.graphics.draw(images.mute, love.graphics.getWidth() / 2 - 32, 100)
		else
			love.graphics.draw(images.unmute, love.graphics.getWidth() / 2 - 32, 100)
		end
		love.graphics.setColor(200,200,200)
		love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 128, 200, 256, 20)
		love.graphics.setColor(10,10,10)
		love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 128 + 2, 202, 254 * settings.volume, 16)

	end,
}

menu.scene.settings.graphics = {
	resolutions = {
		{w = 1280, h = 720},
		{w = 1600, h = 900},
		{w = 1920, h = 1080},
		{w = 4069, h = 2160},
	},
	resolution_dropdown = false,
	click = function(x, y)
		if util.inside(x, y, love.graphics.getWidth() / 2 - 32, 100, 64, 64) then
			settings.bFullscreen = not settings.bFullscreen
			love.window.setFullscreen(settings.bFullscreen)
		end

		if util.inside(x, y,  love.graphics.getWidth() / 2 - 80, 200, 160, 30) then
			menu.scene.settings.graphics.resolution_dropdown = not menu.scene.settings.graphics.resolution_dropdown
		end

		if menu.scene.settings.graphics.resolution_dropdown then
			for i = 1, #menu.scene.settings.graphics.resolutions do
				if util.inside(x, y,  love.graphics.getWidth() / 2 - 80, 200 + i * 30, 160, 30) then
					settings.window.width = menu.scene.settings.graphics.resolutions[i].w
					settings.window.height = menu.scene.settings.graphics.resolutions[i].h
					love.window.setMode(settings.window.width, settings.window.height, {fullscreentype = "desktop"})
					love.window.setFullscreen(settings.bFullscreen)
				end
			end
		end


	end,
	draw = function ()
		love.graphics.setColor(255,255,255)
		if settings.bFullscreen then
			love.graphics.draw(images.contract, love.graphics.getWidth() / 2 - 32, 100)
		else
			love.graphics.draw(images.expand, love.graphics.getWidth() / 2 - 32, 100)
		end

		love.graphics.setColor(245,245,245)
		love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 80, 200, 160, 30)
		current_resolution = settings.window.width.." x "..settings.window.height
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 80, 200, 160, 30)

		love.graphics.printf(current_resolution, love.graphics.getWidth() / 2 - 80, 208, 160, "center")

		if menu.scene.settings.graphics.resolution_dropdown then
			for i = 1, #menu.scene.settings.graphics.resolutions do
				res = menu.scene.settings.graphics.resolutions[i].w.." x "..menu.scene.settings.graphics.resolutions[i].h

				love.graphics.setColor(245,245,245)
				love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 80, 200 + i * 30, 160, 30)
				love.graphics.setColor(0,0,0)
				love.graphics.printf(res, love.graphics.getWidth() / 2 - 80, 208 + i * 30, 160, "center")
			end
			love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 80, 200 + 30, 160, #menu.scene.settings.graphics.resolutions * 30)

		end

	end,
}

menu.scene.settings.controls = {
	click = function(x, y)
		if util.inside(x, y, love.graphics.getWidth() / 2 - 32, 100, 64, 64) then
			settings.bGrabMouse = not settings.bGrabMouse
			love.mouse.setGrabbed(settings.bGrabMouse)
		end
	end,
	draw = function ()
		love.graphics.setColor(255,255,255)
		if settings.bMuted then
			love.graphics.draw(images.unlocking, love.graphics.getWidth() / 2 - 32, 100)
		else
			love.graphics.draw(images.unlocking, love.graphics.getWidth() / 2 - 32, 100)
		end

	end,
}

menu.scene.paused = {
	button_y = 360,
	button_size = 100,
	margin = 20,
	middle = settings.window.width / 2,
	click = function(x, y)
		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		elseif util.inside(x, y, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Continue")
			game.paused = false
			game.started = true
		elseif util.inside(x, y, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Settings")
			menu.scene.settings.last = menu.scene.paused
			menu.current = menu.scene.settings
		elseif util.inside(x, y, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y, 128, 128) then
			print("Quit")
			love.event.quit()
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.off, settings.window.width - 38, 6)
		love.graphics.print("Pause menu temp. Click anywhere to start.", 40, 40)


		love.graphics.draw(images.menu.go_back, love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Continue", love.graphics.getWidth() / 2 - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.main.settings, love.graphics.getWidth() / 2 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Settings", love.graphics.getWidth() / 2 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


		love.graphics.draw(images.menu.main.quit, love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Quit", love.graphics.getWidth() / 2 + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


	end
}

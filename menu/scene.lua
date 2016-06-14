menu.scene = {}

menu.scene.main = {
	button_y = 360,
	button_size = 100,
	margin = 20,
	middle = settings.window.width / 2,
	click = function(x, y)
		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		elseif util.inside(x, y, menu.scene.main.middle - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Start")
			game.paused = false
			game.started = true
		elseif util.inside(x, y, menu.scene.main.middle - 64 , menu.scene.main.button_y, 128, 128) then
			print("Settings")
			menu.scene.settings.last = menu.scene.main
			menu.current = menu.scene.settings
		elseif util.inside(x, y, menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y, 128, 128) then
			print("Quit")
			love.event.quit()
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.draw(images.off, settings.window.width - 38, 6)
		love.graphics.print("Main menu temp. Click anywhere to start.", 40, 40)


		love.graphics.draw(images.menu.main.start, menu.scene.main.middle - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Play", menu.scene.main.middle - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.main.settings, menu.scene.main.middle - 64 , menu.scene.main.button_y)
		love.graphics.printf("Settings", menu.scene.main.middle - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


		love.graphics.draw(images.menu.main.quit, menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Quit", menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


	end
}

menu.scene.lost = {
	click = function(x, y)
		center = settings.window.width/2

		if x > settings.window.width - 38 and y < 38 then
			love.event.quit()
		elseif util.inside(x, y, center-132, 490, 128, 128) then
			game.reset()
			game.paused = false
			game.started = true
		elseif util.inside(x, y, center+10, 490, 128, 128) then
			game.reset()
			game.paused = true
			game.started = false
			menu.current = menu.scene.main
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.setColor(255, 255,255)
		center = settings.window.width/2
		love.graphics.draw(images.logo, center - 80, 150)
		width = font:getWrap("You have failed. And quite spectacularly I might add.", 1000)
		love.graphics.printf("You have failed. And quite spectacularly I might add.", center - width/2, 350, width, "center")
		love.graphics.draw(images.retry, center - 132, 490)
		love.graphics.draw(images.quit, center + 10, 490)
		love.graphics.draw(images.off, settings.window.width - 38, 6)
		love.graphics.printf("Play Again?", center - 128, 638, 128, "center")
		love.graphics.printf("Give Up", center + 10, 638, 128, "center")
	end,
}



menu.scene.splash = {
	click = function(x, y)
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.draw(images.logo_big, 350, 110)
		width = font:getWrap("Press any key", 1000)
		love.graphics.printf("Press any key", 600-width/2, 690, width, "center")
		width = font:getWrap("Neath\nA game by Travis Valenti", 1000)
		love.graphics.printf("Neath\nA game by Travis Valenti", 600-width/2, 650, width, "center")

	end,

}

menu.scene.settings = {
	click = function(x, y)
		if util.inside(x, y, menu.scene.main.middle - 64 , menu.scene.main.button_y + 128 + 50, 128, 128) then
			menu.current = menu.scene.settings.last
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)

		love.graphics.draw(images.menu.settings.controls, menu.scene.main.middle - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Controls", menu.scene.main.middle - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.settings.graphics, menu.scene.main.middle - 64 , menu.scene.main.button_y)
		love.graphics.printf("Graphics", menu.scene.main.middle - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.go_back, menu.scene.main.middle - 64 , menu.scene.main.button_y + 128 + 50)
		love.graphics.printf("Go Back", menu.scene.main.middle - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin + 128 + 50, 128, "center")


		love.graphics.draw(images.menu.settings.sound, menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Sound", menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

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
		elseif util.inside(x, y, menu.scene.main.middle - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y, 128, 128) then
			print("Continue")
			game.paused = false
			game.started = true
		elseif util.inside(x, y, menu.scene.main.middle - 64 , menu.scene.main.button_y, 128, 128) then
			print("Settings")
			menu.scene.settings.last = menu.scene.paused
			menu.current = menu.scene.settings
		elseif util.inside(x, y, menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y, 128, 128) then
			print("Quit")
			love.event.quit()
		end
	end,
	draw = function ()
		love.graphics.clear(50,50,50)
		love.graphics.draw(images.off, settings.window.width - 38, 6)
		love.graphics.print("Pause menu temp. Click anywhere to start.", 40, 40)


		love.graphics.draw(images.menu.go_back, menu.scene.main.middle - menu.scene.main.margin - 128 - 64 , menu.scene.main.button_y)
		love.graphics.printf("Continue", menu.scene.main.middle - menu.scene.main.margin - 128 - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")

		love.graphics.draw(images.menu.main.settings, menu.scene.main.middle - 64 , menu.scene.main.button_y)
		love.graphics.printf("Settings", menu.scene.main.middle - 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


		love.graphics.draw(images.menu.main.quit, menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y)
		love.graphics.printf("Quit", menu.scene.main.middle + menu.scene.main.margin + 64, menu.scene.main.button_y + 128 + menu.scene.main.margin, 128, "center")


	end
}

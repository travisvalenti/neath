-- Basically a sh**load of imports here. This links all the files together.
-- Note: these are all manually created files, not external libraries. Good luck.
require('settings')
require('util')
require('game')
require('tile')
require('map')
require('hero')
require('enemy')
require('pathfind')
require('sprite')
require('camera')
require('loot')
require('mouse')
require('menu')
require('world_object')

-- Just some variable declarations to default values.
fps = 0
ax, ay, bx, by = 0,0,0,0
nax, nay = 0,0
showInventory = false
font = nil
splash_done = false
images = {}
game.started = false
menu.current = menu.scene.splash

--Now this is an interesting one. The default tile is 200 but the images are
-- 256 so I divide the images by 256 to get a 1px image then times by 200,
-- like this: 256p/256 = 1p, 1p*200 = 200p.
-- Put that together and you get a ratio of 200/256 to scale everything by
scale = 200/256


--This loads everything. EVERYTHING.
function love.load(arg) -- Load the level
	-- loads and plays the music and applies the settings
	music = love.audio.newSource("/assets/sb_fading.mp3")
	music:play()
	if settings.bMuted then
		music:setVolume(0)
	else
		music:setVolume(settings.volume)
	end

	font = love.graphics.newFont(12)
	love.graphics.setFont(font)

	--IDK what sprite.init() does. I have no sprites. Only images.
	sprite.init()

	--this is that game thing that runs parralell to love main see why in game.lua
	game.init()

	--changes the cursor icon.
	--NB: make a setting for that
	cursor = love.mouse.newCursor('/assets/pointing.png', 0,0)
	love.mouse.setCursor(cursor)

	-- A big chunk of image imports. These need to be in love.load()
	images.logo = love.graphics.newImage('/assets/neath.png')
	images.logo_big = love.graphics.newImage('/assets/neath_big.png')
	images.sword = love.graphics.newImage('/assets/sword.png')
	images.armour = love.graphics.newImage('/assets/armour.png')
	images.enemy = love.graphics.newImage('/assets/lizardman.png')
	images.health = love.graphics.newImage('/assets/health.png')
	images.time = love.graphics.newImage('/assets/time.png')
	images.off = love.graphics.newImage('/assets/off.png')
	images.prisoner_locked = love.graphics.newImage('/assets/prisoner_locked.png')
	images.prisoner_unlocked = love.graphics.newImage('/assets/prisoner_unlocked.png')
	images.mute = love.graphics.newImage('/assets/speaker-off.png')
	images.unmute = love.graphics.newImage('/assets/speaker.png')

	images.contract = love.graphics.newImage('/assets/contract.png')
	images.expand = love.graphics.newImage('/assets/expand.png')

	images.unlocking = love.graphics.newImage('/assets/unlocking.png')

	images.path_marker = love.graphics.newImage('/assets/position_marker.png')
	images.attack_hover = love.graphics.newImage('/assets/crossed-swords.png')
	images.use_hover = love.graphics.newImage('/assets/cog.png')
	images.hand = love.graphics.newImage('/assets/hand.png')

	images.menu = {}
	images.menu.main = {}
	images.menu.main.start = love.graphics.newImage('/assets/hole-ladder.png')
	images.menu.main.settings = love.graphics.newImage('/assets/anvil.png')
	images.menu.main.quit = love.graphics.newImage('/assets/invisible.png')

	images.menu.settings = {}
	images.menu.settings.controls = love.graphics.newImage('/assets/button-finger.png')
	images.menu.settings.graphics = love.graphics.newImage('/assets/candle-flame.png')
	images.menu.settings.sound = love.graphics.newImage('/assets/ultrasound.png')
	images.menu.go_back = love.graphics.newImage('/assets/return-arrow.png')


	images.quit = love.graphics.newImage('/assets/quit.png')
	images.retry = love.graphics.newImage('/assets/retry.png')

	images.enemies = {}
	images.enemies['neath dweller'] = love.graphics.newImage('/assets/lizardman.png')
	images.enemies['imp'] = love.graphics.newImage('/assets/imp.png')
	images.enemies['golem'] = love.graphics.newImage('/assets/golem.png')
	images.enemies['giant spider'] = love.graphics.newImage('/assets/spider.png')

	images.status = {}
	images.status['fortified'] = love.graphics.newImage('/assets/status_fortified.png')
	images.status['poisoned'] = love.graphics.newImage('/assets/status_poisoned.png')
	images.status['permeating sight'] = love.graphics.newImage('/assets/permsight.png')



	images.item = love.graphics.newImage('/assets/chest.png')



	images.equipment = {}
	images.equipment['stiletto'] = love.graphics.newImage('/assets/stiletto.png')
	images.equipment['dagger'] = love.graphics.newImage('/assets/dagger.png')

	images.equipment['round shield'] = love.graphics.newImage('/assets/round-shield.png')
	images.equipment['broken shield'] = love.graphics.newImage('/assets/slashed-shield.png')
	images.equipment['full armour'] = love.graphics.newImage('/assets/battle-gear.png')


--Gosh, finally those image imports are donw. What a marathon
-- anyway this function resets the game (or starts it) to be at default values
	game.reset()

end


framedt = 1
--called every frame by love
function love.update(dt)
	-- adds delta time to runtime
	game.runtime = game.runtime + dt
	--the below code refreshes the framerate every 0.4s
	framedt = framedt + dt
	if framedt >= 0.4 then
		framedt = 0
		fps = math.floor(1/dt)
	end
	--This is the code that figures out when to draw the game and when to draw
	-- the menus and stuff. It also checks for the lose-state
	if game.paused then
	elseif game.started then
		game.update(dt)
		if #hero == 0 then
			game.started = false
			game.paused = true
			menu.current = menu.scene.lost
		end
	else
	end
end

-- Calls all the draw stuff depending no the game variables (paused, started)
function love.draw()
	if game.paused then
		menu.current.draw()
	elseif game.started then
		game.draw()
	else
		menu.current.draw()
	end
end

-- called by love on each keypress. This function goes through some global
--  and debug buttons (`) and goes through some different cases that don't need
--   their own functions
function love.keypressed( key ) -- called by love.
	if key == '`' then
		debug.debug()
	end
	if game.paused then
		if key == 'escape' then
			if menu.current == menu.scene.paused then
				game.paused = false
			end

		end
	elseif game.started then
		game.keypressed(key)
	else
		menu.current = menu.scene.main
		--game.started = true
		game.paused = true
	end
end

-- called when a mouse is clicked
--  this is the same as the above basically
function love.mousepressed(x, y, button, istouch)
	if game.paused then
		menu.mousepressed(x, y, button, istouch)
	elseif game.started then
		game.mousepressed(x, y, button, istouch)
	else
		menu.current = menu.scene.main
		--game.started = true
		game.paused = true
	end
end

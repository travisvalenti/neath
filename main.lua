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

fps = 0
ax, ay, bx, by = 0,0,0,0
nax, nay = 0,0
showInventory = false
font = nil
splash_done = false
images = {}
game.started = false
menu.current = menu.scene.splash

scale = 200/256

function love.load(arg) -- Load the level
	music = love.audio.newSource("/assets/sb_fading.mp3")
	music:play()

	font = love.graphics.newFont(12)
	love.graphics.setFont(font)
	sprite.init()
	game.init()

	cursor = love.mouse.newCursor('/assets/pointing.png', 0,0)
	love.mouse.setCursor(cursor)

	images.logo = love.graphics.newImage('/assets/neath.png')
	images.logo_big = love.graphics.newImage('/assets/neath_big.png')
	--images.fortified = love.graphics.newImage('/assets/fortify.png')
	--images.player = love.graphics.newImage('/assets/hero.png')
	--images.enemy = love.graphics.newImage('/assets/enemy.png')
	images.sword = love.graphics.newImage('/assets/sword.png')
	images.armour = love.graphics.newImage('/assets/armour.png')
	images.enemy = love.graphics.newImage('/assets/lizardman.png')
	images.health = love.graphics.newImage('/assets/health.png')
	images.time = love.graphics.newImage('/assets/time.png')
	images.off = love.graphics.newImage('/assets/off.png')
	images.prisoner_locked = love.graphics.newImage('/assets/prisoner_locked.png')
	images.prisoner_unlocked = love.graphics.newImage('/assets/prisoner_unlocked.png')

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


	game.reset()

	--hero.new(1,1)
	--ax, ay, bx, by = pathfind.dostuff()
	--pathfind.calculate(ax, ay, bx, by, 20)

	--hero.spawnRandom()

end
framedt = 1
function love.update(dt)
	game.runtime = game.runtime + dt
	framedt = framedt + dt
	if framedt >= 0.4 then
		framedt = 0
		fps = math.floor(1/dt)
	end
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

function love.draw()
	if game.paused then
		menu.current.draw()
	elseif game.started then
		game.draw()
	else
		menu.current.draw()
	end
end

function love.keypressed( key ) -- called by love.
	if key == '`' then
		debug.debug()
	end
	if key == 'o' then
		world_object.new(hero[1].x, hero[1].y + 1, 'prisoner_unlocked')
		--print(world_object[#world_object].x..', '..world_object[#world_object].x)
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

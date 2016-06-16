-- Please ignore this file. I'm like 97.2% sure it's unused

sprite = {}
sprite.quads = {}
function sprite.init()
	wallImage = love.graphics.newImage('/assets/walls.png')
	wallBatch = love.graphics.newSpriteBatch(wallImage, 50*50)

	sprite.addQuad(0, 0, 0)
	sprite.addQuad(1, 200, 0)
	sprite.addQuad(2, 400, 0)
	sprite.addQuad(3, 600, 0)

	sprite.addQuad(4, 0, 200)
	sprite.addQuad(5, 200, 200)
	sprite.addQuad(6, 400, 200)
	sprite.addQuad(7, 600, 200)

	sprite.addQuad(8, 0, 400)
	sprite.addQuad(9, 200, 400)
	sprite.addQuad(10, 400, 400)
	sprite.addQuad(11, 600, 400)

	sprite.addQuad(12, 0, 600)
	sprite.addQuad(13, 200, 600)
	sprite.addQuad(14, 400, 600)
	sprite.addQuad(15, 600, 600)


end

function sprite.addQuad(n, x, y)
	sprite.quads[n] = love.graphics.newQuad(x, y, 200, 200, 800, 800)
end

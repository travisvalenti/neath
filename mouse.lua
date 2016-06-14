mouse = {}

function mouse.drawtooltip(head, content)
	x, y = love.mouse.getPosition()
	w = math.max(font:getWidth(head), font:getWidth(content)) + 15
	h = 50
	h = (select(2, string.gsub(content, '\n', '\n')) + 1) * font:getHeight() + 29
	love.graphics.setColor(0, 0, 0, 50)
	love.graphics.rectangle("fill", x - w - 5, y, w, h)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", x - w - 5, y, w, h)
	love.graphics.print(head, x + 4 - w, y + 4)
	love.graphics.print(content, x + 4 - w, y + 24)
end

function mouse.overInventoryItem(h)
	x, y = love.mouse.getPosition()
	-- i = gx + (gy - 1) * 4
	for i = 1, #hero[h].items do
		gx = (i - 1) % 4 + 1
		gy = (i - gx) / 4 + 1
		--print(gx, gy)
		if util.inside(x, y, inventory.x + (gx - 1) * 50, inventory.y + (gy - 1) * 50, 50, 50) then
			return i
		end
	end
	return false
	--[[
	if x >= inventory.x and x <= inventory.x + inventory.w then
		print(x)
		i = math.floor((y - inventory.y)/20)
		--game.say("i is: "..i)
		if hero[h].items[i] then
			--game.say("over: "..i)
			return i
		end
		--love.graphics.rectangle("fill", 500, i * 20 + 95, 200, 20)
	end
	return false
	]]
end

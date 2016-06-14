menu.button = {}
function menu.button.new(text, x, y, w, h, action, color, color2)
  text = text or "NIL_VALUE"
  x = x or 0
  y = y or 0
  w = w or 100
  h = h or 30
  color = color or {r = 255, g = 255, b = 255}
  color2 = color2 or {r = 0, g = 0, b = 0}
  action = action or menu.actions.default
  return {
    text = text,
    x = x,
    y = y,
    w = w,
    h = h,
    action = action,
    draw = function ()
      love.graphics.setColor(color.r, color.g, color.b)
      love.graphics.rectangle("fill", x, y, w, h)
      love.graphics.setColor(color2.r, color2.g, color2.b)
      love.graphics.print(text, x, y)
    end
  }

end

function menu.button.draw(text, x, y, w, h, action, color, color2)

end

menu = {}
require('menu.actions')
require('menu.button')
require('menu.scene')


function menu.mousepressed(x, y, button, istouch)
  if button == 1 then
    menu.current.click(x, y)
  end
end

-- Wow what a stub. This file handles initialization of menu, and imports the
-- three menu subcats from the menu folder
-- it also handles clicking for the meny.
menu = {}
require('menu.actions')
require('menu.button')
require('menu.scene')

function menu.mousepressed(x, y, button, istouch)
  if button == 1 then
    menu.current.click(x, y)
  end
end

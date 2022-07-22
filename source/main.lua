local gfx = playdate.graphics

local dx = 0.05
local dz = 0.01
local speed = 0.1
local x = 0
local z = 0

local point = { math.random(), math.random() } 

playdate.display.setRefreshRate(0)

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 400, 240)
gfx.setColor(gfx.kColorBlack)

function playdate.update()
  local x,y = point[1], point[2]

  local dx = gfx.perlin(x,y,x+y+z, 0, 5, 0.8) - 0.5
  local dy = gfx.perlin(x,y,x+y+z+1, 0, 5, 0.8) - 0.5

  x += dx * speed
  y += dy * speed

  if x < 0 then x += 1 elseif x >= 1 then x -= 1 end
  if y < 0 then y += 1 elseif y >= 1 then y -= 1 end

  gfx.drawPixel(400*x, 240*y)

  point = {x,y}
	
	z += dz
end

function playdate.AButtonDown()
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, 400, 240)
	gfx.setColor(gfx.kColorBlack)
end

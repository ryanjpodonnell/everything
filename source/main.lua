local data = 0
local font = playdate.graphics.font.new('images/Nano Sans 2X')
local gfx = playdate.graphics

function toBits(num)
  -- returns a table of bits, least significant first.
  local bits = {}

  while num > 0 do
    local rest = math.fmod(num, 2)
    bits[#bits + 1] = rest
    num = math.floor((num - rest) / 2)
  end

  return bits
end

function clearScreen()
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, 50, 30)
  gfx.setColor(gfx.kColorBlack)
end

function clearTextScreen()
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 20, 50, 30)
  gfx.setColor(gfx.kColorBlack)
end

playdate.display.setRefreshRate(0)
playdate.display.setScale(8)
clearScreen()

function playdate.update()
  local bitString = toBits(data)

  for i=1,#bitString do
    if bitString[i] == 1
    then
      gfx.setColor(gfx.kColorBlack)
      gfx.drawPixel(i-1, 0)
    else
      gfx.setColor(gfx.kColorWhite)
      gfx.drawPixel(i-1, 0)
    end
  end

  local text = string.format("%04x", data)
  clearTextScreen()
  playdate.graphics.setFont(font)
  playdate.graphics.drawText(text, 0, 20)
end

function playdate.AButtonDown()
  data = 0

  clearScreen()
end

function playdate.BButtonDown()
  data = data + 1

  if data > 65535
  then
    data = 0
  end
end

function playdate.cranked(change, acceleratedChange)
  data = data + math.floor(math.abs(acceleratedChange))

  if data > 65535
  then
    data = 0
  end
end

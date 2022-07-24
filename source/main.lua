local data = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0
}
local changes = {
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false, false, false, false, false, false,
  false, false, false, false, false
}
local font = playdate.graphics.font.new('images/Nano Sans 2X')
local gfx = playdate.graphics

function clearScreen()
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, 50, 24)
  gfx.setColor(gfx.kColorBlack)

  playdate.graphics.drawLine(0, 24, 50, 24)
  playdate.graphics.setFont(font)
  playdate.graphics.drawText('everything', 0, 25)
end

function decreaseData(num)
  for i = 1, #data do
    local value = data[i] + num

    if value < 0
    then
      num = -1

      data[i] = value + 65536
      changes[i] = true
    else
      data[i] = value
      changes[i] = true
      return
    end
  end
end

function drawBitString(data, iterator)
  local startingPixel = (iterator - 1) * 16

  local bitString = toBits(data)
  for i = 1, #bitString do
    local x = (startingPixel + i - 1) % 50
    local y = math.floor((startingPixel + i - 1) / 50)

    if bitString[i] == 1
    then
      gfx.setColor(gfx.kColorBlack)
      gfx.drawPixel(x, y)
    else
      gfx.setColor(gfx.kColorWhite)
      gfx.drawPixel(x, y)
    end
  end
end

function increaseData(num)
  for i = 1, #data do
    local value = data[i] + num

    if value > 65535
    then
      num = 1

      data[i] = value - 65536
      changes[i] = true
    else
      data[i] = value
      changes[i] = true
      return
    end
  end
end

function playdate.AButtonDown()
  increaseData(1)
end

function playdate.BButtonDown()
  decreaseData(-1)
end

function playdate.cranked(change, acceleratedChange)
  if acceleratedChange > 0
  then
    increaseData(math.floor(acceleratedChange))
  else
    decreaseData(math.floor(acceleratedChange))
  end
end

function playdate.downButtonDown()
  for i = 1, #data do
    data[i] = 0
    changes[i] = true
  end
end

function playdate.leftButtonDown()
  decreaseData(-65535)
end

function playdate.rightButtonDown()
  increaseData(65535)
end

function playdate.upButtonDown()
  for i = 1, #data do
    data[i] = math.random(0, 65535)
    changes[i] = true
  end
end

function playdate.update()
  if playdate.isCrankDocked()
  then
    increaseData(1)
  end

  for i = 1, #data do
    if changes[i] == true
    then
      drawBitString(data[i], i)
      changes[i] = false
    end
  end
end

function toBits(num)
  local bits = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  local i = 0

  while num > 0 do
    local rest = math.fmod(num, 2)
    bits[i + 1] = rest
    i = i + 1
    num = math.floor((num - rest) / 2)
  end

  return bits
end

playdate.display.setRefreshRate(0)
playdate.display.setScale(8)
clearScreen()

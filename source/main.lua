local gfx = playdate.graphics

playdate.display.setRefreshRate(0)
playdate.display.setScale(8)

gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, 50, 30)
gfx.setColor(gfx.kColorBlack)

local data = 0

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
end

function playdate.AButtonDown()
  data = 0
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, 50, 30)
  gfx.setColor(gfx.kColorBlack)
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

function toBits(num)
  -- returns a table of bits, least significant first.
  local t={} -- will contain the bits
  while num>0 do
    rest=math.fmod(num,2)
    size = #t
    t[size+1]=rest
    num=math.floor((num-rest)/2)
  end
  return t
end

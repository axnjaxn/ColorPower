pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function bcd2str(y)
   return tostr(shr(band(y, 0xf00), 8))
      .. tostr(shr(band(y, 0xf0), 4))
      .. tostr(band(y, 0xf))
end

function byte2bcd(x)
   x = shr(x, 8)
   for i = 0, 7 do
      if (band(x, 0xf0) >= 0x50) x += 0x30
      if (band(x, 0x0f) >= 0x05) x += 0x03
      x = shl(x, 1)
   end
   return x
end

--unsigned; assumes x, y are two digits (third digit ignored / used as carry)
function bcdadd(x, y)
   local c = 0
   if (band(x, 0x0f) + band(y, 0x0f) >= 0x0a) c += 0x06
   if (band(x, 0xff) + band(y, 0xff) + c >= 0xa0) c += 0x60
   return x + y + c
end

local y, s
for x = 0, 255 do
   y = byte2bcd(x)
   s = bcd2str(y)
   if (sub(s, 1, 1) == "0") s = sub(s, 2, -1)
   if (sub(s, 1, 1) == "0") s = sub(s, 2, -1)
   if s != tostr(x) then
      print("failed at " .. x)
      print("got " .. s)
      print("from buffer " .. y)
      break
   end
end

local a, b
for x = 0, 255 do
   for y = 0, 255 do
      a = byte2bcd(x)
      b = byte2bcd(y)
      s = bcd2str(bcdadd(a, b))
      while #s > 1 and sub(s, 1, 1) == "0" do
         s = sub(s, 2, -1)
      end
      if s != tostr(x + y) then
         print("failed at x=" .. x .. " y=" .. y)
         print("got " .. s)
         print("expected " .. tostr(a + b))
         goto _
      end
   end
end
::_::

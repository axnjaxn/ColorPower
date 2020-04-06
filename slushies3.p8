pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--common
cartdata("axnjaxn_slushies3")

function clear()
   camera(0,-32)
   cls()
   color(1)
   cursor(1,1)
   map(0,0,0,0,16,16)
end

function pause()
   local ok
   repeat
      flip()
      ok = btnp(4)
   until ok or btnp(5)
   flip()
   return ok
end

function wait(frames)
   for i=1,frames do flip() end
end

function menu(lst,x,y,sel)
   if (x == nil) x = 5
   if (y == nil) y = 12
   if (sel == nil) sel = 1
   while true do
      for i=1,#lst do
         color(1)
         if (sel==i) color(8)
         print(lst[i], x, y+8*i-8)
      end
      flip()

      if btnp(2) then
         sel = sel - 1
         if (sel <= 0) sel = #lst
      elseif btnp(3) then
         sel = sel + 1
         if (sel > #lst) sel = 1
      elseif btnp(4) then
         return sel
      elseif btnp(5) then
         return nil
      end
   end
end

function numbermenu(is_int, dx, dy, x, y)
   savescr()

   if (is_int == nil) is_int = true
   if (x == nil) x = 104
   if (y == nil) y = 24
   if (dx == nil) dx = 1
   if (dy == nil) dy = 58
   local m = {
      "back", 2, 0,
      "1", 0, 6,
      "2", 8, 6,
      "3", 16, 6,
      "4", 0, 12,
      "5", 8, 12,
      "6", 16, 12,
      "7", 0, 18,
      "8", 8, 18,
      "9", 16, 18,
      ".", 0, 24,
      "0", 8, 24,
      "<", 16, 24,
      "enter", 0, 30
   }

   local sel=1
   local j
   local s=""
   local has_decimal = is_int

   while true do
      loadscr()

      j=0
      for i=1,#m-2,3 do
         color(1)
         if (sel == j) color(8)
         print(m[i], m[i+1]+x, m[i+2]+y)
         j = j + 1
      end
      print(s, dx, dy, 8)
      flip()

      if btnp(0) then
         sel = sel - 1
         if (sel < 0) sel = #m - 1
      elseif btnp(1) then
         sel = sel + 1
         if (sel > 13) sel = 0
      elseif btnp(2) then
         if sel == 0 then
            sel = 13
         elseif sel == 13 then
            sel = 11
         else
            sel = sel - 3
            if (sel < 0) sel = 0
         end
      elseif btnp(3) then
         if sel == 0 then
            sel = 2
         elseif sel == 13 then
            sel = 0
         else
            sel = sel + 3
            if (sel > 13) sel = 13
         end
      elseif btnp(4) then
         if sel == 0 then
            return nil
         elseif sel < 10 then
            if (#s < 3 or sub(s, -3, -3) != ".") s = s .. tostr(sel)
         elseif sel == 11 then
            if (#s < 3 or sub(s, -3, -3) != ".") s = s .. "0"
         elseif sel == 10 and not has_decimal then
            s = s .. "."
            has_decimal = true
         elseif sel == 12 and #s > 0 then
            if (sub(s, -1, -1) == ".") has_decimal = not is_int
            s = sub(s, 1, -2)
         elseif sel == 13 then
            if (#s == 0) return nil
            return tonum(s)
         end

         if #s > 4 then
            s = sub(s, 1, 4) --cap at four-character strings
            print(s, dx, dy, 1)
            wait(2)
            print(s, dx, dy, 8)
            flip()
         end
      end
   end
end

function heading(title)
   color(1)
   for r=1+4*#title,127-3,4 do
      line(r,3,r+2,3)
   end
   print(title)
end

function savescr()
   memcpy(0x1000, 0x6000, 0x1000)
   memcpy(0x4300, 0x7000, 0x1000)
end

function loadscr()
   memcpy(0x6000, 0x1000, 0x1000)
   memcpy(0x7000, 0x4300, 0x1000)
end

function savegame()
   dset(0, 1)
   dset(1, stats.m)
   dset(2, stats.s)
   dset(3, stats.h)
   dset(4, stats.c)
   dset(5, stats.d)
   dset(6, stats.k)
   dset(7, stats.p)
end

function loadgame()
   return {
      m=dget(1),
      s=dget(2),
      h=dget(3),
      c=dget(4),
      d=dget(5),
      k=dget(6),
      p=dget(7)
   }
end

-->8
--main game implementation
::mainlogo::
clear()
for i=0,12 do spr(6,24+6*i,0) end
flip()
for r=1,5 do
   for c=0,2 do
      if r==3 then
         spr(16,18,8*r,12,1)
      else
         spr(7,42+18*c,8*r)
      end
   end
   flip()
end
for i=0,12 do spr(6,24+6*i,48) end
pause()

::mainmenu::
clear()
flip()
for r=0,7 do
   for c=0,20 do
      line(1+6*c,5+8*r,5+6*c,8*r+1,1)
   end
   flip()
end
for r=1,6 do
   for c=1,19 do
      line(1+6*c,5+8*r,5+6*c,8*r+1,15)
   end
   flip()
end

print("main menu",46,8,1)
m={"new game", "load game", "credits"}
if (dget(0)==0) del(m,m[2])
repeat
   sel=menu(m, 8, 16, #m-1)
until sel

if sel==1 then
   clear()
   print("2004 ad...")
   print("your corporation, slushies")
   print("international makers")
   print("incorporated, or sim inc. for")
   print("short has gone belly up. you")
   print("used the time machine to come")
   print("back one year and save your")
   print("business from bankruptcy. you")
   print("have one year to fix things")
   print("before they go south again.")
   pause()

   stats = {
      m = 100,
      s = 0,
      h = 100,
      c = 10,
      d = 1,
      k = 0,
      p = 0.50
   }
   savegame()
elseif sel==#m then
   clear()
   print("slushies 3 pico-8 port")
   print("----------------------")
   print("concept and development")
   print("brian jackson")
   print("axnjaxn.com")
   print("(c) 2003-2020")
   pause()
   goto mainmenu
end

stats = loadgame()

::status::
savegame()

clear()
line(1,1,126,1)
line(126,1,126,53)
line(1,53,1,1)
line(1,9,126,9)
line(118,1,118,9)
line(124,3,120,7)
line(120,3,124,7)
print("status",48,3)

for i=21,126,21 do
   line(i-20,55,i-20,63)
   line(i-20,55,i-1,55)
end
print("run",3,57)
print("sply",24,57)
print("fite",45,57)
print("nite",66,57)
print("cort",87,57)
print("end",108,57)

print("money",3,15)
print("slushies",3,21)
print("health",3,27)
print("customers",3,33)
print("day",3,39)
print("price",3,45)
color(8)
print(stats.m,45,15)
print(stats.s,45,21)
print(stats.h,45,27)
print(stats.c,45,33)
print(stats.d,45,39)
print(stats.p,45,45)

m = {
   "run",3,57,
   "sply",24,57,
   "fite",45,57,
   "nite",66,57,
   "cort",87,57,
   "end",108,57
}
sel = 1

savescr()
while true do
   loadscr()
   j=1
   for i=1,#m-2,3 do
      color(1)
      if (sel==j) color(8)
      print(m[i], m[i+1], m[i+2])
      j = j + 1
   end
   if sel == 0 then
      print("watch out for the teacher", 1, 66, 8)
   end
   flip()

   if btnp(0) then
      sel = sel - 1
      if (sel <= 0) sel = #m/3
   elseif btnp(1) then
      sel = sel + 1
      if (sel > #m/3) sel = 1
   elseif btnp(2) and sel == 0 then
      goto status
   elseif btnp(3) then
      sel = 0
   elseif btnp(4) then
      break
   end
end

if sel == 1 then goto runscreen
elseif sel == 2 then goto supplymenu
elseif sel == 3 then goto fightmenu
elseif sel == 4 then goto nightmenu
elseif sel == 5 then goto courtmenu
elseif sel == 6 then goto endmenu
end

--teacher screen
clear()
spr(32, 1, 1, 3, 1)
spr(35, 19*6+1, 9, 2, 1)
spr(37, 1, 17, 3, 1)
spr(40, 19, 17)
spr(41, 25, 17)
spr(41, 121, 25)
spr(37, 1, 33, 3, 1)
spr(42, 19, 33, 2, 1)
spr(48, 61, 41, 9, 1)
pause()
goto status
z/=8
print(z, 124, 19)
print("ans*pi", 1, 25)
z=tostr(z * 3.14159265358979)
print(z, 128-4*#z, 31)
pause()
goto status

::supplymenu::
clear()
heading("supply")
sel=menu({"buy","price","steal","eat"})

if sel == 1 then
   goto buyscreen
elseif sel == 2 then
   goto pricescreen
elseif sel == 3 then
   goto stealscreen
elseif sel == 4 then
   goto eatscreen
else
   goto status
end

::fightmenu::
clear()
heading("fight")
sel=menu({"dojo","street"})

if sel == 1 then
   goto dojoscreen
elseif sel == 2 then
   goto streetscreen
else
   goto status
end

::nightmenu::
clear()
heading("night")
sel=menu({"sleep","clubbing"})

if sel == 1 then
   goto sleepscreen
elseif sel == 2 then
   goto clubbingscreen
else
   goto status
end

::courtmenu::
clear()
heading("court")
sel=menu({"sue competitors","file a claim"})

if sel == 1 then
   goto suescreen
elseif sel == 2 then
   goto claimscreen
else
   goto status
end

::endmenu::
clear()
heading("end game")
sel=menu({"yes", "no"}, 5, 12, 2)

if sel == 1 then
   goto endscreen
else
   goto status
end

::buyscreen::
clear()
heading("buy")
z = 5 * flr(9 * rnd()) + 10
print("price=" .. z)
print("how many boxes?")
print("(0 = full)")
y = numbermenu(true, 1, 25)
if (y == nil) goto status
if (y == 0) y = flr(stats.m / z)
if stats.m < y * z then
   clear()
   print("not enough")
   pause()
else
   stats.m -= y * z
   stats.s += 50 * y
end
goto status

::pricescreen::
clear()
print("new price?")
z = numbermenu(false, 1, 9)
if (z == nil) goto status
y = flr(4 * (z - stats.p))
if z > 5 then
   z = 5
   clear()
   print("adjusted price")
   pause()
end
stats.c -= y
if (stats.c < 0) stats.c = 0
stats.p = z
goto status

::stealscreen::
clear()
print("stealing...")
wait(60)
y = flr(3 * rnd())
stats.d += 1
if y == 0 then
   print("success!")
   z = 5 * flr(10 * rnd()) + 5
   wait(30)
   print("stole " .. z .. " slushies")
   stats.s += z
elseif y == 1 then
   print("success!")
   print("but the slushies were")
   print("contaminated and")
   print("some customers left")
   stats.c -= flr(9 * rnd())
   if (stats.c < 0) stats.c = 0
else
   print("you were caught,")
   print("paid a fine, and spent")
   print("two weeks in jail")
   stats.m -= 200
   stats.d += 14
   stats.h = 50
end
pause()
goto status

::eatscreen::
clear()
print("eat how many?")
sel = menu({"25", "50", "full"}, 1, 9)
if sel == nil then
   goto status
elseif sel == 1 then
   z = 25
elseif sel == 2 then
   z = 50
else
   z = 100
end
if (z > 100 - stats.h) z = (100 - stats.h)
if (z > stats.s) z = stats.s
stats.s -= z
stats.h += z
goto status

::dojoscreen::
clear()
if stats.h < 45 then
   print("you are too tired")
   pause()
else
   print("current rank:" .. stats.k)
   print("training...")
   savescr()
   y = flr(15 * rnd()) + 7
   for z=1,y do
      loadscr()
      cursor(1,13)
      print("day " .. stats.d + z)
      wait(2)
   end
   print("level up!")
   stats.d += y
   stats.k += 1
   stats.h -= 45
   stats.c -= 1
   if (stats.c < 0) stats.c = 0
   pause()
end
goto status

::streetscreen::
clear()
z = 90
y = flr(15 * rnd())
if y >= 10 and y < 13 then
   print("arnold attack", 1, 58)
   z = 200
elseif y >= 13 then
   print("ryu attack", 1, 58)
   z = 2000
end
cursor(1,1)
print("you")
print("him")
savescr()
while z >= 0 and stats.h >= 0 do
   loadscr()
   cursor(17, 1)
   print(stats.h)
   print(z)
   wait(10)
   stats.h -= flr(9 * rnd())
   z -= flr(3 * rnd()) + stats.k
end
loadscr()
cursor(17, 1)
print(stats.h)
print(z)
cursor(1, 25)
if stats.h < 0 then
   stats.m -= 250
   stats.h = 10
   print("you lost")
else
   z = flr(80 * rnd())
   print("money+" .. z)
   stats.m += z
end
pause()
goto status

::sleepscreen::
clear()
z = 10 - flr(stats.h / 10)
print("rested " .. z .. " days")
stats.d += z
stats.h = 100
pause()
goto status

::clubbingscreen::
clear()
print("how many nights?")
y = numbermenu(true, 1, 7)
if (y == nil or y == 0) goto status

clear()
print("dancing...")
wait(30)
print("breakdancing...")
wait(30)
print("dj'ing...")
wait(30)
z = 0
for x=1,y do
   z += flr(9 * rnd()) + flr(flr(stats.d / 10) * rnd())
   stats.h = flr(stats.h / 2)
end
print("met " .. z .. " people")
pause()
stats.c += z
stats.d += y
stats.m -= 10 * y
goto status

::suescreen::
clear()
z = 90
cursor(1,1)
print("you")
print("him")
savescr()
while y > 0 and z > 0 do
   if (flr(rnd() * 2) == 0) y -= 1
   if (flr(rnd() * 2) == 0) z -= 1

   loadscr()
   cursor(17, 1)
   print(y)
   print(z)
   wait(10)
end
loadscr()
cursor(17, 1)
print(y)
print(z)
cursor(1, 25)

if y > 0 then
   print("you won")
   stats.m += 10 * z + 50
   print("new total " .. stats.m)
else
   print("you lose")
   stats.m -= 10 * z + 50
   print("new total " .. stats.m)
end
pause()
goto status

::claimscreen::
clear()
z = flr(stats.d / 2)
z = 12.5 * z + flr((100 - stats.c) * rnd())
if (z < 250) z = 250

if stats.m < z or stats.d > 365 then
   if stats.m < z then
      print("you don't have the")
      print("money for an attorney")
   else
      print("it's too late")
   end
   pause()
   goto status
end
print("to hire an attorney")
print("it will cost " .. z)
sel = menu({"yes", "no"}, 1, 15)

if (sel == nil) goto status

clear()
if flr(10 * rnd()) == 0 then
   print("your attorney failed")
   print("but refunded a little")
   stats.m -= z / 2
else
   print("you won")
   stats.m -= z
   stats.d = flr(stats.d / 2)
end
pause()
goto status

::endscreen::
if stats.m >= 50000 and stats.d <= 365 then
   clear()
   print("2005 ad...")
   print("sim inc. has become the most")
   print("successful corporation on")
   print("earth. you are its founder.")
   print("you are its ceo. you are...")
   print("the richest man alive.")
   new_stats = {
      m=1000000,
      s=1000,
      h=100,
      c=100,
      d=720,
      k=0,
      p=0.5
   }
   pause()
   if stats.c >= 100 then
      clear()
      print("everyone loves you. you even")
      print("have a fan club and a tv show.")
      print("everyone rushes to buy your")
      print("products and you sell them")
      print("on a global scale.")
      new_stats.c = 30000 --changed to avoid overflow
      pause()
   end
   if stats.k >= 12 then
      clear()
      print("you kick butt. since you have")
      print("mastered 25 forms of martial")
      print("arts, you are also the")
      print("strongest person alive. you")
      print("could level a city with a")
      print("single glance. you no longer")
      print("need weapons or bodyguards")
      print("since you can nuke everyone...")
      new_stats.k = 50
      pause()
   end
   stats = new_stats
   savegame()

   clear()
   print("the end", 50, 30)
   pause()
   --goto mainlogo
else
   --todo: bad ending
end
--what's that weird ending?

clear()
print("this is a test")
print("i did a bunch of stuff")
print("just need some text on screen")
for i=0,7 do
   for r=0,24 do
      memcpy(0x6000 + 256 * r, 0x6000 + 256 * (r + 1), 256)
   end
   flip()
end

camera()

colors = {0, 1, 0xd, 6, 7}
dithermap = {1,13,4,16,9,5,12,8,3,15,2,14,11,7,10,6}
offsets={}
i=0
for r=0,3 do
   for c=0,127 do
      j=(r%4)*4+(c%4)+1
      offsets[i] = (dithermap[j]-1)/16
      i+=1
   end
end

for frame=0,10 do
   i=0
   for r=0,3 do
      for c=0,127 do
         col=(#colors-1)*frame/10+offsets[i]+1
         pset(c, r+64, colors[flr(col)])
         i+=1
      end
   end
   memcpy(0x7100,0x7000,0x100)
   memcpy(0x7200,0x7000,0x200)
   memcpy(0x7400,0x7000,0x400)
   memcpy(0x7800,0x7000,0x800)
   cursor(1, 65)
   color(0)
   print("this is some text commentary")
   flip()
end

pause()


::runscreen::
goto status

__gfx__
00000000ffffffff7f7f7ffffff7f7f7ffffffffffffffff00000000001000000000000000000000000000000000000000000000000000000000000000000000
00000000fffffffff7ffffffffffff7fffffffffffffffff00000000001000000000000000000000000000000000000000000000000000000000000000000000
00700700ffffffff7f7ffffffffff7f7ffffffffffffffff00000000001000000000000000000000000000000000000000000000000000000000000000000000
00077000ffffffffffffffffffffffff7ffffffffffffff711111000001000000000000000000000000000000000000000000000000000000000000000000000
00077000ffffffff7ffffffffffffff7ffffffffffffffff00000000001000000000000000000000000000000000000000000000000000000000000000000000
00700700ffffffffffffffffffffffff7f7ffffffffff7f700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000fffffffffffffffffffffffff7ffffffffffff7f00000000001000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffffffffffffffffff7f7f7ffffff7f7f700000000000000000000000000000000000000000000000000000000000000000000000000000000
01110010000010001001110010001001110011111001110000000011110001110011110011111000000011111000000000000000000000000000000000000000
10001010000010001010001010001000100010000010001000000010001010001010001000100000000000010000000000000000000000000000000000000000
10000010000010001010000010001000100010000010000000000010001010001010001000100000000000100000000000000000000000000000000000000000
01110010000010001001110011111000100011110001110000000011110011111011110000100000000000010000000000000000000000000000000000000000
00001010000010001000001010001000100010000000001000000010000010001010100000100000000000001000000000000000000000000000000000000000
10001010000010001010001010001000100010000010001000000010000010001010010000100000000010001000000000000000000000000000000000000000
01110011111001110001110010001001110011111001110000000010000010001010001000100000000001110000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000100011111000000000110000010000000111000000000000000000000000000001110000000000000000000000000000000000000000000000000000
00110001010000010000000001000000110000001000100000000000000000000010000010001000100010000000000000000000000000000000000000000000
01010010001000100000000010000001010000001000101011000111100000000000000010001000010100111110000000000000000000000000000000000000
10010000000000010000000011110010010000001111101100101000000000001111100001110000001000010100000000000000000000000000000000000000
11111000000000001000000010001011111000001000101000100111000000000000000010001000010100010100000000000000000000000000000000000000
00010000000010001000000010001000010000001000101000100000100000000010000010001000100010010100000000000000000000000000000000000000
00010000000001110000000001110000010000001000101000101111000000000000000001110000000000100110000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110011111000000000100011111001110011111000010000100001110011111000000000000000000000000000000000000000000000000000000000000000
10001010000000000001100000010010001000001000110001100010001000010000000000000000000000000000000000000000000000000000000000000000
00001011110000000000100000100000001000010001010000100000001000100000000000000000000000000000000000000000000000000000000000000000
00010000001000000000100000010000010000100010010000100000010000010000000000000000000000000000000000000000000000000000000000000000
00100000001000000000100000001000100000100011111000100000100000001000000000000000000000000000000000000000000000000000000000000000
01000010001001100000100010001001000000100000010000100001000010001000000000000000000000000000000000000000000000000000000000000000
11111001110001100001110001110011111000100000010001110011111001110000000000000000000000000000000000000000000000000000000000000000
__map__
0201010101010101010101010101010300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0401010101010101010101010101010500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

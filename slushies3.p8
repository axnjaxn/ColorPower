pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--common
--[[
   hey, if you're reading this for cheats,
   that's disappointing!
   but if you're reading it to learn,
   i apologize for the whole thing.
]]--
cartdata("axnjaxn_slushies3")

function clear()
   camera(0,-32)
   cls()
   color(1)
   cursor(1,1)
   map(0,0,0,0,16,16)
end

function pause()
   show_commentary_icon()
   repeat
      flip()
      if (btnp(5)) run_commentary()
   until btnp(4)
   flip()
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
         run_commentary()
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
      elseif btnp(5) then
         run_commentary()
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
   dset(1, bnencode(stats.m))
   dset(2, bnencode(stats.s))
   dset(3, stats.h)
   dset(4, bnencode(stats.c))
   dset(5, stats.d)
   dset(6, stats.k)
   dset(7, stats.p)
end

function loadgame()
   return {
      m=bndecode(dget(1)),
      s=bndecode(dget(2)),
      h=dget(3),
      c=bndecode(dget(4)),
      d=dget(5),
      k=dget(6),
      p=dget(7)
   }
end

-->8
--bignum

function bncreate(num)
   local neg = false
   if num < 0 then
      num = -num
      neg = true
   end
   return {flr(band(num, 0xff)), flr(shr(num, 8)), 0, 0, neg=neg}
end

function bncanextract(bn)
   return bn[2] < 0x80 and bn[3] == 0 and bn[4] == 0
end

function bnextract(bn)
   local num = bn[1] + shl(bn[2], 8)
   if (bn.neg) num = -num
   return num
end

function bnencode(bn)
   local x = shl(bn[4], 8) + bn[3] + shr(bn[2], 8) + shr(bn[1], 16)
   if (bn.neg) x = -x
   return x
end

function bndecode(num)
   local neg = (num < 0)
   if (neg) num = -num
   return {
      band(shl(num, 16), 0xff),
      band(shl(num, 8), 0xff),
      band(num, 0xff),
      flr(shr(num, 8)),
      neg=neg
   }
end

--todo: verify cents
function bn2str(bn, ismoney)
   local neg = bn.neg
   bn.neg = false --this algorithm will "store" the sign to simplify the logic
   local x = bnencode(bn) --exploiting the encoding, which is a 32-bit int
   local y = {0} --this is the "bcd" digits table
   local k --this will be used to store nibble-to-nibble carries

   --this is the double-dabble algorithm to convert the 32-bit int to bcd
   for i = 0, 31 do
      -- add step
      for j=1,#y do
         if (y[j] >= 5) y[j] += 3
      end

      -- shift step
      k = 0
      if (band(x, 0x8000) != 0) k = 1
      x = shl(x, 1)
      for j=1,#y do
         y[j] = shl(y[j], 1) + k
         k = flr(shr(y[j], 4))
         y[j] = band(y[j], 0x0f)
      end
      if (k > 0) add(y, 1) --add digits as necessary
   end

   local cents = 0
   if ismoney then
      cents = y[1]
      if (#y > 1) cents = 10 * y[2] + cents
      if #y > 2 then
         del(y, y[1])
         del(y, y[1])
      else
         y = {0}
      end
   end

   bn.neg = neg --restore the sign
   local s = ""
   for i=1,#y do s = y[i] .. s end
   if (neg) s = "-" .. s
   if (cents > 0) s = s .. "." .. cents

   return s
end

function bnadd(bn, num)
   if ((num < 0) != bn.neg) return bnsub(bn, -num)

   local ans = {neg=bn.neg}
   num = abs(num) --since we've already confirmed it's the same sign

   for i=1,4 do
      num = bn[i] + abs(num)
      ans[i] = band(num, 0xff)
      num = flr(shr(num, 8))
   end

   return ans
end

function bnsub(bn, num)
   if ((num < 0) != bn.neg) return bnadd(bn, -num)

   --this also handles all cases where bn's sign flips
   if bncanextract(bn) then
      return bncreate(bnextract(bn) - num)
   end

   local ans = {neg=bn.neg}
   num = abs(num) --all sign flipping is already handled

   for i=1,4 do
      ans[i] = bn[i] - band(num, 0xff)
      if ans[i] < 0 then
         ans[i] += 0x100
         num += 0x100
      end
      num = flr(shr(num, 8))
   end

   return ans
end

function bnmul(bn, num)
   local neg = bn.neg
   if (num < 0) neg = not neg
   num = abs(num)

   local lo, pplo, clo = band(num, 0xff), {neg=neg}, 0
   local hi, pphi, chi = flr(shr(num, 8)), {neg=neg}, 0

   for i=1,4 do
      clo = bn[i] * lo + clo
      pplo[i] = band(clo, 0xff)
      clo = band(shr(clo, 8), 0xff)

      chi = bn[i] * hi + chi
      pphi[i + 1] = band(chi, 0xff)
      chi = band(shr(chi, 8), 0xff)
   end
   pphi[5] = nil
   pphi[1] = 0

   return bnbnadd(pplo, pphi)
end

--this is used in the code exactly once:
--it divides by a multiple of 5 between 10 and 50 inclusive
function bndiv(bn, num) --num must be positive
   local ans={neg=bn.neg}
   local sum, carry = 0, 0

   for i=4,1,-1 do
      sum = bn[i] + shl(carry, 8)
      ans[i] = flr(sum / num)
      carry = sum % num
   end

   return ans
end

function bnbnabsgr(bn1, bn2)
   for i=4,1,-1 do
      if (bn1[i] > bn2[i]) return true
      if (bn1[i] < bn2[i]) return false
   end
   return false
end

function bnbnadd(bn1, bn2)
   local ans

   if bn1.neg != bn2.neg then
      bn2.neg = not bn2.neg
      ans = bnbnsub(bn1, bn2)
      bn2.neg = not bn2.neg
      return ans
   end

   ans = {neg=bn1.neg}
   local num = 0

   for i=1,4 do
      num = bn1[i] + bn2[i] + num
      ans[i] = band(num, 0xff)
      num = flr(shr(num, 8))
   end

   return ans
end

function bnbnsub(bn1, bn2)
   local ans

   if bn1.neg != bn2.neg then
      bn2.neg = not bn2.neg
      ans = bnbnadd(bn1, bn2)
      bn2.neg = not bn2.neg
      return ans
   end

   ans = {neg = bn1.neg}

   --avoid flips of sign later in the function
   if bnbnabsgr(bn2, bn1) then
      bn1, bn2 = bn2, bn1
      ans.neg = not ans.neg
   end

   local borrow = 0

   for i=1,4 do
      ans[i] = bn1[i] - bn2[i] - borrow
      if ans[i] < 0 then
         borrow = 1
         ans[i] += 0x100
      else
         borrow = 0
      end
   end

   return ans
end

function bnisneg(bn)
   return bn.neg
end

--maximum num: 7
function bnshr(bn, num)
   local ans, x = {neg=bn.neg}, 0

   for i=4,1,-1 do
      x = shr(bn[i], num) + band(shl(x, 8), 0xff)
      ans[i] = flr(x)
   end

   return ans
end

--only positive values for bn
function bnrnd(bn)
   local lead = true
   local ans={0,0,0,0,neg=false}

   for i=4,1,-1 do
      if lead then
         if bn[i] > 0 then
            ans[i] = flr(rnd(bn[i]))
            lead = false
         end
      else
         ans[i] = flr(rnd(0x100))
      end
   end

   return ans
end

--not really a bn but whatever
function dateadd(d, x)
   if (d == 0x7fff) return 0x7fff
   return d+x
end

function date2str(d)
   if (d == 0x7fff) return "1000000+"
   return tostr(d)
end

function test(a, b, name)
   if (a == b) return nil
   clear()
   print("failed test " .. name)
   print("expected " .. b)
   print("got " .. a)
   while true do end
end

-->8
--commentary system
function count_commentaries_seen()
   local count = 0
   for i=8,63 do
      if (dget(i) > 0) count += 1
   end
   return count
end
   
commentary = nil
function register_commentary(pages, id, hidden_icon)
   if (hidden_icon == nil) hidden_icon = false
   commentary = {
      pages = pages,
      id = id,
      hidden_icon = hidden_icon
   }
end

function show_commentary_icon()
   if (not commentary or commentary.hidden_icon --[[or dget(commentary.id) > 0]]) return
   spr(57, 60, 88)
end

function split(s, x1, x2)
   n = flr((x2 - x1 + 1) / 4)
   if (#s <= n) return s, nil
   for i=1,n do
      if sub(s, i, i) == "\n" then
         return sub(s, 1, i-1), sub(s, i+1, -1)
      end
   end
   for i=n, 1, -1 do
      if sub(s, i, i) == " " then
         return sub(s, 1, i-1), sub(s, i+1, -1)
      end
   end
end

function printmulti(s, x1, x2, y, centered)
   if (centered == nil) centered = true
   
   local line
   local x = x1
   while s != nil do
      line, s = split(s, x1, x2)
      if centered then
         while sub(line, -1, -1) == " " do
            line = sub(line, 1, -2)
         end
         x = x1 + 0.5 * (x2 - x1) - 2 * #line
      end
      print(line, x, y)
      y += 6
   end
end

function clear_commentary()
   commentary = nil
end

function run_commentary()
   if (commentary == nil) return
   
   --animate screen slide upwards
   rectfill(0,64,127,127,0)
   for i=0,7 do
      for r=0,24 do
         memcpy(0x6000 + 256 * r, 0x6000 + 256 * (r + 1), 256)
      end
      flip()
   end
   camera()

   --set up dither pattern (four rows long)
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

   --animate dithered fade in background
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
      flip()
   end

   --avatar
   palt(0,false)
   palt(11, true)
   spr(12, 2, 67, 4, 8)
   pal()
   palt()

   --and text
   pageno = 1
   while pageno <= #commentary.pages do
      rectfill(37, 67, 127, 127, 7)
      color(0)
      printmulti(commentary.pages[pageno], 37, 128, 67)
      flip()
      while true do
         if btnp(0) or btnp(2) or btnp(5) then
            pageno = max(1, pageno - 1)
            break
         elseif btnp(1) or btnp(3) or btnp(4) then
            pageno = pageno + 1
            break
         end
         flip()
      end
   end
   
   --animate out dither
   for frame=10,0,-1 do
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
      flip()
   end

   --and slide
   for i=0,7 do
      for r=24,0,-1 do
         memcpy(0x6000 + 256 * (r + 1), 0x6000 + 256 * r, 256)
      end
      rectfill(0, 0, 127, 3, 0)
      flip()
   end
   camera(0,-32)

   dset(commentary.id, 1)
end

-->8
--main game implementation
cls()
color(7)
camera(0, -32)
printmulti("the following game was developed and released "
              .. "on the casio graphing calculator series "
              .. "in november 2003.",
           0, 127, 0, true)
printmulti("the gameplay and mechanics  have been retained, "
              .. "completely unrevised and unimproved,\nfrom the original.",
           0, 127, 30, true)
printmulti("press \142 (z key) to continue",
           0, 127, 60, true)
pause()

register_commentary({"very clever!\n"
                     .. "i tried to think of a good easter egg for this screen, "
                     .. "but i was so proud of myself for thinking of it "
                        .. "(and so very proud of you!)",
                     "that i could not come up with anything other than "
                        .. "to say:\n\ncongratulations\nto you, "
                        .. "my very special player,",
                     "the hero of the story and the one for whom "
                     .. "slushies would have been written, if i had only known back in high school "
                     .. "that the year 2020 would eventually come and you would be here in it with me."
                    }, 63, true)

cls()
camera(0, -32)
printmulti("use \139\148\131\145 (arrow keys)",
           0, 111, 0, true)--adjust r margin by four per symbol to keep centering correct
printmulti("to navigate,",
           0, 127, 6, true)
printmulti("use \142 (z key) to select,",
           0, 123, 18, true)
printmulti("and use \151 (x key)",
           0, 127, 30, true)
printmulti("when you see this:",
           0, 127, 36, true)
spr(57, 60, 42)
printmulti("to activate the game's\npop-up commentary",
           0, 127, 51, true)
pause()

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

n = count_commentaries_seen()
if n > 0 then
   s = n .. "/" .. 2
   s = (100 * n/2) .. "%"
   print(s, 121-4*#s, 51, 7)
end

sel = menu(m, 8, 16, #m-1)

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
      m = bncreate(10000),
      s = bncreate(0),
      h = 100,
      c = bncreate(10),
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
print(bn2str(stats.m, true),45,15)
print(bn2str(stats.s),45,21)
print(stats.h,45,27)
print(bn2str(stats.c),45,33)
print(date2str(stats.d),45,39)
print(bn2str(bncreate(100 * stats.p), true),45,45)

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
   elseif btnp(5) then
      run_commentary()
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

::supplymenu::
clear()
heading("supply")
sel=menu({"buy","price","steal","eat","back"})

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
sel=menu({"dojo","street","back"})

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
sel=menu({"sleep","clubbing","back"})

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
sel=menu({"sue competitors","file a claim","back"})

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

if y == 0 then
   y = bndiv(bndiv(stats.m, 100), z)--yes, this is awful, but it allows bndiv to be simpler
else
   y = bncreate(y)
end

z = bnbnsub(stats.m, bnmul(y, z * 100))
if bnisneg(z) then
   clear()
   print("not enough")
   pause()
else
   stats.m = z
   stats.s = bnbnadd(stats.s, bnmul(y, 50))
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
stats.c = bnsub(stats.c, y)
if (bnisneg(stats.c)) stats.c = bncreate(0)
stats.p = z
goto status

::stealscreen::
clear()
print("stealing...")
wait(60)
y = flr(3 * rnd())
stats.d = dateadd(stats.d, 1)
if y == 0 then
   print("success!")
   z = 5 * flr(10 * rnd()) + 5
   wait(30)
   print("stole " .. z .. " slushies")
   stats.s = bnadd(stats.s, z)
elseif y == 1 then
   print("success!")
   print("but the slushies were")
   print("contaminated and")
   print("some customers left")
   stats.c = bnsub(stats.c, flr(9 * rnd()))
   if (bnisneg(stats.c)) stats.c = bncreate(0)
else
   print("you were caught,")
   print("paid a fine, and spent")
   print("two weeks in jail")
   stats.m = bnsub(stats.m, 20000)
   stats.d = dateadd(stats.d, 14)
   stats.h = 50
end
pause()
goto status

::eatscreen::
clear()
print("eat how many?")
sel = menu({"25", "50", "full", "cancel"}, 1, 9)
if sel == nil then
   goto status
elseif sel == 1 then
   z = 25
elseif sel == 2 then
   z = 50
elseif sel == 3 then
   z = 100 - stats.h
else
   goto status
end
if (z > 100 - stats.h) z = 100 - stats.h
y = bnsub(stats.s, z)
if bnisneg(y) then
   stats.s = bncreate(0)
   stats.h += bnextract(stats.s)
else
   stats.s = y
   stats.h += z
end
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
      print("day " .. date2str(dateadd(stats.d, z)))
      wait(2)
   end
   print("level up!")
   stats.d = dateadd(stats.d, y)
   stats.k += 1
   stats.h -= 45
   stats.c = bnsub(stats.c, 1)
   if (bnisneg(stats.c)) stats.c = bncreate(0)
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
   stats.m = bnsub(stats.m, 25000)
   stats.h = 10
   print("you lost")
else
   z = flr(80 * rnd())
   print("money+" .. z)
   stats.m = bnadd(stats.m, z * 100)
end
pause()
goto status

::sleepscreen::
clear()
z = 10 - flr(stats.h / 10)
print("rested " .. z .. " days")
stats.d = dateadd(stats.d, z)
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
z = bncreate(0)
for x=1,y do
   z = bnadd(z, flr(9 * rnd()) + flr(flr(stats.d / 10) * rnd()))
   stats.h = flr(stats.h / 2)
end
print("met " .. bn2str(z) .. " people")
pause()
stats.c = bnbnadd(stats.c, z)
stats.d = dateadd(stats.d, y)
y = bnmul(bncreate(y), 1000)
stats.m = bnbnsub(stats.m, y)
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
   stats.m = bnbnadd(stats.m, bnmul(bncreate(10 * y + 50), 100))
else
   print("you lose")
   if (z < 0) z = 0
   stats.m = bnbnsub(stats.m, bnmul(bncreate(10 * z + 50), 100))
end
print("new total " .. bn2str(stats.m, true))
pause()
goto status

::claimscreen::
clear()
z = 12.5 * flr(stats.d / 2)
y = bnadd(bnmul(stats.c, -1), 100)
if (not bnisneg(y)) z += flr(bnextract(y) * rnd())
if (z < 250) z = 250
z = flr(z)
z = bnmul(bncreate(z), 100)

if bnisneg(bnbnsub(stats.m, z)) or stats.d > 365 then
   if stats.d > 365 then
      print("it's too late")
   else
      print("you don't have the")
      print("money for an attorney")
   end
   pause()
   goto status
end
print("to hire an attorney")
print("it will cost " .. bn2str(z, true))
sel = menu({"yes", "no"}, 1, 15)

if (sel != 1) goto status

clear()
if flr(10 * rnd()) == 0 then
   print("your attorney failed")
   print("but refunded a little")
   stats.m = bnbnsub(stats.m, bnshr(z, 1))
else
   print("you won")
   stats.m = bnbnsub(stats.m, z)
   stats.d = flr(stats.d / 2)
end
pause()
goto status

::endscreen::
z = bnbnsub(stats.m, bnmul(bncreate(10000), 500))
if not bnisneg(z) and stats.d <= 365 then
   clear()
   print("2005 ad...")
   print("sim inc. has become the most")
   print("successful corporation on")
   print("earth. you are its founder.")
   print("you are its ceo. you are...")
   print("the richest man alive.")
   new_stats = {
      m=bnmul(bncreate(10000), 10000),
      s=bncreate(1000),
      h=100,
      c=bncreate(100),
      d=720,
      k=0,
      p=0.5
   }
   pause()
   if not bnisneg(bnsub(stats.c, 100)) then
      clear()
      print("everyone loves you. you even")
      print("have a fan club and a tv show.")
      print("everyone rushes to buy your")
      print("products and you sell them")
      print("on a global scale.")
      new_stats.c = bnmul(bncreate(1000), 1000)
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
elseif stats.d > 720 then
   --weird ending
   clear()
   print("the time machine lies")
   print("unused in your garage. you")
   print("turn it on and it glows a soft")
   print("blue. you step in...")
   print("")
   print("you step out in the future.")
   print("your customers are somehow")
   print("different now, though.")
   z = bnmul(bncreate(1000), 1000)
   if bnisneg(bnbnsub(stats.c, z)) then
      z = bnbnsub(z, stats.c)
      stats.m = bnbnsub(stats.m, bnmul(z, 500))
      stats.d = 0x7fff -- modified since this is so frequently out of range
      stats.c = bnmul(bncreate(1000), 1000)
   end
   pause()
else
   clear()
   print("2005 ad...")
   print("you are broke. the work you")
   print("did in the past was too")
   print("little, too late. you lose.")
   --one departure from the original version is:
   --i don't want to zero all the stats here
   pause()
end

goto mainlogo

::runscreen::
clear()
y = flr(10 * rnd()) - 5
if y == 1 then
   print("some slushies melted")
   z = bnrnd(bnshr(stats.s, 2))
   stats.s = bnbnsub(stats.s, z)
   print("you lost " .. bn2str(z))
elseif y == 2 then
   print("some customers got")
   print("sick of slushies")
   z = bnrnd(bnshr(stats.c, 2))
   print("you lost " .. bn2str(z))
   stats.c = bnbnsub(stats.c, z)
elseif y == 3 then
   print("arnold used his")
   print("california governor")
   print("influence to hurt the")
   print("slushie business when")
   print("he bought one.")
   if stats.k >= 40 and flr((55 - stats.k) * rnd()) <= 5 then
      print("he bought one...",1,25)
      pause()
      clear()
      print("but you opened a can")
      print("of whoopin on his")
      print("butt and took his")
      print("wallet.")
      stats.m = bnbnadd(stats.m, bnmul(bncreate(10), 100 * flr(200 * rnd())))
   else
      stats.s = bnbnsub(stats.s, bnshr(bnrnd(stats.s), 1))
      stats.c = bnsub(stats.c, flr(15 * rnd()))
      if (bnisneg(stats.c)) stats.c = bncreate(0)
   end
elseif y == 4 then
   print("a french german")
   print("baptist catholic nazi")
   print("pirate nun slapped")
   print("you with a ruler.")
   stats.h -= 5
   if stats.k >= 12 then
      print("you with a ruler...", 1, 19)
      pause()
      clear()
      print("but you defended")
      print("yourself and k.o.'ed")
      print("her.")
      stats.h += 5
      stats.c = bnadd(stats.c, 1)
   end
else
   print("you sold a slushie to")
   z = bnrnd(stats.c)
   if (bnisneg(bnbnsub(stats.s, z))) z = stats.s
   print(bn2str(z))
   print("customers")
   stats.m = bnbnadd(stats.m, bnmul(z, stats.p * 100))--todo
   stats.s = bnbnsub(stats.s, z)
end
cursor(1, 31)
print("slushies=" .. bn2str(stats.s))
print("day " .. date2str(stats.d))
--adjusted from original:
-- it's weird that it automatically sent you to end game
-- on day 365 if you run, given that you skip it otherwise
-- (using the days any other way)
stats.d = dateadd(stats.d, 1)
sel = menu({"continue", "    back"}, 96, 50)
if (sel == 1) goto runscreen

goto status

__gfx__
00000000ffffffff7f7f7ffffff7f7f7ffffffffffffffff000000000010000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbb55fbbbbbbbbb
00000000fffffffff7ffffffffffff7fffffffffffffffff000000000010000000000000000000000000000000000000bbbbbbbbbbbbbbbbbb555555fbbbbbbb
00700700ffffffff7f7ffffffffff7f7ffffffffffffffff000000000010000000000000000000000000000000000000bbbbbbbbbbbbbbbf5515555555ffbbbb
00077000ffffffffffffffffffffffff7ffffffffffffff7111110000010000000000000000000000000000000000000bbbbbbbbbbbbbf55151555555ff5fbbb
00077000ffffffff7ffffffffffffff7ffffffffffffffff000000000010000000000000000000000000000000000000bbbbbbbbbbbf55115115155555f7fbbb
00700700ffffffffffffffffffffffff7f7ffffffffff7f7000000000000000000000000000000000000000000000000bbbbbbbbbb50151510111155555fbbbb
00000000fffffffffffffffffffffffff7ffffffffffff7f000000000010000000000000000000000000000000000000bbbbbbbbb50551110011111115555bbb
00000000ffffffffffffffffffffffff7f7f7ffffff7f7f7000000000000000000000000000000000000000000000000bbbbbbbbb015101011111115555f5fbb
011100100000100010011100100010011100111110011100000000111100011100111100111110000000111110000000bbbbbbbb50155555555555555555f5bb
100010100000100010100010100010001000100000100010000000100010100010100010001000000000000100000000bbbbbbbb505444444444ffff45555fbb
100000100000100010100000100010001000100000100000000000100010100010100010001000000000001000000000bbbbbbf515eeefffffffffffff4555bb
011100100000100010011100111110001000111100011100000000111100111110111100001000000000000100000000bbbbb5005fe4ffffffffffff777555bb
000010100000100010000010100010001000100000000010000000100000100010101000001000000000000010000000bbbb5005e4eeefffffffffffff7f55fb
100010100000100010100010100010001000100000100010000000100000100010100100001000000000100010000000bbbf0114fe44eeffffffffffff77f15b
011100111110011100011100100010011100111110011100000000100000100010100010001000000000011100000000bbb51054e44e4efffffffffff7777515
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbb1105e4eeeeefefffffffff7777f55
000100001000111110000000001100000100000001110000000000000000000000000000011100000000000000000000bbf0505e44e4eeffffffffff77777745
001100010100000100000000010000001100000010001000000000000000000000100000100010001000100000000000bb501144ee4eeeefffffffff777777f5
010100100010001000000000100000010100000010001010110001111000000000000000100010000101001111100000bb51514ee4efefffffffffff777777f5
100100000000000100000000111100100100000011111011001010000000000011111000011100000010000101000000bb5515444eefffffffffffffff7777f5
111110000000000010000000100010111110000010001010001001110000000000000000100010000101000101000000bb51154e4eeee4fffffffffff77777f5
000100000000100010000000100010000100000010001010001000001000000000100000100010001000100101000000bf015544e4555155ef7fffffffff77f5
000100000000011100000000011100000100000010001010001011110000000000000000011100000000001001100000bf01554e451155155effffff45555ff1
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b50155445544444444fffffef5555555
011100111110000000001000111110011100111110000100001000011100111110000000077777000000000000000000b50155445445455544eefffff44eff55
1000101000000000000110000001001000100000100011000110001000100001000000007ccacc600000000000000000b5011544444555555544f7f455445f55
0000101111000000000010000010000000100001000101000010000000100010000000007ccacc600000000000000000b4011544455101555544f7f5555fff55
0001000000100000000010000001000001000010001001000010000001000001000000007ccacc600000000000000000b41114e4444555f54444f74550154f5f
0010000000100000000010000000100010000010001111100010000010000000100000007ccccc600000000000000000b45014e44444ee455444f7f555574ffb
0100001000100110000010001000100100000010000001000010000100001000100000007ccacc600000000000000000f45154e44eee44444444ff7f44ff7ffb
111110011100011000011100011100111110001000000100011100111110011100000000066666000000000000000000f44154e4eefffffe444eff77fffff7fb
000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000f44514e4e4ffffe4444eff77777777fb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f42554e4eeefffe44444ef777f7777fb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f44455e4eeffff4e4444ef777f77777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f44455e4eeeffe44444eff77ff77777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b444554e4efee4444e4ef777fef7777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bb445544e4ee44444e44f77774e7777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbf55e4444444444444ef777f4f777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbf5444445444455544fff77fe777b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbf544e4555555555555e4ffff77fb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbf5444455554554444554ff5577fb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbf15444555154444ee44f5455ff5b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbb154444542554e4eff7f5e54f55b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbb5054445444245f777f47f5ff55b
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbf015445444444effeef7f4f55fb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbf00155554444eeeee777ef555bb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbf110155554444eeeef7f4451fbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb501055554445554ff745555bbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb10111555444554fff5555fbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb50011555545455ee55551fbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbf0111555555454555555bbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbb5001115554445555555bbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbb501115555555555515bbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbb5000155555555551bbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbb500115555551105bbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbb1000155551015bbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbb5000151101fbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbff555ffbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
__map__
0201010101010101010101010101010300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0401010101010101010101010101010500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

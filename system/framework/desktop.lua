os.pullEvent = os.pullEventRaw


local width = kernel.x
local height = kernel.y

appsdir = "system/apps"
appsfle = "system/.appdata"
gridsze = 5 --x=gridsze*c[x]+1
dbclk = 0.6

asel = 0
lclk = os.clock()
grid = false

function getGridMax()
 return math.floor(width/gridsze),math.floor(height/gridsze)
end

function isTaken(x,y)
 for k,v in pairs(apps) do
  if apps[k].x==x and apps[k].y==y then
   return true
  end
 end
 return false
end

function saveInfo()
 kernel.saveToFile(apps,"system/.appdata")
end

local function mainDesktop()

local function getIcons()
 apps = {}
 local m = fs.open(appsfle,"r")
 apps = textutils.unserialize(m.readAll())
 m.close()
end
getIcons()

n = {  }
local isAppOpen = false
local redraw = false


isUnstable = true
build = "27"
fullBuildName = "DeltaOS Unstable(build "..build..")"

os.loadAPI("/apis/users")


local function getC()
 return term.current()
 
end

local gc = getC()



graphics.drawImage("/system/media/delta.nfp", 1, 1)

local lw
if kernel.x>32 then
	lw = window.create( term.current(), kernel.x/2-30/2, kernel.y/2-10/2, 30, 10, true )
else
	lw = window.create( term.current(), kernel.x/2-(kernel.x-2)/2+1, kernel.y/2-10/2, (kernel.x-2), 10, true )
end

term.redirect(lw)


local latestBuild = http.get("https://raw.githubusercontent.com/FlareHAX0R/deltaOS-unstable/master/version")
if latestBuild:readAll() > build then
	read()
 shell.run("/system/update")
end

while true do
graphics.reset(colors.white, colors.black)

graphics.cPrint("DeltaOS login")
print("")
graphics.cPrint("Username:")

local ww, wh = lw.getSize()

paintutils.drawLine( 2, 4, ww-1, 4, colors.lightGray )

print("")
lw.setBackgroundColor(colors.white)
term.setCursorPos(1, 7)
graphics.cPrint("Password: ")
paintutils.drawLine( 2, 9, ww-1, 9, colors.lightGray )

term.setCursorPos(2, 4)
local user = tostring( read() )


term.setCursorPos(2, 9)
local pass = tostring( sha256.hash(read("*")) )


if users.isUser(user) == true and pass == users.getPassword(user) then
	local cw, ch = lw.getSize()
	graphics.reset(colors.white, colors.black)
	lw.setCursorPos(1, ch/2)
	graphics.cPrint("Logging in user")
	graphics.cPrint(user.."...")
	sleep(0.6)
	users.login(user)
	lw.setVisible(false)
	term.redirect( term.native() )
	animations.wake()
else
	local cw, ch = lw.getSize()
	graphics.reset(colors.white, colors.black)
	lw.setCursorPos(1, 2)
	graphics.cPrint("Login failed.")
	print("")
	lw.setCursorPos(1, ch/2)
	if users.isUser(user) and users.getPassword(user) == false then
		graphics.cPrint("Password incorrect.")
		sleep(0.6)
		os.reboot()
	elseif users.isUser(user) == false then
		graphics.cPrint("No such user.")
		sleep(0.6)
		os.reboot()
	else
		graphics.cPrint("Unknown Error.")
		sleep(0.6)
		os.reboot()
	end
end
--end
	




dofile("/system/sApi/dialog")


local function drawBar()
	graphics.drawLine(1, colors.lightGray)

	term.current().setCursorPos( kernel.x-(kernel.x-1), kernel.y-(kernel.y-1))

	term.current().write("D")
end

local function findSpace(elim)
 --TODO; MAKE DIS
 local tx,ty = getGridMax()
 for i=1,tx do
  for j=1,ty do
   if not isTaken(i,j) then
    return true,i,j
   end
  end
 end
 return false
end

local function drawApps()
 --Format apps
 --icon,name,exec,x,y
 for k,v in pairs(apps) do
--  print(apps[k][4])
--  print(apps[k][5])
  local gx,gy = getGridMax()
  if apps[k].x>gx or apps[k].y>gy then
   local _,tx,ty = findSpace(k)
   if _ then
    apps[k].x=tx
    apps[k].y=ty
    saveInfo()
   end
  end
--====================================================================================
  graphics.drawImage(apps[k].icon,(apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+3)
  term.setCursorPos((apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+6)
  term.setBackgroundColor(asel==k and colors.blue or colors.lightBlue)
  write(string.rep(" ",gridsze-1))
  term.setCursorPos((apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+6)
  write(apps[k].name:sub(1,gridsze-1))
 end
end

local function drawGrid()
 term.setBackgroundColor(colors.lightBlue)
 for i=1,math.floor(width/gridsze)+1 do
  for j=2,height do
   term.setCursorPos((i-1)*gridsze+1,j)
   write("|")
  end
 end
 for i=1,math.floor(height/gridsze)+1 do
  term.setCursorPos(1,(i-1)*gridsze+2)
  write(string.rep("-",width))
 end
end

local function draw(ua)
graphics.reset( colors.lightBlue, colors.black )
term.current().setCursorPos(kernel.x-(kernel.x-1), 1)
if ua==nil then ua=true end
drawBar()
if ua then getIcons() end
if grid then drawGrid() end
drawApps()

if isUnstable then
 term.current().setBackgroundColor( colors.lightBlue )
 term.current().setCursorPos(kernel.x-string.len(fullBuildName), kernel.y)
 write(fullBuildName)
 term.current().setCursorPos(1, 1)
end

end







--os.loadAPI("/system/tabserv")

draw()

local function timeout(s)
 sleep(s)
 return true
end

local function rtz(n)
 if n<0 then return 0 else return n end
end

local function dragIcon(iID)
 if apps[iID] then
  local ids
  while ids~=1 do
   ids=parallel.waitForAny(function() timeout(0.15) end,
   function()
    local _,_,x,y = os.pullEvent("mouse_drag")
    local tpx = rtz(math.floor((x-1)/gridsze))+1
    local tpy = rtz(math.floor((y-2)/gridsze))+1
    local gx,gy = getGridMax()
    if not isTaken(tpx,tpy) and tpx<=gx and tpy<=gy then
     apps[iID].x=tpx
     apps[iID].y=tpy
    end
   end)
   draw(false)
  end
  saveInfo()
  return true
 else
  return false
 end
end

--[[
function isTaken(x,y)
 for k,v in pairs(apps) do
  if apps[k]["x"]==x and apps[k]["y"]==y then
   return true 
  end
 end
 return false
end
]]--

--function getGridMax()
-- local x,y = kernal.x,kernal.y
-- return math.floor(x/gridsze),math.floor(y/gridsze)
--end

local function shellServ() 
while true do
 local e,b,x,y = os.pullEvent()
 if e=="mouse_click" or e=="mouse_drag" then
	if x==kernel.x-(kernel.x-1) and y==kernel.y-(kernel.y-1) and b==2 then
		local d = Dialog.new(nil, nil, nil, nil, "DeltaOS", {"Do you want to", "shutdown?"}, true,true)
		if d:autoCaptureEvents() == "ok" then
			draw()
			animations.closeIn()
			graphics.reset(colors.black, colors.white)
			--term.setCursorPos(1, 2)
			--isAppOpen = true
			--print("Run 'exit' to go back to deltaOS")
			--shell.run("/rom/programs/shell")
   saveInfo()
   os.shutdown()
			--isAppOpen = false
			--animations.wake()
			--draw()
		else
			
			draw()
		end
	else
  local found = false
  for k,v in pairs(apps) do
   local xs,ys = (apps[k].x-1)*gridsze,(apps[k].y-1)*gridsze
   --local xs,ys = 3,4
   --print(kernal.inSpan) read()
   
   if kernel.inSpan(xs+2,ys+3,xs+5,ys+6,x,y) then
    if e=="mouse_drag" then
     if asel~=k then asel=k;draw(false) end
     dragIcon(k)
    else
     if asel==k then
      if os.clock()-lclk<=dbclk then
       animations.closeIn()
       graphics.reset(colors.black,colors.white)
       shell.run(apps[k]["exec"])
       if grid then drawGrid() end
       animations.wake()
       draw()
      end
     else
      asel=k
      draw()
     end 
     lclk=os.clock()
    end
    found=true
    break
   end
  end
  if not found then
   asel=0
   draw()
  end
  end
 elseif e=="key" then
  if b==67 then
   grid = not grid
   draw()
  end
 end
 end
end



local function sleepServ()
 while true do
 	local event, key = os.pullEvent("key")
 	if key == 59 then
 		animations.sleep()
 		local event = os.pullEvent()
 		if event == "key" or event == "mouse_click" or event == "monitor_touch" then
 			os.sleep(0.1)
 			animations.wake()
 			os.sleep(0.1)
 			draw()
 		end
 	end
 end
end



local function rServ()
	while true do
		local event = os.pullEvent()
		if event == "term_resize" or event == "monitor_resize" then
			draw()
		end
	end
end






parallel.waitForAll(sleepServ, shellServ, rServ)
end

end


local err = kernel.catnip(mainDesktop)
if err ~= "noErr" then 
  graphics.reset(colors.blue, colors.white)
  print("")
  term.current().setTextColor(colors.black)
  term.current().setBackgroundColor(colors.white)
  graphics.cPrint("DeltaOS")
  term.current().setBackgroundColor(colors.blue)
  term.current().setTextColor(colors.white)
  print("")
  graphics.cPrint("An error has occured.")
  graphics.cPrint("The error is: "..tostring(x))
  print("")
  graphics.cPrint("Please report this error to ")
  graphics.cPrint("the deltaOS repo.")
  print("")
  graphics.cPrint("DeltaOS Unstable repo: ")
  graphics.cPrint("https://github.com/FlareHAX0R/deltaOS-unstable")
  print("")
  graphics.cPrint("DeltaOS Stable repo: ")
  graphics.cPrint("https://github.com/FlareHAX0R/deltaOS")
  print("")
  graphics.cPrint("Press any key to continue.")
  while true do
     local event = os.pullEvent()
     if event == "key" or event == "monitor_touch" then
       os.reboot()
     end
  end
end

--mainDesktop()  

kernel.saveToFile(apps,"system/.appdata")

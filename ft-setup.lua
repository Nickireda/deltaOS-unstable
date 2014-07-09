
local function setup()
  local function pocketDetect()
  if pocket then
    graphics.reset(colors.lighBlue, colors.white)
    print("")
    graphics.cPrint("WARNING")
    print("")
    print("We have detect you are running on a PDA.")
    print("DeltaOS may be buggy on PDA's")
    print("This may be fixed in the future.")
    
    paintutils.drawLine(2, kernel.y/2, kernel.x-1, kernel.y/2, colors.blue)
    
    paintutils.drawLine(2, kernel.y/2+3, kernel.x-1, kernel.y/2+3, colors.blue)
    
    term.setCursorPos(2, kernel.y/2+3)
    print("Uninstall DeltaOS")
    
    term.setCursorPos(2, kernel.y/2)
    print("Continue anyways...")
    
    while true do
      local e, b, x, y = os.pullEvent("mouse_click")
      if y == kernel.y/2 and x >= 2 and x <= kernel.x-1 then
        return
      elseif y == kernel.y/2+3 and x >= 2 and x <= kernel.x-1 then
        fs.delete("/apps")
        fs.delete("/system")
        fs.delete("/users")
        fs.delete("/startup")
        fs.delete("/apis")
        os.reboot()
      end
  end
end

pocketDetect()
    
  
  
  
graphics.reset(colors.lightGray, colors.black)
graphics.cPrint("DeltaOS first-time setup")


print("")
graphics.cPrint("I. User setup")
print("")

paintutils.drawLine(2, kernel.y/2, kernel.x-1, kernel.y/2, colors.gray)

paintutils.drawLine(2, kernel.y/2+4, kernel.x-1, kernel.y/2+4, colors.gray)

term.setCursorPos(1, kernel.y/2-1)
term.setBackgroundColor(colors.lightGray)


graphics.cPrint("Username:")

term.setCursorPos(1, kernel.y/2+3)

graphics.cPrint("Password: ")

term.setCursorPos(2, kernel.y/2)
term.setBackgroundColor(colors.gray)
local user = read()

term.setCursorPos(2, kernel.y/2+4)

local pass = sha256.hash( read("*") )

users.newUser(user, pass)

graphics.reset(colors.lightGray, colors.black)

graphics.cPrint("DeltaOS first-time setup")
print("")
graphics.cPrint("II. Computer name")

paintutils.drawLine(2, kernel.y/2, kernel.x-1, kernel.y/2, colors.gray)


term.setCursorPos(1, kernel.y/2-2)

term.setBackgroundColor(colors.lightGray)

graphics.cPrint("Computer label/name: ")

term.setCursorPos(2, kernel.y/2)

term.setBackgroundColor(colors.gray)

local label = read()

os.setComputerLabel(label)

graphics.reset(colors.lightGray, colors.black)

graphics.reset(colors.lightGray, colors.black)



graphics.reset(colors.lightGray, colors.black)
graphics.cPrint("First time setup is finished.")
graphics.cPrint("DeltaOS will reboot.")
sleep(0.6)
fs.delete("/system/.setup_trigger")
os.reboot()
end

local x = kernel.catnip(setup)
if x ~= "noErr" or x ~= "nil" then 
  graphics.reset(colors.blue, colors.white)
  print("")
  term.setBackgroundColor(colors.white)
  term.setBackgroundColor(colors.black)
  graphics.cPrint("DeltaOS")
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.black)
  print("")
  graphics.cPrint("An error has occured.")
  graphics.cPrint("The error is: "..x)
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
     if event == "key" or "mouse_click" or "monitor_touch" then
       os.reboot()
     end
  end
end
  
  
  



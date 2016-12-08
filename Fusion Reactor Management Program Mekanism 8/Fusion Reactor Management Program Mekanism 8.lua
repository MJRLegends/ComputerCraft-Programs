----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.0.3"

mouseWidth = 0
mouseHeight = 0
rodNumber = 0
rodLevel = 0

monitor = peripheral.wrap("monitor_0")
reactor = peripheral.wrap("mekanism_machine_0")
laser = peripheral.wrap("mekanism_machine_1") -- Front laser/closet to the reactor, of the lasers required to start the reactor

setting = false

function draw_line(x, y, length, color)
	monitor.setBackgroundColor(color)
	monitor.setCursorPos(x,y)
	monitor.write(string.rep(" ", length))
end

function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
	draw_line(x, y, length, bg_color) --backgoround bar
	local barSize = math.floor((minVal/maxVal) * length)
	draw_line(x, y, barSize, bar_color)     --progress so far
end

function draw_text(x, y, text, text_color, bg_color)
	monitor.setBackgroundColor(bg_color)
	monitor.setTextColor(text_color)
	monitor.setCursorPos(x,y)
	monitor.write(text)
end

function drawControlScreen()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.blue)
    term.setCursorPos(1,1)
    term.write("MJRLegends Fusion Reactor Management")
    term.setCursorPos(1,2)
    term.write("Version: " .. version)
	monitor.setTextScale(1)
	monitor.clear()
	active = reactor.isIgnited()
	
	-----------Title---------------------
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(1,1)
	monitor.write("MJRLegends Fusion Reactor Management")
	monitor.setTextColour((colours.white))
	
	-----------Reactor Enable/Disable---------------------
	monitor.setCursorPos(1,3)
 	monitor.write("Reactor: ")
	if active then
		monitor.setBackgroundColour((colours.blue))
	else
		monitor.setBackgroundColour((colours.grey))
	end
	monitor.setCursorPos(20,3)
	monitor.write(" ON  ")
	
	if active then
		monitor.setBackgroundColour((colours.grey))
	else
		monitor.setBackgroundColour((colours.blue))
	end
	monitor.setCursorPos(25,3)
	monitor.write(" OFF ")
	monitor.setBackgroundColour((colours.black)) 

	-----------Section Lines---------------------
	displayW,displayH=monitor.getSize()
	
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,2)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour((colours.white))
	
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,4)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour((colours.white))
	
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,displayH - 2)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour((colours.white))
	
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,displayH - 0)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour((colours.white))
	
	-----------Bottom Bar Buttons---------------------
	if setting then
		monitor.setBackgroundColour((colours.grey))
    else
		monitor.setBackgroundColour((colours.blue))
    end
	monitor.setCursorPos(displayW - 10,displayH - 1)
    monitor.write(" Settings ")
    monitor.setBackgroundColour((colours.black))
end

function drawDisplayScreen()
	displayW,displayH=monitor.getSize()
	monitor.setTextScale(1)
	
	-----------Casing Heat---------------------
	draw_text(2, 5, "Casing Heat: ", colors.yellow, colors.black)
	local maxVal = 5000000000
	local minVal = math.floor(tonumber(reactor.getCaseHeat()))
	draw_text(19, 5, minVal.." C", colors.white, colors.black)
	
	if minVal < 100000 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < math.floor((1000000000 / 2)/2) then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < math.floor(1000000000 / 2) then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= math.floor(1000000000 / 2) then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.red, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------Plasma Heat---------------------
	draw_text(2, 8, "Plasma Heat: ", colors.yellow, colors.black)
	local maxVal = 7350000000
	local minVal = math.floor(tonumber(reactor.getPlasmaHeat()))
	draw_text(19, 8, minVal.." C", colors.white, colors.black)
	
	if minVal < 100000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < math.floor((1000000000 / 2)/2) then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < math.floor(1000000000 / 2) then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= math.floor(1000000000 / 2) then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.red, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------Laser Power Storage---------------------
	draw_text(2, 11, "Laser Power: ", colors.yellow, colors.black)
	local maxVal = 5000000000
	local minVal = math.floor(tonumber(laser.getStored()))
	draw_text(19, 11, math.floor((minVal/maxVal)*100).." % " .."("..minVal.." J)", colors.white, colors.black)
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.blue, colors.gray)
	monitor.setBackgroundColour((colours.black))
	
	-----------Injection Rate---------------------
	draw_text(2, 14, "Injection Rate: ", colors.yellow, colors.black)
	draw_text(24, 14, reactor.getInjectionRate(), colors.white, colors.black)
	
	-----------Has Fuel---------------------
	draw_text(2, 15, "Fuel: ", colors.yellow, colors.black)
	draw_text(24, 15, reactor.hasFuel(), colors.white, colors.black)
	
	-----------Engery Producing---------------------
	draw_text(2, 16, "Engery Producing J/T: ", colors.yellow, colors.black)
	draw_text(24, 16, math.floor(tonumber(reactor.getProducing())) .. " J/T", colors.white, colors.black)
	draw_text(2, 17, "Engery Producing RF/T: ", colors.yellow, colors.black)
	draw_text(24, 17, math.floor(tonumber(reactor.getProducing()) / 2.5) .. " RF/T", colors.white, colors.black)
	
	-----------Can Ignite---------------------
	draw_text(2, 18, "Can Ignite: ", colors.yellow, colors.black)
	draw_text(24, 18, reactor.canIgnite(), colors.white, colors.black)
	
end

function drawSettingScreen()
	displayW,displayH=monitor.getSize()
	
	-------------Title-------------------
	draw_text(16, 6, "Settings", colors.blue, colors.black)
	
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,7)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour((colours.white))
end

function checkClickPosition()
	displayW,displayH=monitor.getSize()
    --if mouseWidth > 20 and mouseWidth < 24 and mouseHeight == 3 then
    --    reactor.setActive(true)
    --elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 3 then
     --   reactor.setActive(false)
	if mouseWidth > (displayW - 10) and mouseWidth < displayW and mouseHeight == (displayH - 1) then
		if setting then
			setting = false
		else
			setting = true
		end
	end
	sleep(0.5)
end
 
 
function mainMenu()
	while true do
		displayW,displayH=monitor.getSize()
		if displayH == 26 and displayW == 39 then
			drawControlScreen()
			if setting == true then
				drawSettingScreen()
			else 
				drawDisplayScreen()
			end
		else
			print("This program is built for a 4x4 monitor only!")
			return
		end
		sleep(1.0)
	end
end

function events()
	while true do
		event,p1,p2,p3 = os.pullEvent()
		if event=="monitor_touch" then
			mouseWidth = p2 -- sets mouseWidth
			mouseHeight = p3 -- and mouseHeight
			checkClickPosition() -- this runs our function
		end
	end
end

parallel.waitForAny(mainMenu,events)
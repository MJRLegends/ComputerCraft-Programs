----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.0.2"

mouseWidth = 0
mouseHeight = 0

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

function initPeripherals()
    local perList = peripheral.getNames()
    for i=1,#perList,1 do
        if peripheral.getType(perList[i]) == "monitor" then
            monitor = peripheral.wrap(perList[i])
			term.setCursorPos(1,3)
			term.write("Monitor Found!")
        end
        if peripheral.getType(perList[i]) == "mekanism_machine" then
            reactor = peripheral.wrap(perList[i])
			term.setCursorPos(1,4)
			term.write("Fusion Reactor Found!")
        end
		if peripheral.getType(perList[i]) == "Reactor Logic Adapter" then
            reactor = peripheral.wrap(perList[i])
			term.setCursorPos(1,4)
			term.write("Fusion Reactor Found!")
        end
    end
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
	
	-----------Ignition Heat---------------------
	draw_text(2, 11, "Ignition Heat: ", colors.yellow, colors.black)
	local maxVal = 100000000
	local minVal = math.floor(tonumber(reactor.getIgnitionTemp()))
	draw_text(19, 11, minVal.." C", colors.white, colors.black)
	
	if minVal < 100000 then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < math.floor((100000000 / 2)/2) then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < math.floor(100000000 / 2) then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= math.floor(100000000 / 2) then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.red, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------Energy---------------------
	draw_text(2, 14, "Power: ", colors.yellow, colors.black)
	local maxVal = reactor.getMaxEnergy()
	local minVal = math.floor(tonumber(reactor.getEnergy()))
	draw_text(19, 14, math.floor(minVal / 2.5).." RF", colors.white, colors.black)
	
	progress_bar(2, 15, displayW-2, minVal, maxVal, colors.lightGray, colors.gray)
	monitor.setBackgroundColour((colours.black))
	
	-----------Fuel---------------------
	draw_text(2, 17, "Fuel: ", colors.yellow, colors.black)
	local maxVal = reactor.getMaxEnergy()
	local minVal = tonumber(reactor.getFuel())
	draw_text(19, 17, minVal.." mb", colors.white, colors.black)
	
	progress_bar(2, 18, displayW-2, minVal, maxVal, colors.pink, colors.gray)
	monitor.setBackgroundColour((colours.black))
	
	-----------Injection Rate---------------------
	draw_text(2, 20, "Injection Rate: ", colors.yellow, colors.black)
	draw_text(24, 20, reactor.getInjectionRate(), colors.white, colors.black)
	
	-----------Has Fuel---------------------
	--draw_text(2, 18, "Fuel: ", colors.yellow, colors.black)
	--draw_text(24, 18, reactor.hasFuel(), colors.white, colors.black)
	
	-----------Engery Producing---------------------
	--draw_text(2, 19, "Engery Producing J/T: ", colors.yellow, colors.black)
	--draw_text(24, 19, math.floor(tonumber(reactor.getProducing())) .. " J/T", colors.white, colors.black)
	draw_text(2, 21, "Engery Producing RF/T: ", colors.yellow, colors.black)
	draw_text(24, 21, math.floor(tonumber(reactor.getProducing()) / 2.5) .. " RF/T", colors.white, colors.black)
	
	-----------Can Ignite---------------------
	--draw_text(2, 21, "Can Ignite: ", colors.yellow, colors.black)
	--draw_text(24, 21, reactor.canIgnite(), colors.white, colors.black)
	
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
	initPeripherals()
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
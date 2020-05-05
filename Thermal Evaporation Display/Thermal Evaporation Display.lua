----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.5.0"

mouseWidth = 0
mouseHeight = 0
currentTower = 1
towers = {}

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
	towerNumber = 1
    for i=1,#perList,1 do
        if peripheral.getType(perList[i]) == "monitor" then
            monitor = peripheral.wrap(perList[i])
            term.setCursorPos(1,3)
            term.write("Monitor Found!")
        end
        if peripheral.getType(perList[i]) == "Thermal Evaporation Block" then
            table.insert(towers, towerNumber, perList[i])
			towerNumber = towerNumber + 1
        end
    end
	term.setCursorPos(1,4)
	term.write((towerNumber - 1) .. " Thermal Evaporation Tower's Found!")
	tower = peripheral.wrap(towers[currentTower])
end

function drawTitle()
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(1,1)
	monitor.write("MJRLegends Thermal Evaporation Display")
	monitor.setTextColour((colours.white))
	
	displayW,displayH=monitor.getSize()
	monitor.setTextColour((colours.blue))
	monitor.setCursorPos(0,2)
    monitor.write(string.rep("-", displayW))
end

function drawConsoleHeader()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.blue)
	term.setCursorPos(1,1)
	term.write("MJRLegends Thermal Evaporation Display")
	term.setCursorPos(1,2)
	term.write("Version: " .. version)
end

function drawControlScreen()
	drawConsoleHeader()
	monitor.setTextScale(1)
	monitor.clear()
	
	-----------Title---------------------
	drawTitle()
	-----------Section Lines---------------------
	displayW,displayH=monitor.getSize()
	
	monitor.setCursorPos(0,4)
    monitor.write(string.rep("-", displayW))
	
	monitor.setCursorPos(0,displayH - 2)
    monitor.write(string.rep("-", displayW))
	
	monitor.setCursorPos(0,displayH - 0)
    monitor.write(string.rep("-", displayW))
	
	monitor.setTextColour((colours.white))
	
	-------------Multi Reactor Support Controls-------------------
	monitor.setBackgroundColour(colours.blue)
    monitor.setCursorPos(displayW - 12,3)
    monitor.write("<")
    monitor.setCursorPos(displayW - 10,3)
    monitor.write(">")
	monitor.setCursorPos(8,3)
	monitor.setBackgroundColour(colours.black) 
	monitor.setTextColour(colours.yellow)
	if currentTower == 0 then
    	monitor.write("All")
	else
		monitor.write("Current Tower: ".. currentTower)
	end
end

function drawDisplayScreen()
	displayW,displayH=monitor.getSize()
	monitor.setTextScale(1)
	
	-----------Temperature---------------------
	draw_text(2, 5, "Temperature: ", colors.yellow, colors.black)
	local maxVal = 2000
	local minVal = math.floor(tower.getTemperature())
	draw_text(19, 5, minVal.." k C", colors.white, colors.black)
	
	if minVal < 100 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < 500 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < 2000 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= 1500 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.red, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------Input Fluid---------------------
	draw_text(2, 8, "Input Fluid: ", colors.yellow, colors.black)
	local maxVal = 1024000
	local minVal = math.floor(tonumber(tower.getInput()))
	draw_text(19, 8, minVal.." mb", colors.white, colors.black)
	
	if minVal < 50000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < 100000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < 500000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= 1000000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.green, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------Output Fluid---------------------
	draw_text(2, 11, "Output Fluid: ", colors.yellow, colors.black)
	local maxVal = 10000
	local minVal = math.floor(tonumber(tower.getOutput()))
	draw_text(19, 11, minVal.." mb", colors.white, colors.black)
	
	if minVal < 1000 then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < 4000 then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < 6000 then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= 9500 then
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.green, colors.gray)
	end
	monitor.setBackgroundColour((colours.black))
	
	-----------is Formed---------------------
	draw_text(2, 14, "Is Formed: ", colors.yellow, colors.black)
	draw_text(24, 14, tower.isFormed(), colors.white, colors.black)
	
	-----------Height---------------------
	draw_text(2, 15, "Height: ", colors.yellow, colors.black)
	draw_text(24, 15, tower.getHeight(), colors.white, colors.black)
end

function checkClickPosition()
	displayW,displayH=monitor.getSize()
	if mouseWidth > 26 and mouseWidth < 28 and mouseHeight == 3 then
		if currentTower > 1 then
			currentTower = currentTower - 1
			tower = peripheral.wrap(towers[currentTower])
		end
	elseif mouseWidth > 28 and mouseWidth < 30 and mouseHeight == 3 then
		if currentTower < table.getn(towers) then
			currentTower = currentTower + 1
			tower = peripheral.wrap(towers[currentTower])
		end
	end
	
end


function mainMenu()
	initPeripherals()
	drawConsoleHeader()
	while true do
		displayW,displayH=monitor.getSize()
		if displayH == 26 and displayW == 39 then
			drawControlScreen()
			drawDisplayScreen()
		else
			print("This program is built for a 4x4 monitor only!")
			return
		end
		sleep(0.2)
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
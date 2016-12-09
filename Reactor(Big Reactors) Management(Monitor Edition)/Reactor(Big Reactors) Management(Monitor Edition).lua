----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "4.0.0"

-- Screen Numbers
-- 0 - drawMainScreen()
-- 1 - drawDisplayScreen()
-- 2 - drawRodScreen()
-- 3 - drawSettingScreen()

mouseWidth = 0
mouseHeight = 0
rodNumber = 0
rodLevel = 0

rods = false
setting = false
control = false

maxFluidTank = 50000
minLevelPower = 5000000
maxLevelPower = 9000000
minLevelSteam = maxFluidTank / 2
maxLevelSteam = maxFluidTank
currentPower = 0

reactors = {}
reactorsManagement = {}
monitors = {}
monitorsCurrentReactor = {}
monitorsCurrentScreen = {}

function draw_line(x, y, length, color, monitor)
	tempMonitor = monitor
	tempMonitor.setBackgroundColor(color)
	tempMonitor.setCursorPos(x,y)
	tempMonitor.write(string.rep(" ", length), tempMonitor)
end

function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color, monitor)
	tempMonitor = monitor
	draw_line(x, y, length, bg_color, tempMonitor) --backgoround bar
	local barSize = math.floor((minVal/maxVal) * length)
	draw_line(x, y, barSize, bar_color, tempMonitor)     --progress so far
end

function progress_bar_multi_line(x, y, length, minVal, maxVal, bar_color, bg_color, numberOFLine, monitor)
	tempMonitor = monitor
	local barSize = math.floor((minVal/maxVal) * length)
	y = y - 1
	for i=1,numberOFLine,1 do
		draw_line(x, y + i, length, bg_color, tempMonitor) --background bar
		draw_line(x, y + i, barSize, bar_color, tempMonitor)     --progress so far
	end
end

function draw_text(x, y, text, text_color, bg_color, monitor)
	tempMonitor = monitor
	monitor.setBackgroundColor(bg_color)
	monitor.setTextColor(text_color)
	monitor.setCursorPos(x,y)
	monitor.write(text)
end

function terminalOutput()
	term.clear()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.blue)
	term.setCursorPos(1,1)
	term.write("MJRLegends Reactor Management (Monitor Edition)")
	
	term.setTextColor(colors.lime)
	term.setCursorPos(1,2)
	term.write("Version: " .. version)
	
	term.setTextColor(colors.red)
	term.setCursorPos(1,4)
	term.write("Important Infomation:")
	
	term.setTextColor(colors.white)
	term.setCursorPos(1,5)
	term.write("- Multi Reactor & Monitor support!")
	term.setCursorPos(1,6)
	term.write("- No Monitors support for compact control!")
	term.setCursorPos(1,7)
	term.write("- Auto detect for added & removed peripheral!")
	
	term.setTextColor(colors.cyan)
	term.setCursorPos(1,9)
	term.write("Peripheral Connected:")
end

function initPeripherals()
    local perList = peripheral.getNames()
	local yLevel = 10
	local reactorNumber = 1
	local monitorNumber = 1
	term.setTextColor(colors.yellow)
	
	monitors = {}
	monitorsCurrentReactor = {}
	monitorsCurrentScreen = {}
	reactors = {}
	reactorsManagement = {}

    for i=1,#perList,1 do
        if peripheral.getType(perList[i]) == "monitor" then
			table.insert(monitors, monitorNumber, perList[i])
			table.insert(monitorsCurrentReactor, monitorNumber,	0)
			table.insert(monitorsCurrentScreen, monitorNumber, "0")

			monitorNumber = monitorNumber +1
		elseif peripheral.getType(perList[i]) == "BigReactors-Reactor" then
			table.insert(reactors, reactorNumber, perList[i])
			table.insert(reactorsManagement, reactorNumber, true)
			reactorNumber = reactorNumber +1
        end
    end
	term.setCursorPos(1,yLevel)
	term.write((monitorNumber - 1) .. " Monitors Found!")
	
	term.setCursorPos(1,yLevel+ 1)
	term.write((reactorNumber - 1) .. " Reactors Found!")
end

function drawMainScreen(monitorName, reactorNumber)
	local monitor = peripheral.wrap(monitorName)
	local currentReactor = peripheral.wrap(reactors[reactorNumber + 1])

	displayW,displayH=monitor.getSize()
	monitor.clear()
	monitor.setBackgroundColor(colours.black)
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(5,1)
	monitor.write("MJRLegends Reactor Management", monitor)

	monitor.setCursorPos((displayW / 2)-2,2)
	monitor.write("v"..version, monitor)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,3)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	numberOfActiveReactros = 0
	numberOfActivelyCooled = 0
	totalBufferedEnergy = 0
	totalBufferedSteam = 0
	totalBufferedFuel = 0
	totalBufferedWaste = 0
	totalBufferedFuelWasteMax = 0
	
	for i=1,#reactors,1 do
		tempReactor = peripheral.wrap(reactors[i])
		if tempReactor.getActive() then
			numberOfActiveReactros = numberOfActiveReactros + 1
		end
		if tempReactor.isActivelyCooled() then
			numberOfActivelyCooled = numberOfActivelyCooled + 1
			totalBufferedSteam = totalBufferedSteam + math.floor(tempReactor.getHotFluidAmount())
		else 			
			totalBufferedEnergy = totalBufferedEnergy + math.floor(tempReactor.getEnergyStored())
		end
		totalBufferedFuel = totalBufferedFuel + math.floor(tempReactor.getFuelAmount())
		totalBufferedWaste = totalBufferedWaste + math.floor(tempReactor.getWasteAmount())
		totalBufferedFuelWasteMax = totalBufferedFuelWasteMax + math.floor(tempReactor.getFuelAmountMax())
	end
	
	monitor.setCursorPos(1,4)
	monitor.write("Number of Online Reactors: " .. numberOfActiveReactros .. "/" .. table.getn(reactors), monitor)
	monitor.setCursorPos(1,5)
	monitor.write("Number of Actively Cooled: " .. numberOfActivelyCooled .. "/" .. table.getn(reactors), monitor)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,6)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	monitor.setCursorPos(1,8)
	monitor.setTextColour(colours.yellow)
	monitor.write("Total Stored Energy: " .. totalBufferedEnergy .. " RF", monitor)
	progress_bar_multi_line(2, 9, displayW-2, totalBufferedEnergy, (10000000 * (table.getn(reactors) - numberOfActivelyCooled)), colors.red, colors.gray, 2, monitor)
	monitor.setBackgroundColor(colours.black)
	monitor.setCursorPos(1,12)
	monitor.write("Total Stored Steam: " .. totalBufferedSteam .. " mb", monitor)
	progress_bar_multi_line(2, 13, displayW-2, totalBufferedSteam, ((50000 * (table.getn(reactors))) - numberOfActivelyCooled), colors.lightGray, colors.gray, 2, monitor)
	monitor.setBackgroundColor(colours.black)
	monitor.setCursorPos(1,16)
	monitor.write("Total Stored Fuel: " .. totalBufferedFuel .. " mb", monitor)
	progress_bar_multi_line(2, 17, displayW-2, totalBufferedFuel, totalBufferedFuelWasteMax, colors.yellow, colors.gray, 2, monitor)
	monitor.setBackgroundColor(colours.black)
	monitor.setCursorPos(1,20)
	monitor.write("Total Stored Waste: " .. totalBufferedWaste .. " mb", monitor)
	progress_bar_multi_line(2, 21, displayW-2, totalBufferedWaste, totalBufferedFuelWasteMax, colors.blue, colors.gray, 2, monitor)
	
	monitor.setTextColour(colours.white)
	monitor.setBackgroundColor(colours.blue)
	monitor.setCursorPos(1,displayH - 0)
	monitor.write("                                        ", monitor)
	monitor.setCursorPos(1,displayH - 1)
	monitor.write("             Control Screen             ", monitor)
	monitor.setCursorPos(1,displayH - 2)
	monitor.write("                                        ", monitor)
	monitor.setBackgroundColor(colours.black)
end

function drawControlScreen(monitorName, reactorNumber, screenNumber)
	local monitor = peripheral.wrap(monitorName)
	local currentReactor = peripheral.wrap(reactors[reactorNumber + 1])
	
	displayW,displayH=monitor.getSize()
	monitor.clear()
	monitor.setBackgroundColor(colours.black)
	numberOfControlRods = currentReactor.getNumberOfControlRods()
	active = currentReactor.getActive()
	
	-----------Title---------------------
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(1,1)
	monitor.write("MJRLegends Reactor Management", monitor)
	monitor.setTextColour(colours.white)
	
	-----------Reactor Enable/Disable---------------------
	monitor.setCursorPos(1,3)
	monitor.write("Reactor: ", monitor)
	if active then
		monitor.setBackgroundColour(colours.blue)
	else
		monitor.setBackgroundColour(colours.grey)
	end
	monitor.setCursorPos(20,3)
	monitor.write(" ON  ")
	
	if active then
		monitor.setBackgroundColour(colours.grey)
	else
		monitor.setBackgroundColour(colours.blue)
	end
	monitor.setCursorPos(25,3)
	monitor.write(" OFF ", monitor)
	monitor.setBackgroundColour(colours.black) 

	-------------Multi Reactor Support Controls-------------------
	monitor.setBackgroundColour(colours.blue)
	monitor.setCursorPos(displayW - 8,1)
	monitor.write("<", monitor)
	monitor.setCursorPos(displayW - 5,1)
	monitor.write(">", monitor)
	monitor.setCursorPos(displayW - 3,1)
	monitor.setBackgroundColour(colours.black) 
	monitor.setTextColour(colours.yellow)
	monitor.write("".. reactorNumber, monitor)

	-----------Section Lines---------------------
	displayW,displayH=monitor.getSize()
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,2)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,4)
	monitor.write(string.rep("-", displayW, monitor))
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,displayH - 2)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,displayH - 0)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	-----------Bottom Bar Buttons---------------------
	if tonumber(monitorsCurrentScreen[screenNumber]) == 2 then
		draw_text(displayW - 25,displayH - 1, " Control Rods ", colors.white, colours.grey, monitor)
	else
		draw_text(displayW - 25,displayH - 1, " Control Rods ", colors.white, colours.blue, monitor)
	end

	if tonumber(monitorsCurrentScreen[screenNumber]) == 3 then
		draw_text(displayW - 10,displayH - 1, " Settings ", colors.white, colours.grey, monitor)
	else
		draw_text(displayW - 10,displayH - 1, " Settings ", colors.white, colours.blue, monitor)
	end

	monitor.setBackgroundColour(colours.green)
	monitor.setCursorPos(2,displayH - 1)
	monitor.write(" Main Menu ", monitor)
end

function drawDisplayScreen(monitorName, reactorNumber)
	local monitor = peripheral.wrap(monitorName)
	local currentReactor = peripheral.wrap(reactors[reactorNumber + 1])

	monitor.setBackgroundColor(colours.black)
	displayW,displayH=monitor.getSize()
	
	-----------Casing Heat---------------------
	draw_text(2, 5, "Casing Heat: ", colors.yellow, colors.black, monitor)
	local maxVal = 5000
	local minVal = math.floor(currentReactor.getCasingTemperature())
	draw_text(23, 5, minVal.." C", colors.white, colors.black, monitor)
	
	if minVal < 500 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray, monitor)
	elseif minVal < 1000 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lime, colors.gray, monitor)
	elseif minVal < 1500 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.yellow, colors.gray, monitor)
	elseif minVal >= 1500 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.red, colors.gray, monitor)
	end
	
	-----------Fuel Heat---------------------
	draw_text(2, 8, "Fuel Heat: ", colors.yellow, colors.black, monitor)
	local maxVal = 5000
	local minVal = math.floor(currentReactor.getFuelTemperature())
	draw_text(23, 8, minVal.." C", colors.white, colors.black, monitor)
	
	if minVal < 500 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray, monitor)
	elseif minVal < 1000 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lime, colors.gray, monitor)
	elseif minVal < 1500 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.yellow, colors.gray, monitor)
	elseif minVal >= 1500 then
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.red, colors.gray, monitor)
	end
	
	-----------Water Tank---------------------
	if currentReactor.isActivelyCooled() then
		draw_text(2, 11, "Water Tank: ", colors.yellow, colors.black, monitor)
		local maxVal = currentReactor.getHotFluidAmountMax()
		local minVal = math.floor(currentReactor.getCoolantAmount())
		draw_text(23, 11, minVal.." mb", colors.white, colors.black, monitor)
		progress_bar(2, 12, displayW-2, minVal, maxVal, colors.blue, colors.gray, monitor)
	else
	-----------Power Storage---------------------
		draw_text(2, 11, "Power: ", colors.yellow, colors.black, monitor)
		local maxVal = 10000000
		local minVal = math.floor(currentReactor.getEnergyStored())
		draw_text(23, 11, math.floor((minVal/maxVal)*100).."% " .."="..minVal.." RF", colors.white, colors.black, monitor)
		progress_bar(2, 12, displayW-2, minVal, maxVal, colors.lightGray, colors.gray, monitor)
	end
	
	yValue = 12
	
	-----------Steam Tank---------------------
	if currentReactor.isActivelyCooled() then
		draw_text(2, yValue +2, "Steam Tank: ", colors.yellow, colors.black, monitor)
		local maxVal = currentReactor.getHotFluidAmountMax()
		local minVal = math.floor(currentReactor.getHotFluidAmount())
		draw_text(23, yValue +2, minVal.." mb", colors.white, colors.black, monitor)
		progress_bar(2, yValue +3, displayW-2, minVal, maxVal, colors.lightGray, colors.gray, monitor)
	end
	if currentReactor.isActivelyCooled() then
		yValue = yValue + 4
	else
		yValue = 13
	end
	-------------Fuel-------------------
	draw_text(2, yValue+ 1, "Fuel: ", colors.yellow, colors.black, monitor)
	fuel = math.floor(currentReactor.getFuelAmount())
	draw_text(23, yValue + 1, fuel.." mb", colors.white, colors.black, monitor)
	
	-------------Waste-------------------
	draw_text(2, yValue+ 3, "Waste: ", colors.yellow, colors.black, monitor)
	waste = math.floor(currentReactor.getWasteAmount())
	draw_text(23, yValue+ 3, waste.." mb", colors.white, colors.black, monitor)
	
	-------------ProducedLastTick-------------------
	if currentReactor.isActivelyCooled() then
		draw_text(2, yValue+ 5, "Hot Fluid/T: ", colors.yellow, colors.black, monitor)
	else
		draw_text(2, yValue+ 5, "RF/T: ", colors.yellow, colors.black, monitor)
	end
	waste = math.floor(currentReactor.getEnergyProducedLastTick())
	if currentReactor.isActivelyCooled() then
		draw_text(23, yValue+ 5, waste.." mb", colors.white, colors.black, monitor)
	else
		draw_text(23, yValue+ 5, waste.." RF", colors.white, colors.black, monitor)
	end	
	
	-------------Fuel Consumption-------------------
	draw_text(2, yValue+ 7, "Fuel Consumption: ", colors.yellow, colors.black, monitor)
	draw_text(23, yValue+ 7, currentReactor.getFuelConsumedLastTick().." mB/t", colors.white, colors.black, monitor)
	monitor.setBackgroundColour(colours.black)
	
	if not currentReactor.isActivelyCooled() then
		draw_text(2, yValue+ 9, "Power Usage(IO): ", colors.yellow, colors.black, monitor)
		draw_text(23, yValue+ 9, math.abs((currentPower-currentReactor.getEnergyStored())).." RF/T)", colors.white, colors.black, monitor)
		currentPower = currentReactor.getEnergyStored()
	end
end

function drawRodScreen(monitorName, reactorNumber)
	local monitor = peripheral.wrap(monitorName)
	local currentReactor = peripheral.wrap(reactors[reactorNumber + 1])

	monitor.setBackgroundColor(colours.black)
	displayW,displayH=monitor.getSize()
		
	-------------Title-------------------
	draw_text(15, 6, "Control Rods", colors.blue, colors.black, monitor)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,7)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	-------------Number of Control Rods-------------------
	draw_text(1, 8, "Number of Control Rods: "..numberOfControlRods, colors.white, colors.black, monitor)

	monitor.setTextColour(colours.yellow)
	monitor.setCursorPos(0,10)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	-------------Control Rod Number/Selection-------------------
	draw_text(2, 11, "Rod "..rodNumber, colors.yellow, colors.black, monitor)
	monitor.setBackgroundColour(colours.blue)
	monitor.setCursorPos(9,11)
	monitor.write(" + ", monitor)
 
	monitor.setCursorPos(13,11)
	monitor.write(" - ", monitor)
	monitor.setBackgroundColour(colours.black)
	
	monitor.setTextColour(colours.yellow)
	monitor.setCursorPos(0,12)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	-------------Control Rod Level/Increase and Decrease-------------------
	local maxVal = 100
	local minVal = math.floor(currentReactor.getControlRodLevel(rodNumber))
	rodLevel = minVal
	draw_text(2, 13, minVal.." %", colors.white, colors.black, monitor)
	progress_bar(2, 14, displayW-2, maxVal-minVal, maxVal, colors.lightGray, colors.gray, monitor)
	monitor.setBackgroundColour(colours.black)
	
	monitor.setBackgroundColour(colours.blue)
	monitor.setCursorPos(8,13)
	monitor.write(" +1 ", monitor)
 
	monitor.setCursorPos(13,13)
	monitor.write(" +5 ", monitor)
	
	monitor.setCursorPos(18,13)
	monitor.write(" +10 ", monitor)
	
	monitor.setCursorPos(24,13)
	monitor.write(" -1 ", monitor)
 
	monitor.setCursorPos(29,13)
	monitor.write(" -5 ", monitor)
	
	monitor.setCursorPos(34,13)
	monitor.write(" -10 ", monitor)
	
	monitor.setBackgroundColour(colours.black)
end

function drawSettingScreen(monitorName, reactorNumber)
	local monitor = peripheral.wrap(monitorName)
	local currentReactor = peripheral.wrap(reactors[reactorNumber + 1])

	monitor.setBackgroundColor(colours.black)
	displayW,displayH=monitor.getSize()
		
	-------------Title-------------------
	draw_text(16, 6, "Settings", colors.blue, colors.black, monitor)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,7)
	monitor.write(string.rep("-", displayW), monitor)
	monitor.setTextColour(colours.white)
	
	-----------Reactor Management Enable/Disable---------------------
	monitor.setCursorPos(1,8)
	monitor.setTextColour(colours.yellow)
	monitor.write("Reactor Management: ", monitor)
	monitor.setTextColour(colours.white)
	if reactorsManagement[reactorNumber + 1] == true then
		monitor.setBackgroundColour(colours.blue)
	else
		monitor.setBackgroundColour(colours.grey)
	end
	monitor.setCursorPos(20,8)
	monitor.write(" ON  ", monitor)
 
	if reactorsManagement[reactorNumber + 1] == true then
		monitor.setBackgroundColour(colours.grey)
	else
		monitor.setBackgroundColour(colours.blue)
	end
	monitor.setCursorPos(25,8)
	monitor.write(" OFF ", monitor)
	monitor.setBackgroundColour(colours.black)
	
	
	-----------Reactor MaxFluid Tank Level---------
	if currentReactor.isActivelyCooled() then
		monitor.setCursorPos(1,10)
		monitor.setTextColour(colours.blue)
		monitor.write("Max Fluid Tank Level:", monitor)
		monitor.setTextColour(colours.white)
		draw_text(22, 10, maxFluidTank.." mb", colors.white, colors.black, monitor)

		monitor.setBackgroundColour(colours.blue)

		monitor.setCursorPos(1,11)
		monitor.write("|+100|", monitor)
	 
		monitor.setCursorPos(6,11)
		monitor.write("|+1000|", monitor)
		
		monitor.setCursorPos(12,11)
		monitor.write("|+10,000|", monitor)
		
		monitor.setCursorPos(1,12)
		monitor.write("|-100|", monitor)
	 
		monitor.setCursorPos(6,12)
		monitor.write("|-1000|", monitor)
		
		monitor.setCursorPos(12,12)
		monitor.write("|-10,000|", monitor)
		
		monitor.setBackgroundColour(colours.black)
	end

	-----------Reactor Levels Max/Min---------------------
	if not currentReactor.isActivelyCooled() then
		monitor.setCursorPos(1,11)
		monitor.setTextColour(colours.blue)
		monitor.write("Power Management Levels: ", monitor)

		monitor.setCursorPos(1,12)
		monitor.setTextColour(colours.yellow)
		monitor.write("Min Level:", monitor)
		monitor.setTextColour(colours.white)
		local value = minLevelPower
		draw_text(12, 12, value.." RF", colors.white, colors.black, monitor)		
		monitor.setBackgroundColour(colours.blue)
		monitor.setCursorPos(1,13)
		monitor.write("|+1|", monitor)
	 
		monitor.setCursorPos(5,13)
		monitor.write("|+100|", monitor)
		
		monitor.setCursorPos(11,13)
		monitor.write("|+1000|", monitor)
		
		monitor.setCursorPos(18,13)
		monitor.write("|+10k|", monitor)
	 
		monitor.setCursorPos(24,13)
		monitor.write("|+100k|", monitor)
		
		monitor.setCursorPos(31,13)
		monitor.write("|+1mill|", monitor)
		
		monitor.setCursorPos(1,14)
		monitor.write("|-1|", monitor)
	 
		monitor.setCursorPos(5,14)
		monitor.write("|-100|", monitor)
		
		monitor.setCursorPos(11,14)
		monitor.write("|-1000|", monitor)
		
		monitor.setCursorPos(18,14)
		monitor.write("|-10k|", monitor)
	 
		monitor.setCursorPos(24,14)
		monitor.write("|-100k|", monitor)
		
		monitor.setCursorPos(31,14)
		monitor.write("|-1mill|", monitor)
		
		
		monitor.setBackgroundColour(colours.black)
		
		monitor.setCursorPos(1,15)
		monitor.setTextColour(colours.yellow)
		monitor.write("Max Level:", monitor)
		monitor.setTextColour(colours.white)
		local value = maxLevelPower
		draw_text(12, 15, value.." RF", colors.white, colors.black, monitor)		
		monitor.setBackgroundColour(colours.blue)
		
		monitor.setCursorPos(1,16)
		monitor.write("|+1|", monitor)
	 
		monitor.setCursorPos(5,16)
		monitor.write("|+100|", monitor)
		
		monitor.setCursorPos(11,16)
		monitor.write("|+1000|", monitor)
		
		monitor.setCursorPos(18,16)
		monitor.write("|+10k|", monitor)
	 
		monitor.setCursorPos(24,16)
		monitor.write("|+100k|", monitor)
		
		monitor.setCursorPos(31,16)
		monitor.write("|+1mill|", monitor)
		
		monitor.setCursorPos(1,17)
		monitor.write("|-1|", monitor)
	 
		monitor.setCursorPos(5,17)
		monitor.write("|-100|", monitor)
		
		monitor.setCursorPos(11,17)
		monitor.write("|-1000|", monitor)
		
		monitor.setCursorPos(18,17)
		monitor.write("|-10k|", monitor)
	 
		monitor.setCursorPos(24,17)
		monitor.write("|-100k|", monitor)
		
		monitor.setCursorPos(31,17)
		monitor.write("|-1mill|", monitor)
		
	else
		monitor.setCursorPos(1,14)
		monitor.setTextColour(colours.blue)
		monitor.write("Steam Management Levels: ", monitor)

		monitor.setCursorPos(1,15)
		monitor.setTextColour(colours.yellow)
		monitor.write("Min Level:", monitor)
		monitor.setTextColour(colours.white)
		local value = minLevelSteam
		draw_text(12, 15, value.." mb", colors.white, colors.black, monitor)
		monitor.setBackgroundColour(colours.blue)
		
		--Higher Values
		monitor.setCursorPos(1,16)
		monitor.write("|+1|", monitor)
	 
		monitor.setCursorPos(5,16)
		monitor.write("|+100|", monitor)
		
		monitor.setCursorPos(11,16)
		monitor.write("|+1000|", monitor)
		
		monitor.setCursorPos(18,16)
		monitor.write("|+10,000|", monitor)
		
		--Lower Values
		monitor.setCursorPos(1,17)
		monitor.write("|-1|", monitor)
	 
		monitor.setCursorPos(5,17)
		monitor.write("|-100|", monitor)
		
		monitor.setCursorPos(11,17)
		monitor.write("|-1000|", monitor)
		
		monitor.setCursorPos(18,17)
		monitor.write("|-10,000|", monitor)
		
		monitor.setBackgroundColour(colours.black)
		
		monitor.setCursorPos(1,18)
		monitor.setTextColour(colours.yellow)
		monitor.write("Max Level:", monitor)
		monitor.setTextColour(colours.white)
		local value = maxLevelSteam
		draw_text(12, 18, value.." mb", colors.white, colors.black, monitor)
		
		monitor.setBackgroundColour(colours.blue)
		monitor.setCursorPos(1,19)
		monitor.write("|+1|", monitor)
	 
		monitor.setCursorPos(5,19)
		monitor.write("|+100|", monitor)
		
		monitor.setCursorPos(11,19)
		monitor.write("|+1000|", monitor)
		
		monitor.setCursorPos(18,19)
		monitor.write("|+10,000|", monitor)
		
		monitor.setCursorPos(1,20)
		monitor.write("|-1|", monitor)
	 
		monitor.setCursorPos(5,20)
		monitor.write("|-100|", monitor)
		
		monitor.setCursorPos(11,20)
		monitor.write("|-1000|", monitor)
		
		monitor.setCursorPos(18,20)
		monitor.write("|-10,000|", monitor)
	end
	monitor.setBackgroundColour(colours.black)
end

function management()
	for i=1,#reactors,1 do
		if reactorsManagement[i] == true then
			tempReactor = peripheral.wrap(reactors[i])
			if not tempReactor.isActivelyCooled() then
				energy_stored = tempReactor.getEnergyStored()
				if energy_stored > maxLevelPower then
					tempReactor.setActive(false)
				elseif energy_stored < minLevelPower then
					tempReactor.setActive(true)
				end
			else
				if tempReactor.getHotFluidAmount() >= maxLevelSteam then
					tempReactor.setActive(false)
				elseif tempReactor.getHotFluidAmount() <= minLevelSteam then
					tempReactor.setActive(true)
				end
			end
		end
	end
end

function checkClickPosition(peripheralName)
	local monitor = peripheral.wrap(peripheralName)
	local displayW,displayH=monitor.getSize()
	local index = 0
		for i=1,#monitors,1 do
			if monitors[i] == peripheralName then
				index = i
			end
		end
		
	if tonumber(monitorsCurrentScreen[index]) == 0 then
		if mouseWidth > 1 and mouseWidth < displayW and mouseHeight > displayH - 3 and mouseHeight < displayH then
			if tonumber(monitorsCurrentScreen[index]) == 0 then
				monitorsCurrentScreen[index] = "1"
			end
		end
	elseif mouseWidth > 20 and mouseWidth < 24 and mouseHeight == 3 then
		peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setActive(true)
	elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 3 then
		peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setActive(false)
	elseif mouseWidth > 1 and mouseWidth < (displayW - 26) and mouseHeight == (displayH - 1) then
		if tonumber(monitorsCurrentScreen[index]) > 0 then
			monitorsCurrentScreen[index] = "0"
		end
	elseif mouseWidth > (displayW - 25) and mouseWidth < (displayW - 10) and mouseHeight == (displayH - 1) then
		if tonumber(monitorsCurrentScreen[index]) == 1 then
			monitorsCurrentScreen[index] = "2"
		elseif tonumber(monitorsCurrentScreen[index]) == 2 then
			monitorsCurrentScreen[index] = "1"
		elseif tonumber(monitorsCurrentScreen[index]) == 3 then
			monitorsCurrentScreen[index] = "2"
		end
	elseif mouseWidth > (displayW - 10) and mouseWidth < displayW and mouseHeight == (displayH - 1) then
		if tonumber(monitorsCurrentScreen[index]) == 1 then
			monitorsCurrentScreen[index] = "3"
		elseif tonumber(monitorsCurrentScreen[index]) == 3 then
			monitorsCurrentScreen[index] = "1"
		elseif tonumber(monitorsCurrentScreen[index]) == 2 then
			monitorsCurrentScreen[index] = "3"
		end
	elseif mouseWidth > (displayW - 9) and mouseWidth < (displayW - 7) and mouseHeight == 1 then
		if monitorsCurrentReactor[index] > 0 then
			monitorsCurrentReactor[index] = monitorsCurrentReactor[index] - 1
		end
	elseif mouseWidth > (displayW - 6) and mouseWidth < (displayW - 4) and mouseHeight == 1 then
		if monitorsCurrentReactor[index] < table.getn(reactors) - 1	then
			monitorsCurrentReactor[index] = monitorsCurrentReactor[index] + 1
		end
	elseif tonumber(monitorsCurrentScreen[index]) == 2 then
		if mouseWidth > 9 and mouseWidth < 12 and mouseHeight == 11 then
			if rodNumber == numberOfControlRods - 1 then
				rodNumber = numberOfControlRods - 1
			else
				rodNumber = rodNumber + 1
			end
		elseif mouseWidth > 13 and mouseWidth < 16 and mouseHeight == 11 then
			if rodNumber == 0 then
				rodNumber = 0
			else
				rodNumber = rodNumber - 1
			end
			
			
			
		elseif mouseWidth > 8 and mouseWidth < 12 and mouseHeight == 13 then
			if (rodLevel + 1) > 100 then
				rodLevel = 100
			else 
				rodLevel = rodLevel + 1
			end
			rodLevel = rodLevel + 1
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
		elseif mouseWidth > 13 and mouseWidth < 17 and mouseHeight == 13 then
			if (rodLevel + 5) > 100 then
				rodLevel = 100
			else 
				rodLevel = rodLevel + 5
			end
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
		elseif mouseWidth > 18 and mouseWidth < 22 and mouseHeight == 13 then
			if (rodLevel + 10) > 100 then
				rodLevel = 100
			else 
				rodLevel = rodLevel + 10
			end
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
			
		elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 13 then
			if (rodLevel - 1) < 0 then
				rodLevel = 0
			else 
				rodLevel = rodLevel - 1
			end
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
		elseif mouseWidth > 29 and mouseWidth < 33 and mouseHeight == 13 then
			if (rodLevel - 5) < 0 then
				rodLevel = 0
			else 
				rodLevel = rodLevel - 5
			end
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
		elseif mouseWidth > 34 and mouseWidth < 41 and mouseHeight == 13 then
			if (rodLevel - 10) < 0 then
				rodLevel = 0
			else 
				rodLevel = rodLevel - 10
			end
			peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).setControlRodLevel(rodNumber, rodLevel)
		end
	end
	
	if tonumber(monitorsCurrentScreen[index]) == 3 then
		if mouseWidth > 20 and mouseWidth < 24 and mouseHeight == 8 then
			reactorsManagement[monitorsCurrentReactor[index]+ 1] = true
		elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 8 then
			reactorsManagement[monitorsCurrentReactor[index]+ 1] = false
		end
		if not peripheral.wrap(""..reactors[monitorsCurrentReactor[index]+ 1]).isActivelyCooled() then
			--Higher Values
			if mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 13 then
				if (minLevelPower + 1) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 13 then
				if (minLevelPower + 100) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 13 then
				if (minLevelPower + 1000) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 24 and mouseHeight == 13 then
				if (minLevelPower + 10000) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 10000
				end
			elseif mouseWidth > 24 and mouseWidth < 31 and mouseHeight == 13 then
				if (minLevelPower + 100000) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 100000
				end
			elseif mouseWidth > 31 and mouseWidth < 36 and mouseHeight == 13 then
				if (minLevelPower + 1000000) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 1000000
				end
			
			--Lower Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 24 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 10000
				end
			elseif mouseWidth > 24 and mouseWidth < 31 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 100000
				end
			elseif mouseWidth > 31 and mouseWidth < 36 and mouseHeight == 14 then
				if (minLevelPower - 1000000) < 0 then
					minLevelPower = 0
				else
					minLevelPower = minLevelPower - 1000000
				end
				
			--Higher Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 16 then
				if (minLevelPower + 1) > 10000000 then
					minLevelPower = 10000000
				else
					minLevelPower = minLevelPower + 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 16 then
				if (maxLevelPower + 100) > 10000000 then
					maxLevelPower = 10000000
				else
					maxLevelPower = maxLevelPower + 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 16 then
				if (maxLevelPower + 1000) > 10000000 then
					maxLevelPower = 10000000
				else
					maxLevelPower = maxLevelPower + 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 24 and mouseHeight == 16 then
				if (maxLevelPower + 10000) > 10000000 then
					maxLevelPower = 10000000
				else
					maxLevelPower = maxLevelPower + 10000
				end
			elseif mouseWidth > 24 and mouseWidth < 31 and mouseHeight == 16 then
				if (maxLevelPower + 100000) > 10000000 then
					maxLevelPower = 10000000
				else
					maxLevelPower = maxLevelPower + 100000
				end
			elseif mouseWidth > 31 and mouseWidth < 36 and mouseHeight == 16 then
				if (maxLevelPower + 1000000) > 10000000 then
					maxLevelPower = 10000000
				else
					maxLevelPower = maxLevelPower + 1000000
				end
				
			--Lower Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 24 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 10000
				end
			elseif mouseWidth > 24 and mouseWidth < 31 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 100000
				end
			elseif mouseWidth > 31 and mouseWidth < 36 and mouseHeight == 17 then
				if (maxLevelPower - 1000000) < 0 then
					maxLevelPower = 0
				else
					maxLevelPower = maxLevelPower - 1000000
				end
			end
		else
			--------- Max Fluid Tank Levels ---------
			
			--Higher Values
			if mouseWidth > 1 and mouseWidth < 6 and mouseHeight == 11 then
				if maxFluidTank >= 50000 then
					maxFluidTank = 50000
				else
					maxFluidTank = maxFluidTank + 100
					if maxLevelSteam < maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
			elseif mouseWidth > 6 and mouseWidth < 12 and mouseHeight == 11 then
				if maxFluidTank >= 50000 then
					maxFluidTank = 50000
				else
					maxFluidTank = maxFluidTank + 1000
					if maxLevelSteam < maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
			elseif mouseWidth > 12 and mouseWidth < 20 and mouseHeight == 11 then
				if maxFluidTank >= 50000 then
					maxFluidTank = 50000
				else
					maxFluidTank = maxFluidTank + 10000
					if maxLevelSteam < maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
			
			--Lower Values
			elseif mouseWidth > 1 and mouseWidth < 6 and mouseHeight == 12 then
				if maxFluidTank <= 0 then
					maxFluidTank = 0
				else
					maxFluidTank = maxFluidTank - 1
					if maxLevelSteam > maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 12 then
				if maxFluidTank <= 0 then
					maxFluidTank = 0
				else
					maxFluidTank = maxFluidTank - 100
					if maxLevelSteam > maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
			elseif mouseWidth > 11 and mouseWidth < 20 and mouseHeight == 12 then
				if maxFluidTank <= 0 then
					maxFluidTank = 0
				else
					maxFluidTank = maxFluidTank - 10000
					if maxLevelSteam > maxFluidTank then
						maxLevelSteam = maxFluidTank
					end
				end
				
			--------- Steam Levels ---------
			
			--Higher Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 16 then
				if (minLevelSteam + 1) > maxFluidTank then
					minLevelSteam = maxFluidTank
				else
					minLevelSteam = minLevelSteam + 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 16 then
				if (minLevelSteam + 100) > maxFluidTank then
					minLevelSteam = maxFluidTank
				else
					minLevelSteam = minLevelSteam + 100
				end
			elseif mouseWidth > 10 and mouseWidth < 18 and mouseHeight == 16 then
				if (minLevelSteam + 1000) > maxFluidTank then
					minLevelSteam = maxFluidTank
				else
					minLevelSteam = minLevelSteam + 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 26 and mouseHeight == 16 then
				if (minLevelSteam + 10000) > maxFluidTank then
					minLevelSteam = maxFluidTank
				else
					minLevelSteam = minLevelSteam + 10000
				end
			--Lower Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 17 then
				if (minLevelSteam - 1) < 0 then
					minLevelSteam = 0
				else
					minLevelSteam = minLevelSteam - 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 17 then
				if (minLevelSteam - 100) < 0 then
					minLevelSteam = 0
				else
					minLevelSteam = minLevelSteam - 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 17 then
				if (minLevelSteam - 1000) < 0 then
					minLevelSteam = 0
				else
					minLevelSteam = minLevelSteam - 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 26 and mouseHeight == 17 then
				if (minLevelSteam - 10000) < 0 then
					minLevelSteam = 0
				else
					minLevelSteam = minLevelSteam - 10000
				end
			
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 19 then
				if (maxLevelSteam + 1) > maxFluidTank then
					maxLevelSteam = maxFluidTank
				else
					maxLevelSteam = maxLevelSteam + 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 19 then
				if (maxLevelSteam + 100) > maxFluidTank then
					maxLevelSteam = maxFluidTank
				else
					maxLevelSteam = maxLevelSteam + 100
				end
			elseif mouseWidth > 10 and mouseWidth < 18 and mouseHeight == 19 then
				if (maxLevelSteam + 1000) > maxFluidTank then
					maxLevelSteam = maxFluidTank
				else
					maxLevelSteam = maxLevelSteam + 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 26 and mouseHeight == 19 then
				if (maxLevelSteam + 10000) > maxFluidTank then
					maxLevelSteam = maxFluidTank
				else
					maxLevelSteam = maxLevelSteam + 10000
				end
			--Lower Values
			elseif mouseWidth > 1 and mouseWidth < 5 and mouseHeight == 20 then
				if (maxLevelSteam - 1) < 0 then
					maxLevelSteam = 0
				else
					maxLevelSteam = maxLevelSteam - 1
				end
			elseif mouseWidth > 5 and mouseWidth < 11 and mouseHeight == 20 then
				if (maxLevelSteam - 100) < 0 then
					maxLevelSteam = 0
				else
					maxLevelSteam = maxLevelSteam - 100
				end
			elseif mouseWidth > 11 and mouseWidth < 18 and mouseHeight == 20 then
				if (maxLevelSteam - 1000) < 0 then
					maxLevelSteam = 0
				else
					maxLevelSteam = maxLevelSteam - 1000
				end
			elseif mouseWidth > 18 and mouseWidth < 26 and mouseHeight == 20 then
				if (maxLevelSteam - 10000) < 0 then
					maxLevelSteam = 0
				else
					maxLevelSteam = maxLevelSteam - 10000
				end
			end
		end
	end
	sleep(1.0)
end

function mainMenu()
	terminalOutput()
	initPeripherals()
	while true do
		for i=1,#monitors,1 do
			monitor = peripheral.wrap(monitors[i])
			displayW,displayH=monitor.getSize()
			if displayH == 26 and displayW == 39 then
				for i=1,#monitorsCurrentScreen,1 do
					if monitorsCurrentScreen[i] == "0" then
						drawMainScreen(monitors[i], monitorsCurrentReactor[i])
					elseif monitorsCurrentScreen[i] == "1" then
						drawControlScreen(monitors[i], monitorsCurrentReactor[i], i)
						drawDisplayScreen(monitors[i], monitorsCurrentReactor[i])
					elseif monitorsCurrentScreen[i] == "2" then
						drawControlScreen(monitors[i], monitorsCurrentReactor[i], i)
						drawRodScreen(monitors[i], monitorsCurrentReactor[i])
					elseif monitorsCurrentScreen[i] == "3" then
						drawControlScreen(monitors[i], monitorsCurrentReactor[i], i)
						drawSettingScreen(monitors[i], monitorsCurrentReactor[i])
					end
				end
				management()
			else
				print("This program is built for a 4x4 monitors only!")
				return
			end
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
			checkClickPosition(p1) -- this runs our function
		elseif event=="peripheral" then
			terminalOutput()
			initPeripherals()
		elseif event=="peripheral_detach" then
			terminalOutput()
			initPeripherals()
		end
	end
end

parallel.waitForAny(mainMenu,events)
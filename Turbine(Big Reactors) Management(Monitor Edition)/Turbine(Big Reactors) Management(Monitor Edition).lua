----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "2.2.7"

mouseWidth = 0
mouseHeight = 0

currentTurbine = 1
setting = false
control = false

turbines = {}
turbinesManagement = {}
turbine = null
 
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

function progress_bar_multi_line(x, y, length, minVal, maxVal, bar_color, bg_color, numberOFLine)
	local barSize = math.floor((minVal/maxVal) * length)
	y = y - 1
	for i=1,numberOFLine,1 do
		draw_line(x, y + i, length, bg_color) --background bar
		draw_line(x, y + i, barSize, bar_color)     --progress so far
	end
end

function draw_text(x, y, text, text_color, bg_color)
	monitor.setBackgroundColor(bg_color)
	monitor.setTextColor(text_color)
	monitor.setCursorPos(x,y)
	monitor.write(text)
end

function terminalOutput()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.blue)
	term.setCursorPos(1,1)
	term.write("MJRLegends Turbine Management (Monitor Edition)")
	term.setCursorPos(1,2)
	term.write("Version: " .. version)
end

function initPeripherals()
    local perList = peripheral.getNames()
	local yLevel = 3
	local turbineNumber = 1
	local monitorFound = false
	term.setTextColor(colors.yellow)
    for i=1,#perList,1 do
        if peripheral.getType(perList[i]) == "monitor" and monitorFound == false then
			monitor = peripheral.wrap(perList[i])
			term.setCursorPos(1,yLevel)
			term.write("Monitor Found!")
			yLevel = yLevel + 1
			monitorFound = true
        end
        if peripheral.getType(perList[i]) == "BigReactors-Turbine" then
			table.insert(turbines, turbineNumber, perList[i])
			table.insert(turbinesManagement, turbineNumber, true)
			turbineNumber = turbineNumber +1
        end
    end
	term.setCursorPos(1,yLevel)
	term.write((turbineNumber - 1) .. " Turbine Found!")
	turbine = peripheral.wrap(turbines[currentTurbine])
end

function drawMainScreen()
	displayW,displayH=monitor.getSize()
	monitor.clear()
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(5,1)
	monitor.write("MJRLegends Turbine Management")
	
	monitor.setCursorPos((displayW / 2)-2,2)
	monitor.write("v"..version)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,3)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	numberOfActiveTurbines = 0
	totalBufferedEnergy = 0
	totalBufferedSteam = 0
	totalBufferedWater = 0
	for i=1,#turbines,1 do
		tempTurbine = peripheral.wrap(turbines[i])
		if tempTurbine.getActive() then
			numberOfActiveTurbines = numberOfActiveTurbines + 1
		end
		totalBufferedEnergy = totalBufferedEnergy + tempTurbine.getEnergyStored()
		totalBufferedSteam = totalBufferedSteam + tempTurbine.getInputAmount()
		totalBufferedWater = totalBufferedWater + tempTurbine.getOutputAmount()
	end
	
	monitor.setCursorPos(1,4)
	monitor.write("Number of Online Turbines: " .. numberOfActiveTurbines .. "/" .. table.getn(turbines))
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,5)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	monitor.setCursorPos(1,7)
	monitor.setTextColour(colours.yellow)
	monitor.write("Total Stored Energy: " .. totalBufferedEnergy .. " RF")
	progress_bar_multi_line(2, 8, displayW-2, totalBufferedEnergy, (1000000 * table.getn(turbines)), colors.red, colors.gray, 2)
	monitor.setBackgroundColor(colours.black)
	monitor.setCursorPos(1,11)
	monitor.write("Total Stored Steam: " .. totalBufferedSteam .. " mb")
	progress_bar_multi_line(2, 12, displayW-2, totalBufferedSteam, (4000 * table.getn(turbines)), colors.lightGray, colors.gray, 2)
	monitor.setBackgroundColor(colours.black)
	monitor.setBackgroundColor(colours.black)
	monitor.setCursorPos(1,15)
	monitor.write("Total Stored Water: " .. totalBufferedWater .. " mb")
	progress_bar_multi_line(2, 16, displayW-2, totalBufferedWater, (4000 * table.getn(turbines)), colors.blue, colors.gray, 2)
	monitor.setBackgroundColor(colours.black)
	
	monitor.setTextColour(colours.white)
	monitor.setBackgroundColor(colours.blue)
	monitor.setCursorPos(1,displayH - 0)
	monitor.write("                                        ")
	monitor.setCursorPos(1,displayH - 1)
	monitor.write("             Control Screen             ")
	monitor.setCursorPos(1,displayH - 2)
    monitor.write("                                        ")
	monitor.setBackgroundColor(colours.black)
end

function drawControlScreen()
	displayW,displayH=monitor.getSize()
	monitor.clear()
	active = turbine.getActive()
	energy_stored = turbine.getEnergyStored()

	monitor.clear()
	monitor.setCursorPos(1,1)
	monitor.setTextColour(colours.blue)
	monitor.write("MJRLegends Turbine Management")
	monitor.setTextColour(colours.white)
	w,h=monitor.getSize()
	-----------Turbine ON/OFF---------------------
	monitor.setCursorPos(1,3)
	monitor.write("Turbine: ")
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
	monitor.write(" OFF ")
	monitor.setBackgroundColour(colours.black)	
	
	-------------Multi Turbine Support Controls-------------------
	monitor.setBackgroundColour(colours.blue)
    monitor.setCursorPos(displayW - 8,1)
    monitor.write("<")
    monitor.setCursorPos(displayW - 5,1)
    monitor.write(">")
	monitor.setCursorPos(displayW - 3,1)
	monitor.setBackgroundColour(colours.black) 
	monitor.setTextColour(colours.yellow)
	monitor.write("".. currentTurbine)
	
	-----------Section Lines---------------------
	displayW,displayH=monitor.getSize()
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,2)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,4)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,displayH - 2)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,displayH - 0)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	-----------Bottom Bar Buttons---------------------
	if setting then
		monitor.setBackgroundColour(colours.grey)
    else
		monitor.setBackgroundColour(colours.blue)
    end
	monitor.setCursorPos(displayW - 10,displayH - 1)
    monitor.write(" Settings ")
    monitor.setBackgroundColour(colours.black)
	
	monitor.setBackgroundColour(colours.green)
    monitor.setCursorPos(2,displayH - 1)
    monitor.write(" Main Menu ")
end
 
function drawDisplayScreen()
	displayW,displayH=monitor.getSize()
   
	-----------Router speed---------------------
	draw_text(2, 5, "Routor Speed: ", colors.yellow, colors.black)
	local maxVal = 2000
	local minVal = math.floor(turbine.getRotorSpeed())
	draw_text(19, 5, minVal.." rpm", colors.white, colors.black)

	if minVal < 700 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < 900 then      
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < 1700 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lightBlue, colors.gray)
	elseif minVal < 1900 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.lime, colors.gray)
	elseif minVal < 2000 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.yellow, colors.gray)
	elseif minVal >= 2000 then
	progress_bar(2, 6, displayW-2, minVal, maxVal, colors.red, colors.gray)
	end

	-----------Steam Level---------------------
	draw_text(2, 8, "Steam Amount: ", colors.yellow, colors.black)
	local maxVal = 4000
	local minVal = math.floor(turbine.getInputAmount())
	draw_text(19, 8, minVal.." mB", colors.white, colors.black)
	progress_bar(2, 9, displayW-2, minVal, maxVal, colors.lightGray, colors.gray)


	-----------Water Level---------------------
	draw_text(2, 11, "Water Amount: ", colors.yellow, colors.black)
	local maxVal = 4000
	local minVal = math.floor(turbine.getOutputAmount())
	draw_text(19, 11, minVal.." mB", colors.white, colors.black)
	progress_bar(2, 12, displayW-2, minVal, maxVal, colors.blue, colors.gray)


	-------------OUTPUT-------------------
	draw_text(2, 14, "RF/tick: ", colors.yellow, colors.black)
	rft = math.floor(turbine.getEnergyProducedLastTick())
	draw_text(19, 14, rft.." RF/T", colors.white, colors.black)

	-----------RF STORAGE---------------
	draw_text(2, 15, "RF Stored:", colors.yellow, colors.black)
	local maxVal = 1000000
	local minVal = energy_stored
	local percent = math.floor((energy_stored/maxVal)*100)
	draw_text(19, 15, percent.."%", colors.white, colors.black)

	------------FLOW RATE----------------
	draw_text(2, 16, "Flow Rate: ", colors.yellow, colors.black)
	flow_rate = turbine.getFluidFlowRateMax()
	draw_text(19, 16, flow_rate.." mB/t", colors.white, colors.black)

	------------COILS---------------------------
	engaged = turbine.getInductorEngaged()
	draw_text(2, 17, "Coils: ", colors.yellow, colors.black)

	if engaged then
		draw_text(19, 17, "Engaged", colors.white, colors.black)
	else
		draw_text(19, 17, "Disengaged", colors.white, colors.black)
	end
end

function drawSettingScreen()
	displayW,displayH=monitor.getSize()
	
	-------------Title-------------------
	draw_text(16, 6, "Settings", colors.blue, colors.black)
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,7)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	-----------Turbine Management Enable/Disable---------------------
	monitor.setCursorPos(1,9)
    monitor.write("Turbine Management: ")
    if turbinesManagement[currentTurbine] == true then
		monitor.setBackgroundColour(colours.blue)
    else
		monitor.setBackgroundColour(colours.grey)
    end
    monitor.setCursorPos(20,9)
    monitor.write(" ON  ")
 
    if turbinesManagement[currentTurbine] == true then
		monitor.setBackgroundColour(colours.grey)
    else
		monitor.setBackgroundColour(colours.blue)
    end
    monitor.setCursorPos(25,9)
    monitor.write(" OFF ")
    monitor.setBackgroundColour(colours.black)
end
 
function management()
	for i=1,#turbines,1 do
		if turbinesManagement[i] == true then
			tempTurbine = peripheral.wrap(turbines[i])
			active = tempTurbine.getActive()
			energy_stored = tempTurbine.getEnergyStored()
			rotorSpeed = tempTurbine.getRotorSpeed()
			local maxVal = 1000000
			local minVal = energy_stored
			local percent = math.floor((energy_stored/maxVal)*100)
			if rotorSpeed < 1801 then
				if percent > 99 then
					tempTurbine.setActive(false)
				elseif percent < 75 then
					tempTurbine.setActive(true)
				end
			else
				tempTurbine.setActive(false)
			end
		end
	end
end

function checkClickPosition()
	displayW,displayH=monitor.getSize()
	if control == false then
		if mouseWidth > 0 and mouseWidth < displayW and mouseHeight > displayH - 3 and mouseHeight < displayH then
			control = true
		end	
	else
		if mouseWidth > 20 and mouseWidth < 24 and mouseHeight == 3 then
			turbine.setActive(true)
		elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 3 then
			turbine.setActive(false)
		elseif mouseWidth > 1 and mouseWidth < (displayW - 26) and mouseHeight == (displayH - 1) then
			control = false
			setting = false
		elseif mouseWidth > (displayW - 10) and mouseWidth < displayW and mouseHeight == (displayH - 1) then
			if setting then
				setting = false
			else
				setting = true
			end
		elseif mouseWidth > (displayW - 9) and mouseWidth < (displayW - 7) and mouseHeight == 1 then
			if currentTurbine > 1 then
				currentTurbine = currentTurbine - 1
				turbine = peripheral.wrap(turbines[currentTurbine])
			end
		elseif mouseWidth > (displayW - 6) and mouseWidth < (displayW - 4) and mouseHeight == 1 then
			if currentTurbine < table.getn(turbines) then
				currentTurbine = currentTurbine + 1
				turbine = peripheral.wrap(turbines[currentTurbine])
			end
		end
		if setting then
			if mouseWidth > 20 and mouseWidth < 24 and mouseHeight == 9 then
				turbinesManagement[currentTurbine] = true
			elseif mouseWidth > 24 and mouseWidth < 28 and mouseHeight == 9 then
				turbinesManagement[currentTurbine] = false
			end
		end
	end
	sleep(0.5)
end
 
function mainMenu()
	terminalOutput()
	initPeripherals()
	monitor.setTextScale(1)
	while true do
		displayW,displayH=monitor.getSize()
		if displayH == 26 and displayW == 39 then
			if control == true then
				drawControlScreen()
				if setting == true then
					drawSettingScreen()
				else 
					drawDisplayScreen()
				end
			else
				drawMainScreen()
			end
			management()
		else
			print("This program is built for a 4x4 monitor only!")
			return
		end
		sleep(0.5)
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
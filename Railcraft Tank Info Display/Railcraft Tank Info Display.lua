----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.0.5"

tanks = {}

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
		draw_line(x, y + i, length, bg_color) --backgoround bar
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
	term.write("MJRLegends RailCraft Tanks Display")
	term.setCursorPos(1,2)
	term.write("Version: " .. version)
end

function initPeripherals()
    local perList = peripheral.getNames()
	local yLevel = 3
	local tankNumber = 1
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
        if peripheral.getType(perList[i]) == "rcirontankvalvetile" then
			table.insert(tanks, tankNumber, perList[i])
			tankNumber = tankNumber +1
        end
    end
	term.setCursorPos(1,yLevel)
	term.write((tankNumber - 1) .. " Tanks Found!")
end

function getTank(tankPeriph)
    local tableInfo = tankPeriph.getTankInfo("unknown") -- Local to the getTank function.
 
    fluidRaw = nil
    fluidName = nil
    fluidAmount = nil
    fluidCapacity = tableInfo[1].capacity
 
    local contents = tableInfo[1].contents
 
    if contents then
      fluidRaw = contents.rawName
      fluidAmount = contents.amount
      fluidName = contents.name
    end                                  
 
    return fluidRaw, fluidName, fluidAmount, fluidCapacity -- Returning the values of all tank variables.
end


terminalOutput()
initPeripherals()
displayW,displayH=monitor.getSize()
while true do
	displayW,displayH=monitor.getSize()
	monitor.setTextScale(1)
	monitor.clear()
	
	-----------Title---------------------
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(1,1)
	monitor.write("MJRLegends RailCraft Tanks Display")
	monitor.setTextColour(colours.white)
	
	-----------Section Lines---------------------
	
	monitor.setTextColour(colours.blue)
	monitor.setCursorPos(0,2)
    monitor.write(string.rep("-", displayW))
	monitor.setTextColour(colours.white)
	
	-----------Tanks---------------------
	yLevel = 3
	for i=1,#tanks,1 do
		local fluidRaw, fluidName, fluidAmount, fluidCapacity = getTank(peripheral.wrap(tanks[i]))
		draw_text(2, yLevel, "Tank " .. i .. ": ", colors.yellow, colors.black)
		local maxVal = fluidCapacity
		local minVal = fluidAmount
		if minVal == null then
			minVal = 0
		end
		draw_text(19, yLevel, minVal.." mb", colors.white, colors.black)
		monitor.setBackgroundColour(colours.black)
		progress_bar(2, yLevel + 1, displayW-2, minVal, maxVal, colors.red, colors.gray)
		monitor.setBackgroundColour(colours.black)
		yLevel = yLevel + 3
	end
	sleep(1.0)
end
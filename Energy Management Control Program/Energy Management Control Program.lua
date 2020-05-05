----------- Made BY MJRLegends (Please dont claim as your own code) -----------
version = "1.5.2"

--------------------------------------------------------------
--You can change these:
local upper = 0.98 --Upper limit for computer to stop transmitting redstone signal. 0.98=98% full.
local lower = 0.05 --Lower limit for computer to start transmitting redstone signal.
local redstoneSide = "front" -- Change this to the side you want to output the redstone signal to. ["left","right","top","bottom","front","back","none"]
local capacitorBankBlocks = 0 -- If you have OpenPeripherals without Computronics you need to specify how many blocks your Capacitor Bank contains. Only works properly for one Capacitor Bank. If you have Computronics, this variable won't do anything.
--------------------------------------------------------------

cellCount = 0
connectedCells = {}
connectedMekanisms = {}
connectedOPCapBank = ""
monitorCount = 0
connectedMonitors = {}
TE4Cell = 0 EIOCell = 0 OPCapBank = 0 Mekanism = 0
periList = peripheral.getNames()
validPeripherals = {
    "tile_thermalexpansion_cell",
    "powered_tile",
    "tile_blockcapacitorbank_name",
    "capacitor_bank",
    "monitor",
    "BigReactors%-Turbine",
    "BigReactors%-Reactor",
	"mekanism_machine",
	"Induction Matrix",
	"Energy Cube"
}
term.setTextColor(colors.blue)
term.setCursorPos(1,1)
term.write("MJRLegends Energy Management")
term.setCursorPos(1,2)
term.write("Version: " .. version)
term.setTextColor(colors.white)
term.setCursorPos(1,3)

function checkValidity(periName)
    for n,b in pairs(validPeripherals) do
        if periName:find(b) then return b end
    end
    return false
end

for i,v in ipairs(periList) do
    local periFunctions = {
        ["tile_thermalexpansion_cell"] = function()
            cellCount = cellCount + 1
            TE4Cell= TE4Cell + 1
            connectedCells[cellCount] = periList[i]
        end,
        ["powered_tile"] = function()
            cellCount = cellCount + 1
            TE4Cell= TE4Cell + 1
            connectedCells[cellCount] = periList[i]
        end,
        ["tile_blockcapacitorbank_name"] = function()
            EIOCell = EIOCell + 1
            OPCapBank = OPCapBank + 1
            connectedOPCapBank = periList[i]
        end,
        ["capacitor_bank"] = function()
            cellCount = cellCount + 1
            EIOCell = EIOCell + 1
            connectedCells[cellCount] = periList[i]
        end,
        ["monitor"] = function()
            monitorCount = monitorCount + 1
            connectedMonitors[monitorCount] = periList[i]
        end,
        ["BigReactors%-Turbine"] = function()
            turbine = peripheral.wrap(periList[i])
        end,
        ["BigReactors%-Reactor"] = function()
            reactor = peripheral.wrap(periList[i])
        end,
		["mekanism_machine"] = function()
            cellCount = cellCount + 1
            Mekanism = Mekanism + 1
            connectedMekanisms[cellCount] = periList[i]
        end,
		["Induction Matrix"] = function()
            cellCount = cellCount + 1
            Mekanism = Mekanism + 1
            connectedMekanisms[cellCount] = periList[i]
        end,
		["Energy Cube"] = function()
            cellCount = cellCount + 1
            Mekanism = Mekanism + 1
            connectedMekanisms[cellCount] = periList[i]
        end
    }

    local isValid = checkValidity(peripheral.getType(v))
    if isValid then periFunctions[isValid]() end
end

--Check for storage cells and monitors before continuing
if cellCount == 0 and OPCapBank == 0 then
	term.setTextColor(colors.red)
    print("No RF storage found. Exiting script!")
	term.setTextColor(colors.white)
    return
end
if monitorCount == 0 then
	term.setTextColor(colors.red)
    print("No Monitor found. Exiting script!")
	term.setTextColor(colors.white)
    return
end
    --Compatibility with OpenPeripherals
if OPCapBank > 1 then
    print("Error: Without Computronics this script can only support a maximum of one Capacitor Bank. Exiting Script!")
    return
elseif OPCapBank == 1 and capacitorBankBlocks == 0 then
    print("Warning: You have not entered how many blocks your Capacitor Bank contains, the script will not return the correct numbers. Please fix this by editing the script and changing the variable 'capacitorBankBlocks'.")
elseif OPCapBank == 1 then
    print("Warning: OpenPeripherals does not fully support Capacitor Banks, numbers may not be fully accurate.")
end

function getMonitorSize(x, y)
    return "large"
end

for i = 1, #connectedMonitors do
    local monitor = peripheral.wrap(connectedMonitors[i])
    if getMonitorSize(monitor.getSize()) == nil then
        return
    end
end

term.setTextColor(colors.green)
print("Peripherals connected:")
term.setTextColor(colors.white)
if monitorCount > 1 then print(monitorCount.." Monitors") else print(monitorCount.." Monitor") end
if TE4Cell ~= 1 then print(TE4Cell.." TE Energy Cells") else print(TE4Cell.." TE Energy Cell") end
if Mekanism ~= 1 then print(Mekanism.." Mekanism Cubes/Induction Matrixs") else print(Mekanism.." Mekanism Cube/Induction Matrix") end
if EIOCell ~= 1 then print(EIOCell.." Capacitor Banks") else print(EIOCell.." Capacitor Bank") end
if turbine ~= nil then print ("1 Turbine") else print ("0 Turbines") end
if reactor ~= nil then print ("1 Reactor") else print ("0 Reactors") end

if redstoneSide ~= "none" then redstone.setOutput(redstoneSide, false) end
if turbine ~= nil then turbine.setActive(false) end
if reactor ~= nil then reactor.setActive(false) end

lastTickPower = 0
while true do
    local eNow = 0 eMax = 0 cellLoops = 0 mekanismLoops = 0
    for i = 1, #connectedCells do
        cell = peripheral.wrap(connectedCells[i])
        eNow = eNow + cell.getEnergyStored()
        eMax = eMax + cell.getMaxEnergyStored()
        cellLoops = i
    end
	for i = 1, #connectedMekanisms do
        cell = peripheral.wrap(connectedMekanisms[i])
		if cell.getEnergyStored then
			eNow = eNow + (cell.getEnergyStored() / 2.5)
			eMax = eMax + (cell.getMaxEnergyStored() / 2.5)
		else
			eNow = eNow + (cell.getEnergy() / 2.5)
			eMax = eMax + (cell.getMaxEnergy() / 2.5)
		end
        mekanismLoops = i
    end
    --Compatibility with OpenPeripherals
    if OPCapBank == 1 and cellLoops == #connectedCells then
        cell = peripheral.wrap(connectedOPCapBank)
        eNow = (eNow + cell.getEnergyStored()) * capacitorBankBlocks
        eMax = (eMax + cell.getMaxEnergyStored()) * capacitorBankBlocks
    end
    local fill = eNow / eMax

    if eNow >= 1000000000 then eNowScale = "billion"
    elseif eNow >= 1000000 then eNowScale = "million"
    else eNowScale = "none" end
    if eMax >= 1000000000 then eMaxScale = "billion"
    elseif eMax >= 1000000 then eMaxScale = "million"
    else eMaxScale = "none" end

    if eNowScale == "billion" then eNowValue = math.ceil(eNow / 1000000)
    elseif eNowScale == "million" then eNowValue = math.ceil(eNow / 1000)
    else eNowValue = math.ceil(eNow) end
    if eMaxScale == "billion" then eMaxValue = math.ceil(eMax / 1000000)
    elseif eMaxScale == "million" then eMaxValue = math.ceil(eMax / 1000)
    else eMaxValue = math.ceil(eMax) end

    if eNowScale == "billion" then eNowSuffixLarge = "m RF" eNowSuffixSmall = "mRF"
    elseif eNowScale == "million" then eNowSuffixLarge = "k RF" eNowSuffixSmall = "kRF"
    else eNowSuffixLarge = " RF" eNowSuffixSmall = " RF" end
    if eMaxScale == "billion" then eMaxSuffixLarge = "m RF" eMaxSuffixSmall = "mRF"
    elseif eMaxScale == "million" then eMaxSuffixLarge = "k RF" eMaxSuffixSmall = "kRF"
    else eMaxSuffixLarge = " RF" eMaxSuffixSmall = " RF" end

    local eNowDigitCount = 0 eMaxDigitCount = 0
    for digit in string.gmatch(eNowValue, "%d") do eNowDigitCount = eNowDigitCount + 1 end
    for digit in string.gmatch(eMaxValue, "%d") do eMaxDigitCount = eMaxDigitCount + 1 end

    for i = 1, #connectedMonitors do
        local monitor=peripheral.wrap(connectedMonitors[i])
        if getMonitorSize(monitor.getSize()) == "large" then
			monitor.clear()
            monitor.setCursorPos(1,2)
            monitor.write("Storage:")
            monitor.setCursorPos(1,4)
            monitor.write(eNowValue.."/")
			monitor.setCursorPos((string.len(""..eNowValue) * 1) + 2,4)
			monitor.write(eMaxValue..eMaxSuffixLarge)
			monitor.setCursorPos(1,6)
			monitor.write("I/O:")
            monitor.setCursorPos(6,6)
			monitor.write(math.floor((eNow - lastTickPower) / 20))
			lastTickPower = eNow;

            for i = 1, math.ceil(fill * 10) do
                monitor.setBackgroundColour((colours.green))
                monitor.setCursorPos(24,12-i)
                monitor.write(" ")
                monitor.setBackgroundColour((colours.black))
            end
            for i = 1, 10 - math.ceil(fill * 10) do
                monitor.setBackgroundColour((colours.red))
                monitor.setCursorPos(24,1+i)
                monitor.write(" ")
                monitor.setBackgroundColour((colours.black))
            end
		end
    end
    sleep(1)
end
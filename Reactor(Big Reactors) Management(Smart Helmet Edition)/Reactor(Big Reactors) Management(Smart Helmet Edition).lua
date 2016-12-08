----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.6.0"

antenna = peripheral.wrap("top")

maxFluidTank = 50000
minLevelPower = 5000000
maxLevelPower = 9000000
minLevelSteam = maxFluidTank / 2
maxLevelSteam = maxFluidTank

hudOnOffKey = 49 -- N Key
managementOnOffKey = 38 -- L Key
reactorOnOffKey = 37 -- K Key
cycleKey = 25 -- P Key

reactors = {}
reactorsManagement = {}
players = {}
playersHud = {}
playersCurrent = {}

lastKeyPress = 0

keyPressed = false

function progress_bar(x, y, length, minVal, maxVal, bar_R, bar_B, bar_G, bg_R, bg_B, bg_G)
	playerHUD.drawRectangle(x, y+10, x+length, y, playerHUD.getColorFromRGB(bg_R,bg_B,bg_G,255)) --background bar
	local barSize = math.floor((minVal/maxVal) * length)
	if barSize > 0 then
		playerHUD.drawRectangle(x, y+10, x+barSize, y, playerHUD.getColorFromRGB(bar_R,bar_B,bar_G,255)) --forground bar
	end
end

function terminalOutput()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.blue)
    term.setCursorPos(1,1)
    term.write("MJRLegends Reactor Management (Smart Helmet Edition)")
    term.setCursorPos(1,2)
    term.write("Version: " .. version)
end

function initPeripherals()
    local perList = peripheral.getNames()
    local yLevel = 3
    local reactorNumber = 1
    local monitorFound = false
    term.setTextColor(colors.yellow)
    for i=1,#perList,1 do
        if peripheral.getType(perList[i]) == "BigReactors-Reactor" then
            table.insert(reactors, reactorNumber, perList[i])
            table.insert(reactorsManagement, reactorNumber, true)
            reactorNumber = reactorNumber +1
        end
    end
    term.setCursorPos(1,yLevel)
    term.write((reactorNumber - 1) .. " Reactors Found!")
end

function initHUD()
	tempplayers = antenna.getPlayers()
	for i =1,#tempplayers,1 do
		player = tempplayers[i]
		table.insert(players, i, player)
		table.insert(playersHud, i, true)
		table.insert(playersCurrent, i, 1)
	end
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

function drawHUD()
	for i=1,#players,1 do
		if playersHud[i] == false then
			playerHUD = antenna.getHUD(players[i])
			playerHUD.clear()
		else
			player = players[i]
			playerHUD = antenna.getHUD(player)
			tempReactor = peripheral.wrap(reactors[playersCurrent[i]])
			
			if tempReactor.isActivelyCooled()then
				levelAdd = 60
			else
				levelAdd = 40
			end
			playerHUD.drawRectangle(5,5,185,160 + levelAdd,playerHUD.getColorFromRGB(255,255,255,175))
			playerHUD.drawRectangle(5,170 + levelAdd,185,170 + levelAdd + 60,playerHUD.getColorFromRGB(255,255,255,175))
			
			playerHUD.drawString("------------------------------", 5, 170 + levelAdd, 0, false)
			playerHUD.drawString("HUD ON/OFF: Key N", 10, 180 + levelAdd, 150, false)
			playerHUD.drawString("Reactor ON/OFF: Key K", 10, 190 + levelAdd, 150, false)
			playerHUD.drawString("Management ON/OFF: Key L", 10, 200+ levelAdd, 150, false)
			playerHUD.drawString("Cycle Reactor: Key P", 10, 210 + levelAdd, 150, false)
			playerHUD.drawString("------------------------------", 5, 220 + levelAdd, 0, false)

			playerHUD.drawString("MJRLegends Reactor Management", 10, 10, 189, false)
			playerHUD.drawString("Smart Helmet Edition V" ..version, 30, 19, playerHUD.getColorFromRGB(0,153,0,255), false)
			playerHUD.drawString("------------------------------", 5, 25, 0, false)
			playerHUD.drawString("Current Reactor: ", 10, 30, 189, false)
			playerHUD.drawString(""..playersCurrent[i], 97, 30, playerHUD.getColorFromRGB(255,0,0,255), false)
			playerHUD.drawString("Reactor: ", 10, 40, 189, false)
			if tempReactor.getActive() == true then
				playerHUD.drawString("ON", 52, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			else
				playerHUD.drawString("OFF", 52, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			end
			playerHUD.drawString("Management: ", 102, 40, 189, false)
			if reactorsManagement[playersCurrent[i]] == true then
				playerHUD.drawString("ON", 162, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			else
				playerHUD.drawString("OFF", 162, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			end
			playerHUD.drawString("------------------------------", 5, 45, 0, false)

			playerHUD.drawString("Casing Heat: ", 10, 50, 189, false)
			progress_bar(10,59,165,math.floor(tempReactor.getCasingTemperature()), 5000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempReactor.getCasingTemperature()).." C", 150/2-10, 60,playerHUD.getColorFromRGB(255,0,0,255),false)

			playerHUD.drawString("Fuel Heat: ", 10, 70, 189, false)
			progress_bar(10,79,165,math.floor(tempReactor.getFuelTemperature()), 5000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempReactor.getFuelTemperature()).." C", 150/2-10, 80,playerHUD.getColorFromRGB(255,0,0,255),false)

			level = 30 + levelAdd
			if tempReactor.isActivelyCooled()then
				playerHUD.drawString("Water Tank: ", 10, level, 189, false)
				progress_bar(10,99,165,math.floor(tempReactor.getCoolantAmount()), maxFluidTank, 33, 255, 255, 0, 0, 0)
				playerHUD.drawString(""..math.floor(tempReactor.getCoolantAmount()).." mb", 150/2-20, 100,playerHUD.getColorFromRGB(255,0,0,255),false)

				playerHUD.drawString("Steam Tank: ", 10, level + 20, 189, false)
				progress_bar(10,119,165,math.floor(tempReactor.getHotFluidAmount()), maxFluidTank, 33, 255, 255, 0, 0, 0)
				playerHUD.drawString(""..math.floor(tempReactor.getHotFluidAmount()).." mb", 150/2-20, 120,playerHUD.getColorFromRGB(255,0,0,255),false)
			else
				playerHUD.drawString("Power: ", 10, level + 20, 189, false)
				progress_bar(10,99,165,math.floor(tempReactor.getEnergyStored()), 10000000, 33, 255, 255, 0, 0, 0)
				playerHUD.drawString(""..math.floor(tempReactor.getEnergyStored()).." RF", 150/2-20, 100,playerHUD.getColorFromRGB(255,0,0,255),false)
			end
			level = level + 40			
			playerHUD.drawString("Fuel: ", 10, level, 189, false)
			playerHUD.drawString(""..math.floor(tempReactor.getFuelAmount()).." mb", 10, level + 10, 0, false)

			playerHUD.drawString("Waste: ", 10, level + 20, 189, false)
			playerHUD.drawString(""..math.floor(tempReactor.getWasteAmount()).." mb", 10, level + 30, 0, false)

			if tempReactor.isActivelyCooled()then
				playerHUD.drawString("Hot Fluid/T: ", 10, level + 40, 189, false)
				playerHUD.drawString(""..math.floor(tempReactor.getEnergyProducedLastTick()).." mb", 10, level + 50, 0, false)
			else
				playerHUD.drawString("RF/T: ", 10, level + 40, 189, false)
				playerHUD.drawString(""..math.floor(tempReactor.getEnergyProducedLastTick()).." RF", 10, level + 50, 0, false)
			end

			playerHUD.drawString("Fuel Comsumption: ", 10, level + 60, 189, false)
			playerHUD.drawString(""..tempReactor.getFuelConsumedLastTick().." mb/t", 10, level + 70, 0, false)

			playerHUD.drawString("------------------------------", 5, level + 80, 0, false)
			playerHUD.sync()
		end
	end
end

function mainMenu()
	terminalOutput()
	initPeripherals()
	initHUD()
	while true do
		drawHUD()
		management()
	end
end

function events()
	while true do
		event,p1,p2,p3 = os.pullEvent()
		if p3 == true then
			if p2 == hudOnOffKey then
				numberInList = 0
				for i =1,#players,1 do
					if p1 == players[i] then
						numberInList = i
					end
				end
				if numberInList > 0 then
					if playersHud[numberInList] == true then
						playersHud[numberInList] = false
					else
						playersHud[numberInList] = true
					end
				end
			end
			numberInList = 0
			for i =1,#players,1 do
				if p1 == players[i] then
					numberInList = i
				end
			end
			if playersHud[numberInList] == true then
				if p2 == managementOnOffKey then
					numberInList = 0
					for i =1,#players,1 do
						if p1 == players[i] then
							numberInList = i
						end
					end
					if numberInList > 0 then
						current = playersCurrent[numberInList]
						if reactorsManagement[current] == true then
							reactorsManagement[current] = false
						else
							reactorsManagement[current] = true
						end	
					end
				elseif p2 == reactorOnOffKey then
					numberInList = 0
					for i =1,#players,1 do
						if p1 == players[i] then
							numberInList = i
						end
					end
					if numberInList > 0 then
						current = playersCurrent[numberInList]
						tempReactor = peripheral.wrap(reactors[current])
						if tempReactor.getActive() == true then
							tempReactor.setActive(false)
						else
							tempReactor.setActive(true)
						end
					end
				elseif p2 == cycleKey then
					numberInList = 0
					for i =1,#players,1 do
						if p1 == players[i] then
							numberInList = i
						end
					end
					if playersCurrent[numberInList] == #reactors then
						playersCurrent[numberInList] = 1
					else
						playersCurrent[numberInList] = playersCurrent[numberInList] + 1
					end
				end
			end
		end
	end
end

parallel.waitForAny(mainMenu,events)
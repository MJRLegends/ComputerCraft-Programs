----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 
version = "1.0.0"

antenna = peripheral.wrap("top")

maxFluidTank = 50000
minLevelPower = 5000000
maxLevelPower = 9000000
minLevelSteam = maxFluidTank / 2
maxLevelSteam = maxFluidTank

hudOnOffKey = 49 -- N Key
managementOnOffKey = 38 -- L Key
turbineOnOffKey = 37 -- K Key
cycleKey = 25 -- P Key

turbines = {}
turbinesManagement = {}
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
    term.write("MJRLegends Turbine Management (Smart Helmet Edition)")
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
        if peripheral.getType(perList[i]) == "BigReactors-Turbine" then
            table.insert(turbines, turbineNumber, perList[i])
            table.insert(turbinesManagement, turbineNumber, true)
            turbineNumber = turbineNumber +1
        end
    end
    term.setCursorPos(1,yLevel)
    term.write((turbineNumber - 1) .. " Turbines Found!")
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

function drawHUD()
	for i=1,#players,1 do
		if playersHud[i] == false then
			playerHUD = antenna.getHUD(players[i])
			playerHUD.clear()
		else
			player = players[i]
			playerHUD = antenna.getHUD(player)
			tempTurbine = peripheral.wrap(turbines[playersCurrent[i]])

			playerHUD.drawRectangle(5,5,185,200,playerHUD.getColorFromRGB(255,255,255,175))
			playerHUD.drawRectangle(5,260,185,205,playerHUD.getColorFromRGB(255,255,255,175))
			
			playerHUD.drawString("HUD ON/OFF: Key N", 10, 210, 150, false)
			playerHUD.drawString("Turbine ON/OFF: Key K", 10, 220, 150, false)
			playerHUD.drawString("Management ON/OFF: Key L", 10, 230, 150, false)
			playerHUD.drawString("Cycle Turbine: Key P", 10, 240, 150, false)

			playerHUD.drawString("MJRLegends Turbine Management", 10, 10, 189, false)
			playerHUD.drawString("Smart Helmet Edition V" ..version, 30, 19, playerHUD.getColorFromRGB(0,153,0,255), false)
			playerHUD.drawString("------------------------------", 5, 25, 0, false)
			playerHUD.drawString("Current Turbine: ", 10, 30, 189, false)
			playerHUD.drawString(""..playersCurrent[i], 97, 30, playerHUD.getColorFromRGB(255,0,0,255), false)
			playerHUD.drawString("Turbine: ", 10, 40, 189, false)
			
			if tempTurbine.getActive() == true then
				playerHUD.drawString("ON", 52, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			else
				playerHUD.drawString("OFF", 52, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			end
			playerHUD.drawString("Management: ", 102, 40, 189, false)
			if turbinesManagement[playersCurrent[i]] == true then
				playerHUD.drawString("ON", 162, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			else
				playerHUD.drawString("OFF", 162, 40, playerHUD.getColorFromRGB(255,0,0,255), false)
			end
			playerHUD.drawString("------------------------------", 5, 45, 0, false)
			
			
			playerHUD.drawString("Rotor Speed: ", 10, 50, 189, false)
			progress_bar(10,59,165,math.floor(tempTurbine.getRotorSpeed()), 5000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempTurbine.getRotorSpeed()).." rpm", 150/2-10, 60,playerHUD.getColorFromRGB(255,0,0,255),false)

			playerHUD.drawString("Steam Amount: ", 10, 70, 189, false)
			progress_bar(10,79,165,math.floor(tempTurbine.getInputAmount()), 5000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempTurbine.getInputAmount()).." mb", 150/2-10, 80,playerHUD.getColorFromRGB(255,0,0,255),false)

			playerHUD.drawString("Water Amount: ", 10, 90, 189, false)
			progress_bar(10,99,165,math.floor(tempTurbine.getOutputAmount()), 5000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempTurbine.getOutputAmount()).." mb", 150/2-10, 100,playerHUD.getColorFromRGB(255,0,0,255),false)

			playerHUD.drawString("Power: ", 10, 110, 189, false)
			progress_bar(10,119,165,math.floor(tempTurbine.getEnergyStored()), 1000000, 33, 255, 255, 0, 0, 0)
			playerHUD.drawString(""..math.floor(tempTurbine.getEnergyStored()).." RF", 150/2-20, 120,playerHUD.getColorFromRGB(255,0,0,255),false)
			
			playerHUD.drawString("RF/T: ", 10, 130, 189, false)
			playerHUD.drawString(""..math.floor(tempTurbine.getEnergyProducedLastTick()).." RF/T", 10, 140, 0, false)
				
			playerHUD.drawString("Flow Rate: ", 10, 150, 189, false)
			playerHUD.drawString(""..math.floor(tempTurbine.getFluidFlowRateMax()).." mb/T", 10, 160, 0, false)
				
			playerHUD.drawString("Coils: ", 10, 170, 189, false)
			if tempTurbine.getInductorEngaged() then
				playerHUD.drawString("Engaged", 10, 180, 0, false)
			else
				playerHUD.drawString("Disengaged", 10, 180, 0, false)
			end
				
			playerHUD.drawString("------------------------------", 5, 190, 0, false)
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
						if turbinesManagement[current] == true then
							turbinesManagement[current] = false
						else
							turbinesManagement[current] = true
						end	
					end
				elseif p2 == turbineOnOffKey then
					numberInList = 0
					for i =1,#players,1 do
						if p1 == players[i] then
							numberInList = i
						end
					end
					if numberInList > 0 then
						current = playersCurrent[numberInList]
						tempTurbine = peripheral.wrap(turbines[current])
						if tempTurbine.getActive() == true then
							tempTurbine.setActive(false)
						else
							tempTurbine.setActive(true)
						end
					end
				elseif p2 == cycleKey then
					numberInList = 0
					for i =1,#players,1 do
						if p1 == players[i] then
							numberInList = i
						end
					end
					if playersCurrent[numberInList] == #turbines then
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
----------- Made BY MJRLegends (Please dont claim as your own code) -----------
version = "2.0.2"

--Main Programs
reactorProgram = "CJMFJUEb"
reactorProgramSmartHelmet = "GyZmQB4B"
tubineProgram = "jynMAHYQ"
tubineProgramSmartHelmet = "MYk7Nz45"
fusionreactorProgram = "pk8B7fAM"
newFusionreactorProgram = "5nCJ4QZb"
newFusionreactorProgram2 = "LShKv72C"
energyProgram = "RYN6uUf7"
thermalEvaporationProgram = "9txmi9Q4"
railcraftTanksProgram = "cN7scp9W"

--Other Programs
reactorSimpleProgram = "ktBqnfmn"
tubineSimpleProgram = "LWJ9SYw3"

latestVerions = "wL3rVUqN"
selection = 0
menu = "mainmenu"

function addToCurrentVersions()
	if fs.exists("versions.txt") then
		fs.delete("versions.txt")
	end
	if fs.exists("currentVersions.txt") then
		fs.delete("currentVersions.txt")
	end
	
	shell.run("pastebin get ".. latestVerions .." versions.txt")
	local latestVersions = {}
	file = fs.open("versions.txt","r")
	listElement = file.readLine()
	while listElement do
		table.insert(latestVersions,listElement)
		listElement = file.readLine()
	end
	file.close()
	shell.run("rm versions.txt")
	local file = fs.open("currentVersions.txt","a")
	file.writeLine(latestVersions[tonumber(selection)])
	file.close()
end

--Other Programs Menu
function otherPrograms()
	selection = 0
	term.clear()
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.blue)
	term.setCursorPos(1,1)
	term.write("MJRLegends Other Programs!")
	term.setTextColor(colors.cyan)
	print("")
	print("Enter a number for the program you want to install:")
	term.setTextColor(colors.white)
	print("1 - Simple Display Reactor Info (Monitor Edition)")
	print("2 - Simple Display Turbine Info (Monitor Edition)")
	term.setTextColor(colors.blue)
	print("3 - Back to Main Menu")
	term.setTextColor(colors.cyan)
	
	selection = read()
	--Choice depending on what the user types
	if selection == "1" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. reactorSimpleProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
	elseif selection == "2" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. tubineSimpleProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
	elseif selection == "3" then
		selection = 0
		mainMenu()
	else
		print("Unknown Program!")
	end
end

function mainMenu()
	if selection == 0 then
		-- Main Menu
		term.clear()
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.blue)
		term.setCursorPos(1,1)
		term.write("Welcome to MJRLegends Install Program! V" .. version)
		term.setTextColor(colors.cyan)
		term.setCursorPos(1,2)
		print("Enter a number for the program you want to install:")
		term.setTextColor(colors.white)
		print("1 - Reactor Management(BR/Monitor Edition)")
		print("2 - Reactor Management(BR/Smart Helmet Edition)")
		print("3 - Turbine Management(BR/Monitor Edition)")
		print("4 - Turbine Management(BR/Smart Helmet Edition)")
		print("5 - Fusion Reactor Management(Mekanism 8)")
		print("6 - Fusion Reactor Management(Mekanism 9)")
		print("7 - Fusion Reactor Management(Mekanism 10+)")
		print("8 - Energy Management")
		print("9 - Thermal Evaporation Display (Mekanism 9+)")
		print("10 - RailCraft Tanks Display")
		term.setTextColor(colors.yellow)
		print("11- Versions")
		term.setTextColor(colors.lime)
		print("12- Other Programs")
		term.setTextColor(colors.cyan)

		selection = read()
		term.setTextColor(colors.white)
	end
	--Choice depending on what the user types
	if selection == "1" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. reactorProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "2" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. reactorProgramSmartHelmet .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "3" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. tubineProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "4" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. tubineProgramSmartHelmet .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "5" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. fusionreactorProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "6" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. newFusionreactorProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "7" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. newFusionreactorProgram2 .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "8" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. energyProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "9" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. thermalEvaporationProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "10" then
		if fs.exists("startup") then
			fs.delete("startup")
		end
		shell.run("pastebin get " .. railcraftTanksProgram .. " startup")
		print("Installed!")
		print("Restart the computer using (Ctrl + R)!")
		addToCurrentVersions()
		return
	elseif selection == "11" then
		if fs.exists("versions.txt") then
			fs.delete("versions.txt")
		end
		
		--See Latest versions
		shell.run("pastebin get ".. latestVerions .." versions.txt")
		local latestVersions = {}
		file = fs.open("versions.txt","r")
		listElement = file.readLine()
		while listElement do
			table.insert(latestVersions,listElement)
			listElement = file.readLine()
		end
		file.close()
		term.clear()
		term.setTextColor(colors.blue)
		term.setCursorPos(1,1)
		term.write("Latest Versions")
		yLevel = 2
		for i,v in pairs(latestVersions) do
			if (yLevel % 2 == 0) then
				term.setTextColor(colors.yellow)
			else
				term.setTextColor(colors.lime)
			end
			term.setCursorPos(1,yLevel)
			term.write(v)
			yLevel = yLevel + 1
		end
		yLevel = yLevel - 1
		--See Current versions
		if fs.exists("currentVersions.txt") then
			yLevel = yLevel + 1
			term.setTextColor(colors.blue)
			term.setCursorPos(1,yLevel)
			term.write("Current Versions")
			yLevel = yLevel+1
			local currentVersions = {}
			file = fs.open("currentVersions.txt","r")
			listElement2 = file.readLine()
			while listElement2 do
				table.insert(currentVersions,listElement2)
				listElement2 = file.readLine()
			end
			file.close()
				
			for i,v in pairs(currentVersions) do
				term.setTextColor(colors.yellow)
				term.setCursorPos(1,yLevel)
				term.write(v)
				yLevel = yLevel + 1
			end
			print()
		end
		print()
		term.setTextColor(colors.blue)
		print("1 - Back to Main Menu")
		selection = 0
		selection = read()
		if selection == "1" then
			selection = 0
			mainMenu()
		end
	elseif selection == "12" then
		otherPrograms()
	else
		print("Unknown Program!")
	end
end

if selection == 0 then
	mainMenu()
end
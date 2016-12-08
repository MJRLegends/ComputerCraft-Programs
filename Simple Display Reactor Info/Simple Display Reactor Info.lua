while true do
	local reactor1 = peripheral.wrap("BigReactors-Reactor_0")
	local mon = peripheral.wrap("monitor_3")
	mon.clear()

	-- Begin Reactor 1
	--mon.setCursorPos(1,1)
	--mon.setTextColor(colors.white)
	--mon.write("Reactor #: ")
	--mon.setTextColor(colors.lime)
	--mon.write("1")

	mon.setCursorPos(1,1)
	mon.setTextColor(colors.white)
	mon.write("Active: ")
	mon.setTextColor(colors.lime)
	mon.write(reactor1.getActive())

	mon.setCursorPos(1,2)
	mon.setTextColor(colors.white)
	if reactor1.isActivelyCooled then
		mon.write("RF/T: ")
	else
		mon.write("Hot Fluid/T: ")
	end
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getEnergyProducedLastTick()))

	mon.setCursorPos(1,3)
	mon.setTextColor(colors.white)
	mon.write("Casing Heat: ")
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getCasingTemperature()))

	mon.setCursorPos(1,4)
	mon.setTextColor(colors.white)
	mon.write("Fuel Heat: ")
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getFuelTemperature()))
	
	mon.setCursorPos(1,5)
	mon.setTextColor(colors.white)
	mon.write("Fuel: ")
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getFuelAmount()))
	
	mon.setCursorPos(1,6)
	mon.setTextColor(colors.white)
	mon.write("Waste: ")
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getWasteAmount()))
	
	mon.setCursorPos(1,7)
	mon.setTextColor(colors.white)
	mon.write("Fuel Reactivity: ")
	mon.setTextColor(colors.lime)
	mon.write(math.floor(reactor1.getFuelReactivity()))
	
	mon.setCursorPos(1,7)
	mon.setTextColor(colors.white)
	mon.write("Fuel Comsumption: ")
	mon.setTextColor(colors.lime)
	mon.write(reactor1.getFuelConsumedLastTick())
	
	if reactor1.isActivelyCooled()then
		mon.setCursorPos(1,8)
		mon.setTextColor(colors.white)
		mon.write("Water Tank: ")
		mon.setTextColor(colors.lime)
		mon.write(reactor1.getCoolantAmount())
		
		mon.setCursorPos(1,9)
		mon.setTextColor(colors.white)
		mon.write("Hot Fluid: ")
		mon.setTextColor(colors.lime)
		mon.write(reactor1.getHotFluidAmount())
	else
		mon.setCursorPos(1,8)
		mon.setTextColor(colors.white)
		mon.write("RF Stored: ")
		mon.setTextColor(colors.lime)
		mon.write(math.floor(reactor1.getEnergyStored()))
	end

	-- End Reactor 1

	sleep(2)
end
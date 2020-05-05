----------- Made BY MJRLegends (Please dont claim as your own code) ----------- 

while true do
  local turbine = peripheral.wrap("BigReactors-Turbine_0") -- Change to your name of Turbine
  local mon = peripheral.wrap("monitor_0") -- Change to your name of Mointor
  mon.clear()
 
  -- Begin Turbine 1
  mon.setCursorPos(1,1)
	mon.setTextColor(colors.white)
	mon.write("Turbine #: "1")
    
  mon.setCursorPos(1,2)
  mon.setTextColor(colors.white)
  mon.write("Active: ")
  mon.setCursorPos(1,3)
  mon.setTextColor(colors.lime)
  mon.write(turbine.getActive())
   
  mon.setCursorPos(1,4)
  mon.setTextColor(colors.white)
  mon.write("RF/T: ")  
  mon.setCursorPos(1,5)
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getEnergyProducedLastTick()))
 
  mon.setCursorPos(1,6)
  mon.setTextColor(colors.white)
  mon.write("RF Stored: ")
  mon.setCursorPos(1,7)
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getEnergyStored()))
 
  mon.setCursorPos(1,8)
  mon.setTextColor(colors.white)
  mon.write("Rotor Speed: ")
  mon.setCursorPos(1,9)
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getRotorSpeed()))
 
  mon.setCursorPos(1,10)
  mon.setTextColor(colors.white)
  mon.write("Fluid Rate: ")
  mon.setCursorPos(1,11)
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getInputAmount()))
  -- End Reactor 1

sleep(2)
end

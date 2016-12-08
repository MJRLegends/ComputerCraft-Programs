while true do
  local turbine = peripheral.wrap("BigReactors-Turbine_0")
  local mon = peripheral.wrap("monitor_0")
  mon.clear()
 
  -- Begin Turbine
  mon.setCursorPos(1,1)
  mon.setTextColor(colors.white)
  mon.write("Active: ")
  mon.setTextColor(colors.lime)
  mon.write(turbine.getActive())
   
  mon.setCursorPos(1,2)
  mon.setTextColor(colors.white)
  mon.write("RF/T: ")  
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getEnergyProducedLastTick()))
 
  mon.setCursorPos(1,3)
  mon.setTextColor(colors.white)
  mon.write("RF Stored: ")
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getEnergyStored()))
 
  mon.setCursorPos(1,4)
  mon.setTextColor(colors.white)
  mon.write("Rotor Speed: ")
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getRotorSpeed()))
 
  mon.setCursorPos(1,5)
  mon.setTextColor(colors.white)
  mon.write("Fluid Rate: ")
  mon.setTextColor(colors.lime)
  mon.write(math.floor(turbine.getInputAmount()))
  -- End Reactor 1

sleep(2)
end
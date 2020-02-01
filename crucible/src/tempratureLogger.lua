local component = require("component")
local sides = require("sides")

local SLEEP_TIME = 0.5

local logFile = io.open("/home/temp/tempLog", "w")
local thermSensor = component.thermometer_sensor

while component.redstone.getInput()[sides.top] == 15 do
  local s = thermSensor.getval().."\n"
  logFile:write(s)
  os.sleep(SLEEP_TIME)
end

logFile:flush()
logFile:close()

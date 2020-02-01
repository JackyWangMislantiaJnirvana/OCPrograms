local component = require("component")
local colors = require("colors")
local sides = require("sides")

local tempSensor = component.thermometer_sensor
local contentSensor = component.medium_weight_o_meter_sensor
local redBus = component.redstone

local REDBUS_SIDE = sides.top
local REDBUS_COLORS = {
  graphiteDropper = colors.orange,
  blacksandDropper = colors.white,
  stopper = colors.magenta
}

local logFile = io.open("/home/temp.log", "w")

local function isCrucibleEmpty()
  return contentSensor.getval() == 0
end

local function dropItem()
  for _ = 1, 6 do
    redBus.setBundledOutput(REDBUS_SIDE, REDBUS_COLORS.graphiteDropper, 15)
    os.sleep(0.2)
    redBus.setBundledOutput(REDBUS_SIDE, REDBUS_COLORS.graphiteDropper, 0)
    os.sleep(0.2)
  end

  for _ = 1, 14 do
    redBus.setBundledOutput(REDBUS_SIDE, REDBUS_COLORS.blacksandDropper, 15)
    os.sleep(0.2)
    redBus.setBundledOutput(REDBUS_SIDE, REDBUS_COLORS.blacksandDropper, 0)
    os.sleep(0.2)
  end
end

local function eStop()
  redBus.setBundledOutput(REDBUS_SIDE, REDBUS_COLORS.stopper, 15)
  os.sleep(5)
end

redBus.setBundledOutput(
        REDBUS_SIDE,
        {
          [REDBUS_COLORS.graphiteDropper] = 0,
          [REDBUS_COLORS.blacksandDropper] = 0,
          [REDBUS_COLORS.stopper] = 0
        }
)
while true do
  if tempSensor.getval() >= 2300 then
    eStop()
    io.stderr:write("Emergency-Stopped! Check about fault.\n")
    break
  elseif isCrucibleEmpty() then
    dropItem()
    io.stdout:write("Added one smelting unit to crucible.\n")
  end

  logFile:write(tempSensor.getval().."\n")
  logFile:flush()
  os.sleep(0.5)
end

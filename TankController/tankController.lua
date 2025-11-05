local engineRPS = property.getNumber("Engine RPS") -- revolutions per second
local angVelLimiter = property.getNumber("Rotation Speed Limit") -- rad/s
local maxSpeed = property.getNumber("Max Speed") -- m/s
local outputType = property.getBool("Engine Out Type") -- rps val = true, 0-1 throttle = false

local function clamp(val, min_val, max_val)
    return math.max(min_val, math.min(max_val, val))
end

function onTick()
    -- inputs
    local throttle = input.getNumber(1)
    local steer = input.getNumber(2)
    local brakeInput = input.getBool(1)

    -- sensors
    local angVel = input.getNumber(3)
    local linVel = input.getNumber(4)

    -- outputs 
    local brake = false
    local rReverse = false
    local lReverse = false
    local rClutch = 0
    local lClutch = 0
    local engine = 0

    -- initial track speed
    local leftSpeed = throttle + steer
    local rightSpeed = throttle - steer

    -- engine speed
    local engine = math.max(math.abs(leftSpeed), math.abs(rightSpeed))
    
    -- reverse gearbox if track speed is reverse
    lReverse = (leftSpeed < 0)
    rReverse = (rightSpeed < 0)
    
    -- clutch slipping logic
    if engine > 0.01 then
        lClutch = math.abs(leftSpeed) / engine
        rClutch = math.abs(rightSpeed) / engine
    else
        lClutch = 0.0
        rClutch = 0.0
    end
    
    -- clamp just in case
    lClutch = clamp(lClutch, 0.0, 1.0)
    rClutch = clamp(rClutch, 0.0, 1.0)
    
    -- highly experimental code for linear/rotation speed limit
    --[[ if math.abs(angVel) > angVelLimiter then
        lClutch = 0.0
        rClutch = 0.0
    end
    
    if math.abs(linVel) > maxSpeed then -- problem i see here is loss of controll on downhill
        lClutch = 0.0
        rClutch = 0.0
    end ]]
    
    -- 0 - 1.0 or 0 - engineRPS output (output to external speed controller/use internal jet controller)
    if outputType == false then
        engine = clamp(engine, 0.0, 1.0)
    else
        engine = clamp(engine, 0.0, 1.0)
        engine = engine * engineRPS
    end
    
    -- brake logic
    if brakeInput then
        brake = true
        lClutch = 0.0
        rClutch = 0.0
    end
 
    -- encode outputs
    output.setBool(1, brake)
    output.setBool(2, rReverse)
    output.setBool(3, lReverse)
    output.setNumber(1, rClutch)
    output.setNumber(2, lClutch)
    output.setNumber(3, engine) -- set different output types in mc or have 2 different mcs for jet/other power
end
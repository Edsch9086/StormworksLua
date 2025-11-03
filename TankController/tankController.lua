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

    local leftSpeed = throttle + steer
    local rightSpeed = throttle - steer

    local max_speed_abs = math.max(math.abs(leftSpeed), math.abs(rightSpeed))
    engine = max_speed_abs
    
    lReverse = (leftSpeed < 0)
    rReverse = (rightSpeed < 0)
    
    if max_speed_abs > 0.01 then
        lClutch = math.abs(leftSpeed) / max_speed_abs
        rClutch = math.abs(rightSpeed) / max_speed_abs
    else
        lClutch = 0.0
        rClutch = 0.0
    end
    
    lClutch = clamp(lClutch, 0.0, 1.0)
    rClutch = clamp(rClutch, 0.0, 1.0)
    
    if math.abs(angVel) > angVelLimiter then
        lClutch = 0.0
        rClutch = 0.0
    end
    
    if math.abs(linVel) > maxSpeed then
        lClutch = 0.0
        rClutch = 0.0
    end
    
    if outputType == false then
        engine = clamp(engine, 0.0, 1.0)
    else
        engine = clamp(engine, 0.0, 1.0) -- keep between 0 and 1 for now, multiply later
        engine = engine * engineRPS
    end
    
    if brakeInput then
        brake = true
        engine = 0.0
        lClutch = 0.0
        rClutch = 0.0
    end
 
    output.setBool(1, brake)
    output.setBool(2, rReverse)
    output.setBool(3, lReverse)
    output.setNumber(1, rClutch)
    output.setNumber(2, lClutch)
    output.setNumber(3, engine)
end
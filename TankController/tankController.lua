local engineRPS = property.getNumber("Engine RPS") -- revolutions per second
local angVelLimiter = property.getNumber("Rotation Speed Limit") -- rad/s
local maxSpeed = property.getNumber("Max Speed") -- m/s
local outputType = property.getBool("Engine Out Type") -- rps val = true, 0-1 throttle = false

-- cache math functions to locals for faster access in onTick
local math_abs = math.abs
local math_max = math.max
local math_min = math.min

local function clamp(val, min_val, max_val)
    -- use localized math functions
    return math_max(min_val, math_min(max_val, val))
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

    -- engine speed (use localized math functions and avoid double abs calls)
    local leftAbs = math_abs(leftSpeed)
    local rightAbs = math_abs(rightSpeed)
    if leftAbs > rightAbs then
        engine = leftAbs
    else
        engine = rightAbs
    end

    -- reverse gearbox if track speed is reverse
    lReverse = (leftSpeed < 0)
    rReverse = (rightSpeed < 0)

    -- clutch slipping logic: avoid division when engine is effectively zero
    if engine > 0.01 then
        lClutch = leftAbs / engine
        rClutch = rightAbs / engine
    else
        lClutch = 0.0
        rClutch = 0.0
    end

    -- cheap clamp without function call (fewer math ops)
    if lClutch < 0.0 then lClutch = 0.0 elseif lClutch > 1.0 then lClutch = 1.0 end
    if rClutch < 0.0 then rClutch = 0.0 elseif rClutch > 1.0 then rClutch = 1.0 end
    
    -- highly experimental code for linear/rotation speed limit
    --[[ if math.abs(angVel) > angVelLimiter then
        lClutch = 0.0
        rClutch = 0.0
    end
    
    if math.abs(linVel) > maxSpeed then
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
local module = property.getNumber("Module ID")
local doWheelReverse = property.getBool("Enable Wheel Reverse")

-- declare now, dont waste time later
targetBuffer = 0
outputRotation = 0
angleIncrement = 0

function onTick()
    -- get inputs
    local speed = input.getNumber(module)
    local target = input.getNumber(module + 10) / 180
    local brake = input.getNumber(5)
    local lastTarget = outputRotation * 2
    
    -- find delta of target from last target
    local delta = ((target - lastTarget + 1) % 2) - 1
    
    -- motor reverse optimise
    if doWheelReverse == true then -- reverse motor if rotation > 180 degrees
        if delta > 0.5 then
            delta = delta - 1
            speed = -speed
        elseif delta < -0.5 then 
            delta = delta + 1
            speed = -speed
        end
    else -- if not set in microcontroller, dont reverse motor
        speed = math.abs(speed)
    end
    
    -- optimize target (dont spin 360 degrees if not needed)
    local optimizedTarget = lastTarget + delta
    local value = optimizedTarget * 0.5
    
    -- smooth rotation
    if value ~= targetBuffer then
        angleIncrement = value - outputRotation
        targetBuffer = value
    end
    
    outputRotation = math.clamp(outputRotation + angleIncrement, math.min(outputRotation, value), math.max(outputRotation, value))
    
    -- encode
    output.setNumber(1, outputRotation)
    output.setNumber(2, speed)
    output.setNumber(3, brake)
end

function math.clamp(val, lower, upper)
    return math.min(math.max(val, lower), upper)
end
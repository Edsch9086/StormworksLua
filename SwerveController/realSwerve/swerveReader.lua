local module = property.getNumber("Module ID")
local doWheelReverse = property.getBool("Enable Wheel Reverse")

<<<<<<< HEAD
-- declare now, dont waste time later
=======
function math.clamp(val, lower, upper)
    return math.min(math.max(val, lower), upper)
end

-- declare now to not waste time later
>>>>>>> 64ebf0de3b9b414b20301bd9ffd5bc90a429fa1b
targetBuffer = 0
outputRotation = 0
angleIncrement = 0

function onTick()
<<<<<<< HEAD
    -- get inputs
=======
    -- get mcu inputs
>>>>>>> 64ebf0de3b9b414b20301bd9ffd5bc90a429fa1b
    local speed = input.getNumber(module)
    local target = input.getNumber(module + 10) / 180
    local brake = input.getNumber(5)
    local lastTarget = outputRotation * 2
    
<<<<<<< HEAD
    -- find delta of target from last target
    local delta = ((target - lastTarget + 1) % 2) - 1
    
    -- motor reverse optimise
    if doWheelReverse == true then -- reverse motor if rotation > 180 degrees
=======
    -- 
    local delta = ((target - lastTarget + 1) % 2) - 1

    -- reverse the motor if the wheel is turning more than 180 degrees
    if doWheelReverse == true then
>>>>>>> 64ebf0de3b9b414b20301bd9ffd5bc90a429fa1b
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
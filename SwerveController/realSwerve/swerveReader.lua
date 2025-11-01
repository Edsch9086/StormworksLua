local module = property.getNumber("Module ID")

function math.clamp(val, lower, upper)
    return math.min(math.max(val, lower), upper)
end

targetBuffer = 0
outputRotation = 0
angleIncrement = 0

function onTick()
    local speed = input.getNumber(module)
    local target = input.getNumber(module + 10) / 180
    local brake = input.getNumber(5)
    lastTarget = outputRotation * 2
    
    local delta = ((target - lastTarget + 1) % 2) - 1

    if delta > 0.5 then
        delta = delta - 1
        speed = -speed
    elseif delta < -0.5 then
        delta = delta + 1
        speed = -speed
    end
    
    local optimizedTarget = lastTarget + delta
    local value = optimizedTarget * 0.5
    
    if value ~= targetBuffer then
        angleIncrement = value - outputRotation
        targetBuffer = value
    end
    
    outputRotation = math.clamp(outputRotation + angleIncrement, math.min(outputRotation, value), math.max(outputRotation, value))
    
    output.setNumber(1, outputRotation)
    output.setNumber(2, speed)
    output.setNumber(3, brake)
end
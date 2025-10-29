function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

buffer = 0
endval = 0
inc = 0

function onTick()
    module = property.getNumber("Module ID")
    speed = input.getNumber(module)
    target = input.getNumber(module + 10) / 180
    lastTarget = endval * 2
    
    delta = target - lastTarget
    
    while delta > 1 do delta = delta - 2 end
    while delta < -1 do delta = delta + 2 end
    
    if delta > 0.5 then
        delta = delta - 1
        speed = -speed
    elseif delta < -0.5 then
        delta = delta + 1
        speed = -speed
    end
    
    optimizedTarget = lastTarget + delta
    value = optimizedTarget * 0.5
    
    if value ~= buffer then
        inc = value - endval
        buffer = value
    end
    
    endval = math.clamp(endval + inc, endval, value)
    
    output.setNumber(1, endval)
    output.setNumber(2, speed)
end
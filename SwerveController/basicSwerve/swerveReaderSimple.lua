local module = property.getNumber("Module ID")

function onTick()
    local speed = input.getNumber(module)
    local target = input.getNumber(module + 10) / 180

    output.setNumber(1, target)
    output.setNumber(2, speed)
end
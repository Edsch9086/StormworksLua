function onTick()
    -- did the chassis reach the last auton waypoint?
    local wpAchv = input.getBool(1)

    -- wp coord list
    local x1 = getBool(1)
    local y1 = getBool(2)
    local x2 = getBool(3)
    local y2 = getBool(4)
    local x3 = getBool(5)
    local y3 = getBool(6)
    local x4 = getBool(7)
    local y4 = getBool(8)
    local x5 = getBool(9)
    local x5 = getBool(10)

    -- wp target
    local targX = 0
    local targY = 0

    output.setNumber(1, targX)
    output.setNumber(2, targY)
end
currentWaypoint = currentWaypoint or 1
function onTick()
    -- get wp values
    local waypoints = {
        {input.getNumber(1), input.getNumber(2)},
        {input.getNumber(3), input.getNumber(4)},
        {input.getNumber(5), input.getNumber(6)},
        {input.getNumber(7), input.getNumber(8)},
        {input.getNumber(9), input.getNumber(10)},
    }
    local wpAchv = input.getBool(1)

    -- check if chassis is at last wp

    -- only switch wp when wpAchv switches to true
    prevWpAchv = prevWpAchv or false
    if wpAchv and not prevWpAchv then
        currentWaypoint = currentWaypoint + 1
        if currentWaypoint > #waypoints then
            if property.getBool("Auton Loop") == true then
                currentWaypoint = 1
            else
                currentWaypoint = #waypoints
            end
        end
    end
    prevWpAchv = wpAchv

    -- Output the target waypoint
    local wp = waypoints[currentWaypoint]
    output.setNumber(1, wp[1])
    output.setNumber(2, wp[2])
end
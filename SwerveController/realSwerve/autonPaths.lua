    currentWaypoint = currentWaypoint or 1

    function onTick()
    --[[   -- get wp values
        local waypoints = {
            {input.getNumber(1), input.getNumber(2)},
            {input.getNumber(3), input.getNumber(4)},
            {input.getNumber(5), input.getNumber(6)},
            {input.getNumber(7), input.getNumber(8)},
            {input.getNumber(9), input.getNumber(10)},
        }

        -- check if chassis is at last wp
        local wpAchv = input.getBool(1)

        -- only switch wp when wpAchv switches to true
        prevWpAchv = prevWpAchv or false
        if wpAchv and not prevWpAchv then
            currentWaypoint = currentWaypoint + 1
            
            -- Skip waypoints with zero coordinates
            while currentWaypoint <= #waypoints do
                local wp = waypoints[currentWaypoint]
                if wp[1] ~= 0 or wp[2] ~= 0 then
                    break  -- Found a valid waypoint
                end
                currentWaypoint = currentWaypoint + 1
            end
            
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
        output.setNumber(2, wp[2]) ]]
        output.setNumber(1, input.getNumber(1))
        output.setNumber(2, input.getNumber(2))
    end
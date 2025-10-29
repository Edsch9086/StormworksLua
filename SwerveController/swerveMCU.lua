local length = property.getNumber("Chassis Length")
local width = property.getNumber("Chassis Width")
local driveMultiplier = property.getNumber("Drive Multiplier")
local steeringMultiplier = property.getNumber("Steering Multiplier")

function onTick()
    local yDir = input.getNumber(1) * driveMultiplier
    local xDir = input.getNumber(2) * driveMultiplier
    local rotation = input.getNumber(3) * steeringMultiplier * 0.1
    local compass = input.getNumber(4)
    local modeCoast = property.getBool("Coast Mode")
    local worldCentric = property.getBool("World/Robot Centric")
    local resetGyro = property.getBool(1)


    if worldCentric = true then -- 
		
    else 
        local xVel = xDir
        yVel = yDir
    end
	

    local A = xVel - (rotation*length)/2
    local B = xVel + (rotation*length)/2
    local C = yVel - (rotation*width)/2
    local D = yVel + (rotation*width)/2

    local s1, a1 = calculateWheel(B, C) -- grab angle, compensate speed if > 1
    local s2, a2 = calculateWheel(B, D)
    local s3, a3 = calculateWheel(A, D)
    local s4, a4 = calculateWheel(A, C)
    local maxSpeed = math.max(s1, s2, s3, s4)

    if maxSpeed > 1 then
        s1 = s1/maxSpeed
        s2 = s2/maxSpeed
        s3 = s3/maxSpeed
        s4 = s4/maxSpeed
    end

    output.setNumber(1, s1) -- speed encode
    output.setNumber(2, s2)
    output.setNumber(3, s3)
    output.setNumber(4, s4)
    output.setNumber(11, a1) -- angle encode
    output.setNumber(12, a2)
    output.setNumber(13, a3)
    output.setNumber(14, a4)
end

function Calc(X,Y)
	local speed = math.sqrt(X^2 + Y^2)
	local angle = math.atan(X, Y)*180/math.pi
	return speed, angle
end

function orient(xDir, yDir, resetGyro)

end

--[[ old speed/angle ()
function speed(X, Y)
    return math.sqrt(X^2 + Y^2)
end

function angle(X, Y)
    return math.atan(X,Y)*180/math.pi
end
]]







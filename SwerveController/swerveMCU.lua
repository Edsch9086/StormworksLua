function onTick()
	modeCoast = property.getBool("Coast Mode")
	worldCentric = property.getBool("World/Robot Centric")
    resetGyro = property.getbool(1)
    yDir = input.getNumber(1) * property.getNumber("Drive Multiplier")
    xDir = input.getNumber(2) * property.getNumber("Drive Multiplier")
    rotation = input.getNumber(3) * property.getNumber("Steering Multiplier") * 0.1
    compass = input.getNumber(4) -- range: +-0.5, 0 = 0*, 0.25 = +90, -0.25 = 270, |+-0.5| = 180
    length = property.getNumber("Chassis Length")
    width = property.getNumber("Chassis Width")

    if worldCentric = true then -- 
		
    else 
        local xVel = xDir
        yVel = yDir
    end
	

    local A = xVel - (rotation*length)/2
    local B = xVel + (rotation*length)/2
    local C = yVel - (rotation*width)/2
    local D = yVel + (rotation*width)/2

    local s1 = select(1, Calc(B,C)) -- speed compensate > 1
    local s2 = select(1, Calc(B,D))
    local s3 = select(1, Calc(A,D))
    local s4 = select(1, Calc(A,C))
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
    output.setNumber(11, select(2, Calc(B,C))) -- angle encode
    output.setNumber(12, select(2, Calc(B,D)))
    output.setNumber(13, select(2, Calc(A,D)))
    output.setNumber(14, select(2, Calc(A,C)))
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






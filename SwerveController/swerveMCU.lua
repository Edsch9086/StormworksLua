function onTick()
	modeCoast = property.getBool("Coast Mode")
	worldCentric = property.getBool("World/Robot Centric")
    yVel = input.getNumber(1) * property.getNumber("Drive Multiplier")
    xVel = input.getNumber(2) * property.getNumber("Drive Multiplier")
    rotation = input.getNumber(3) * property.getNumber("Steering Multiplier") * 0.1
    compass = input.getNumber(4) -- range: +-0.5, 0 = 0*, 0.25 = +90, -0.25 = 270, |+-0.5| = 180
    length = property.getNumber("Chassis Length")
    width = property.getNumber("Chassis Width")

    A = xVel - (rotation*length)/2
    B = xVel + (rotation*length)/2
    C = yVel - (rotation*width)/2
    D = yVel + (rotation*width)/2

    s1 = speed(B, C)
    s2 = speed(B, D)
    s3 = speed(A, D)
    s4 = speed(A, C)
    maxSpeed = math.max(s1, s2, s3, s4)

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
    output.setNumber(11, angle(B,C)) -- angle encode
    output.setNumber(12, angle(B,D))
    output.setNumber(13, angle(A,D))
    output.setNumber(14, angle(A,C))
end

-- speed/angle
function speed(X, Y)
    return math.sqrt(X^2 + Y^2)
end

function angle(X, Y)
    return math.atan(X,Y)*180/math.pi
end





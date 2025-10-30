local length = property.getNumber("Chassis Length") -- static vars defined in controller properties
local width = property.getNumber("Chassis Width")

function onTick()
	-- control inputs
    local yDir = input.getNumber(1) 
    local xDir = input.getNumber(2)
    local rotation = input.getNumber(3) * 0.1
    
	-- define wheel vector locations
    local A = xDir - (rotation*length)/2 
    local B = xDir + (rotation*length)/2
    local C = yDir - (rotation*width)/2
    local D = yDir + (rotation*width)/2

	-- get angle, speed
    local s1, a1 = calculateWheel(B, C)
    local s2, a2 = calculateWheel(B, D)
    local s3, a3 = calculateWheel(A, D)
    local s4, a4 = calculateWheel(A, C)

	-- compensate if max motor speed > 1
    local maxSpeed = math.max(s1, s2, s3, s4) 
	if maxSpeed > 1 then
        s1 = s1/maxSpeed
        s2 = s2/maxSpeed
        s3 = s3/maxSpeed
        s4 = s4/maxSpeed
    end
	-- speed encode
    output.setNumber(1, s1) 
    output.setNumber(2, s2)
    output.setNumber(3, s3)
    output.setNumber(4, s4)
	-- angle encode
    output.setNumber(11, a1) 
    output.setNumber(12, a2)
    output.setNumber(13, a3)
    output.setNumber(14, a4)
end

-- wheel speed and angle
function calculateWheel(X, Y) 
	local speed = math.sqrt(X^2 + Y^2)
	local angle = math.atan(X, Y)*180/math.pi
	return speed, angle
end

local length = property.getNumber("Chassis Length")
local width = property.getNumber("Chassis Width")
local driveMultiplier = property.getNumber("Drive Multiplier")
local steeringMultiplier = property.getNumber("Steering Multiplier")

function onTick()
    local yDir = input.getNumber(1) * driveMultiplier
    local xDir = input.getNumber(2) * driveMultiplier
    local rotation = input.getNumber(3) * steeringMultiplier * 0.1
    local worldYaw = input.getNumber(4)
	-- local worldX = input.getNumber(5)
	-- local worldY = input.getNumber(6)
	-- local roll = input.getNumber(7)
	-- local pitch = input.getnumber(8)
	-- local rotSpeed = input.getNumber(9)
	-- local linSpeed = input.getNumber(10)
    local modeCoast = property.getBool("Coast Mode")
    local worldCentric = property.getBool("World/Robot Centric")
    local resetGyro = property.getBool(1)
	local softBrake = property.getBool(2)
	local hardBrake = property.getBool(3)

    if worldCentric == true then -- world/field centric control
		xVel, yVel = orient(xDir, yDir, worldYaw, resetGyro)
    else 
        xVel = xDir
        yVel = yDir
    end
	
    local A = xVel - (rotation*length)/2 -- define wheel vector locations
    local B = xVel + (rotation*length)/2
    local C = yVel - (rotation*width)/2
    local D = yVel + (rotation*width)/2

    local s1, a1 = calculateWheel(B, C) -- get angle, speed
    local s2, a2 = calculateWheel(B, D)
    local s3, a3 = calculateWheel(A, D)
    local s4, a4 = calculateWheel(A, C)
	
    local maxSpeed = math.max(s1, s2, s3, s4) -- compensate if max speed > 1
	if maxSpeed > 1 then
        s1 = s1/maxSpeed
        s2 = s2/maxSpeed
        s3 = s3/maxSpeed
        s4 = s4/maxSpeed
    end

	local brake

	if modeCoast == false then
		if xVel <= 0.1 or yVel <= 0.1 then
			brake = 1
		else 
			brake = 0
		end
	end

	if softbrake then
	
	if hardBrake then
		brake = 1
		a1 = 135
		a2 = 225
		a3 = 45
		a4 = 315
	end

    output.setNumber(1, s1) -- speed encode
    output.setNumber(2, s2)
    output.setNumber(3, s3)
    output.setNumber(4, s4)
	
	output.setNumber(5, brake) -- brake encode
	
    output.setNumber(11, a1) -- angle encode
    output.setNumber(12, a2)
    output.setNumber(13, a3)
    output.setNumber(14, a4)
end

function calculateWheel(X, Y)
	local speed = math.sqrt(X^2 + Y^2)
	local angle = math.atan(X, Y)*180/math.pi
	return speed, angle
end

local gyroOffset = 0
function orient(xDir, yDir, resetGyro, worldYaw)
    if resetGyro then
        gyroOffset = worldYaw
    end
	
    local zeroedYaw = worldYaw - gyroOffset
    if zeroedYaw > 0.5 then zeroedYaw = zeroedYaw - 1 end
    if zeroedYaw < -0.5 then zeroedYaw = zeroedYaw + 1 end
	
    local yaw_rad = zeroedYaw * math.pi
    local xVel = xDir * math.cos(yaw_rad) - yDir * math.sin(yaw_rad)
    local yVel = xDir * math.sin(yaw_rad) + yDir * math.cos(yaw_rad)
    return xVel, yVel
end

--[[ old speed/angle ()
function speed(X, Y)
    return math.sqrt(X^2 + Y^2)
end

function angle(X, Y)
    return math.atan(X,Y)*180/math.pi
end
]]











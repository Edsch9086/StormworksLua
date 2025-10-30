local length = property.getNumber("Chassis Length")
local width = property.getNumber("Chassis Width")
local driveMultiplier = property.getNumber("Drive Multiplier")
local steeringMultiplier = property.getNumber("Steering Multiplier")

function onTick()
    local yDir = input.getNumber(1) * driveMultiplier
    local xDir = input.getNumber(2) * driveMultiplier
    local rotation = input.getNumber(3) * steeringMultiplier * 0.1
    local worldYaw = input.getNumber(4)
	local worldX = input.getNumber(5)
	local worldY = input.getNumber(6)
	-- local roll = input.getNumber(7)
	-- local pitch = input.getnumber(8)
	-- local rotSpeed = input.getNumber(9)
	-- local linSpeed = input.getNumber(10)
	local reqX = input.getNumber(11)
	local reqY = input.getNumber(12)
    local modeCoast = property.getBool("Coast Mode")
    local worldCentric = property.getBool("World/Robot Centric")
    local resetGyro = input.getBool(1)
	local softBrake = input.getBool(2)
	local hardBrake = input.getBool(3)
	-- local moveConfirm = input.getBool(4)
	local aimAtCoord = input.getBool(5)

    if worldCentric == true then -- world/field centric control
		xVel, yVel = orient(xDir, yDir, worldYaw, resetGyro)
    else 
        xVel = xDir
        yVel = yDir
    end

	if aimAtCoord == true then
		rotation = 0
	local deltaX = worldX - reqX
	local deltaY = worldY - reqY
	local targetAngle = atan(deltaX, deltaY)
	local rotNeeded = targetAngle - (worldYaw * 360)
		
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

	local brake = 0

	if modeCoast == false then
		if math.abs(xVel) <= 0.1 and math.abs(yVel) <= 0.1 and math.abs(input.getNumber(3)) <= 0.1 then
			brake = 1
		else 
			brake = 0
		end
	end

	if softBrake == true then
		brake = 1
	elseif hardBrake == true then
		brake = 1
		a1 = 225
		a2 = 135
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
function orient(xDir, yDir, worldYaw, resetGyro)
    if resetGyro then
        gyroOffset = worldYaw
    end
    local zeroedYaw = worldYaw - gyroOffset
    if zeroedYaw > 0.5 then zeroedYaw = zeroedYaw - 1 end
    if zeroedYaw < -0.5 then zeroedYaw = zeroedYaw + 1 end
    local yaw_rad = -zeroedYaw * 2 * math.pi  -- negative here
    local xVel = xDir * math.cos(yaw_rad) - yDir * math.sin(yaw_rad)
    local yVel = xDir * math.sin(yaw_rad) + yDir * math.cos(yaw_rad)
    return xVel, yVel

end



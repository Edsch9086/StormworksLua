local length = property.getNumber("Chassis Length") -- static vars defined in controller properties
local width = property.getNumber("Chassis Width")
local driveMultiplier = property.getNumber("Drive Multiplier")
local steeringMultiplier = property.getNumber("Steering Multiplier")
local modeCoast = property.getBool("Coast Mode")
local worldCentric = property.getBool("World/Robot Centric")

function onTick()
	-- control inputs
    local yDir = input.getNumber(1) * driveMultiplier 
    local xDir = input.getNumber(2) * driveMultiplier
    local rotation = input.getNumber(3) * steeringMultiplier * 0.1

	-- pose (estimation? nope!!! physics sensor magic)
    local worldYaw = input.getNumber(4) -- +-0.5 corresponding to +-180 degrees
	local worldX = input.getNumber(5)
	local worldY = input.getNumber(6)
	-- local worldRoll = input.getNumber(9)  -- all of these are unused for now, im just leaving them here so that they can be quickly used later
	-- local worldPitch = input.getnumber(10)
	-- local rotSpeed = input.getNumber(11)
	-- local linSpeed = input.getNumber(12)
	
	-- auton stuff
	local reqX = input.getNumber(7)
	local reqY = input.getNumber(8)
	local moveConfirm = input.getBool(4)
	local aimAtCoord = input.getBool(5)
	
	-- misc inputs
    local resetGyro = input.getBool(1) 
	local softBrake = input.getBool(2)
	local hardBrake = input.getBool(3)

	-- world/field centric control
    if worldCentric == true then 
		xVel, yVel = orient(xDir, yDir, worldYaw, resetGyro)
    else 
        xVel = xDir
        yVel = yDir
    end
	
	-- rotate to aim at point
	local brake = 0
	if aimAtCoord == true then 
   	 rotation, brake = calcAim(worldX, worldY, worldYaw, reqX, reqY)
	end
	
	-- translate to point
	if moveConfirm == true then
	    xVel, yVel, brake = TRANS(worldX, worldY, worldYaw, reqX, reqY, worldCentric)
	end

	-- define wheel vector locations
    local A = xVel - (rotation*length)/2 
    local B = xVel + (rotation*length)/2
    local C = yVel - (rotation*width)/2
    local D = yVel + (rotation*width)/2

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

	-- brake when input released if coast mode inactive
	if modeCoast == false then 
		if math.abs(xVel) <= 0.1 and math.abs(yVel) <= 0.1 and math.abs(input.getNumber(3)) <= 0.1 then
			brake = 1
		else 
			brake = 0
		end
	end

	-- brakes (including wheel X lockup)
	if softBrake == true then -- wheel brake only
		brake = 1
	elseif hardBrake == true then -- wheel brake, plus all wheels inward (not to chassis centre)
		brake = 1
		a1 = 225 -- front right
		a2 = 135 -- front left
		a3 = 45 -- back left
		a4 = 315 -- back right
	end

	-- speed encode
    output.setNumber(1, s1) 
    output.setNumber(2, s2)
    output.setNumber(3, s3)
    output.setNumber(4, s4)

	-- brake encode
	output.setNumber(5, brake) 

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

-- field/robot orient, incl. gyro reset function
local gyroOffset = 0
function orient(xDir, yDir, worldYaw, resetGyro)
    if resetGyro then
        gyroOffset = worldYaw
    end
    local zeroedYaw = worldYaw - gyroOffset -- +-0.5 corresponding to +-180
    if zeroedYaw > 0.5 then zeroedYaw = zeroedYaw - 1 end
    if zeroedYaw < -0.5 then zeroedYaw = zeroedYaw + 1 end
    local yaw_rad = -zeroedYaw * 2 * math.pi  -- radians
    local xVel = xDir * math.cos(yaw_rad) - yDir * math.sin(yaw_rad)
    local yVel = xDir * math.sin(yaw_rad) + yDir * math.cos(yaw_rad)
    return xVel, yVel

end

 -- aim front of chassis towards target x, y (reqX, reqY)
function calcAim(worldX, worldY, worldYaw, reqX, reqY)
    local currentYaw = worldYaw * math.pi -- radians
    local deltaX = reqX - worldX
    local deltaY = reqY - worldY
    local targetAngle = math.atan(deltaY, deltaX)
    local angleError = targetAngle - currentYaw
	local brake = 0
    
    angleError = (angleError + math.pi) % (2 * math.pi) - math.pi
    local kP = 2.0 -- tune if oscillations
    local rotation = angleError * kP
	
    if rotation > 1 then rotation = 1 end
    if rotation < -1 then rotation = -1 end
    
    if math.abs(angleError) < 0.03 then
        rotation = 0
		brake = 1
    end
    return rotation, brake
end

-- translation :3 (the roy consumes)
function TRANS(worldX, worldY, worldYaw, reqX, reqY, worldCentric)
    local deltaX = reqX - worldX -- needed translation amount
    local deltaY = reqY - worldY
	
    local distance = math.sqrt(deltaX^2 + deltaY^2)
    local maxSpeed = 1.0

    if distance > 0 then
        deltaX = deltaX / distance * math.min(distance, maxSpeed)
        deltaY = deltaY / distance * math.min(distance, maxSpeed)
    end

    local xVel, yVel
	-- correct movement if worldcentric
    if worldCentric then 
        local yaw = worldYaw * math.pi
        local cosYaw = math.cos(-yaw)
        local sinYaw = math.sin(-yaw)
        xVel = deltaX * cosYaw - deltaY * sinYaw
        yVel = deltaX * sinYaw + deltaY * cosYaw
    else
        xVel = deltaX
        yVel = deltaY
    end

	-- compensate if vector magnitude > 1
	local mag = math.sqrt(xVel^2 + yVel^2) 
	if mag > 1 then
 	   xVel = xVel / mag
 	   yVel = yVel / mag
	end

	-- stop within x meters of target
    if distance < 0.2 then 
        xVel = 0
        yVel = 0
		brake = 1
    end
	
    return xVel, yVel, brake
end
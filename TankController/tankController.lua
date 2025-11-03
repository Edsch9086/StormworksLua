local engineRPS = property.getNumber("Engine RPS")
local angVelLimiter = property.getNumber("Rotation Speed Limit")
local maxSpeed = property.getNumber("Max Speed")

function onTick()
    -- inputs
    local throttle = input.getNumber(1)
    local steer = input.getNumber(2)    

    -- sensor inputs
    local angVel = input.getNumber(3)
    local linVel = input.getNumber(4)


    -- outputs 
    local brake = false
    local rReverse = false
    local lReverse = false
    local rClutch = 0
    local lClutch = 0
    local engine = 0


end
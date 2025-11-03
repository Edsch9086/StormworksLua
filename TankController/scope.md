## the goal here is to create a simple lua-based tank drive controller that does/is the following:

### simple to set up / use
- no more than 9 i/o
    1. comp from seat
    2. comp from physics sensor
    3/4. left and right clutch
    5/6. left and right reverse gear
    7. engine throttle out
    8. engine rps in
    9. brake out

- easy config in controller properties
    - max speed (km/h)
    - max rotation velocity (rads/second)
    - engine type (jet/prebuilt diesel) -- test pb diesel with modular
    - max engine rps


### allows for efficient 2 dof movement with minimal thought
- movement properties
    - neutral steering
    - fast response time
    - stable at high speeds 

### be viable for use in stormworks
- lightweight on resources

- polished enough to upload to steam workshop

the goal here is to create a simple lua-based tank drive controller that does/is the following:

- simple to set up / use
> no more than 9 i/o
    - comp from seat
    - comp from physics sensor
    - left and right clutch
    - left and right reverse gear
    - engine throttle out
    - engine rps in
    - brake out

> easy config in controller properties
    - max speed (km/h)
    - max rotation velocity (rads/second)
    - engine type (jet/prebuilt diesel) -- test pb diesel with modular
    - max engine rps


- allows for efficient 2 dof movement with minimal thought
> movement properties
    - neutral steering
    - fast response time
    - stable at high speeds 

- be lightweight on resources

- be polished enough to upload to steam workshop

## the goal here is to create a simple lua-based tank drive controller that is:

### - simple to set up / use

- no more than 9 i/o
    1. comp from seat
    2. comp from physics sensor
    3. left clutch
    4. right clutch
    5. left reverse gear
    6. right reverse gear
    7. engine throttle out
    8. engine rps in
    9. brake out

- easy config in controller properties
  - max speed (km/h)
  - max rotation velocity (rads/second)
  - max engine rps

### - efficient for 2-dof movement

- movement properties
  - neutral steering
  - fast response time
  - stable at high speeds
    - you can just build a competent vehicle for that

- handles naturally, as one would expect a tank drive to handle

### - be viable for use in stormworks

- lightweight on resources

- polished enough to upload to steam workshop

- centralised logic block for easy repairability

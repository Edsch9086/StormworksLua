## the goal here was to create a lua-based swerve drive system that is:

### - easy to configure
- 1 mcu, > 6 i/o connections
    1. comp from seat
    2. comp from physics sensor
    3. comp from auton module
    4. comp to reader units/auton module
- 4 reader modules, > 6 i/o connections
    1. comp from mcu
    2. pivot speed out
    3. current pivot speed in
    4. motor speed out
    5. wheel brake

### - efficient for 3-dof movement
- turn wheels to target via the shortest path possible

- reverse wheel speed if needed 

### - viable for use in stormworks
- lightweight on resources

- polished enough to upload to steam workshop
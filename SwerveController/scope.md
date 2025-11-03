the goal here was to create a lua-based swerve drive system that can:

## H2 - be easy to configure
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

- allow for efficient 3-dof movement
> turn wheels to target via the shortest path possible
> reverse wheel speed if needed 
    - be able to toggle this if needed (i.e. twerve drive/asymmetrical wheels)

- be lightweight on resources

- be polished enough to upld to steam workshop
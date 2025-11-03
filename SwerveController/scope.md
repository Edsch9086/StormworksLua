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

- optimized
    - turn wheels to target via the shortest path possible
    - reverse wheel rotation if needed 
         - note: can change this in config for asymetrical wheel designs (see: [twerve](https://www.chiefdelphi.com/t/presenting-mk4t-the-latest-innovation-in-frc-drivetrains/477941))

- simple to operate
    - wasd and left/right for translation and rotation
    - option for field or robot-centric drive


### - viable for use in stormworks
- lightweight on resources

- polished enough to upload to steam workshop
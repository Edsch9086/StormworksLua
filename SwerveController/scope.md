the goal here was to create a lua-based swerve drive system that can:

- be easy to configure
> 1 mcu, > 6 i/o connections
    - comp from seat
    - comp from physics sensor
    - comp from auton module
    - comp to reader units/auton module
> 4 reader modules, > 6 i/o connections
    - pivot speed out
    - current pivot speed in
    - comp from mcu
    - wheel brake

- allow for efficient 3-dof movement
> turn wheels to target via the shortest path possible
> reverse wheel speed if needed 
    - be able to toggle this if needed (i.e. twerve drive/asymmetrical wheels)

- be lightweight on resources

- be polished enough to uplaod to steam workshop
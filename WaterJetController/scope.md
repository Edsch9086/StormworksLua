## the goal here is to create a lua-based waterjet boat controller that is:

### - simple to set up / use

- no more than 12 i/o
  - seat comp in
  - phys comp in
  - autopilot commp in
  - throttle out (0-1)
  - left deflector a
  - left deflector b
  - left vertical trim
  - right deflector a
  - right deflector b
  - right vertical trim

- easy config in controller properties
  - pitch up when moving
    - moving pitch (0-45 above horizon)
  - lean into turns yes/no
    - leaning amount (0-30 into turn)
  - PID vals for stabilization

### - efficient for 2-dof movement

- movement properties
  - reactive
  - easy to control
  - active stabilization at speed (roll and pitch)

### - be viable for use in stormworks

- lightweight on resources

- polished enough to upload to steam workshop

- stable in extreme conditions

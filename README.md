# field-simulation

This project is the simulation of electron particles in an electric field generated by positive charges. By default, two positive charges are placed, but this can be changed in launch settings. This project was created in Processing, and can be run by downloading Processing at processing.org

# Settings

## Vaccum Mode
This will cause any electron that is caught inside a charge to be removed from the simulation. By default, this is not enabled.

## Regeneration Mode
This will cause any electrons removed by Vaccum mode to regenerate on the perimeter. By default, this is not enabled.

## Velocity/Acceleration lines
This will cause a blue line to point in the direction of an electron's current acceleration, and a red line to point in the direction of its current velocity. By default, these lines are hidden. It is recommended to have a row count of less than 40 to have this enabled.

## Charges Per Row
This indicates how many electrons are in a row/column upon startup. By default, this number is 20.

## Place Custom Charges
This allows the user to place where charges are and how many are in a simulation. By default, there are two charges at (1/2 width +- 1/6 width, 1/2 height).

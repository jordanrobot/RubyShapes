## RubyShapes

Copyright 2009 Matthew D. Jordan
www.scenic-shop.com
shared under the GNU GPLv3

### License

    This file is part of RubyShapes.
    
    RubyShapes is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    RubyShapes is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with RubyShapes.  If not, see <http://www.gnu.org/licenses/>.



### What this library does:

Defines ruby objects which represent real world cross-section shapes.  Returns geometric properties useful to structural designers.  Right now the weight values are calculated assuming the material is steel.

Each type of shape is a different object. i.e., square, rectangle, circle, hollow circle...

Each objects' input parameters are:

- the dimensions that describe the shape
- the values that are used to calculate the geometric properties for that cross-sectional shape/object

This library is divided into several modules for maximum mixin lovin'

- DiagUtils Module - Diagnostic messages. -- I could probably use a fully fledged testing and debugging library, but I'm not familiar with any yet.
- OutputUtils Module - Defines the methods that output the Object variables
- ShapeUtils Module - Defines property calculations that are common to multiple 

### The Shape Classes

- Round_tube class
- Square_tube class 
- Rec_tube
- Bar class
- Plate class
- Rod class

### Variables common to all shape classes.

- x = x dimension (in.) (equiv. to outer diameter for round shapes)
- y = y dimension (in.) (equiv. to outer diameter for round shapes)
- a = square area (in^2)
- ix = second moment of area for xx (in^4)
- iy = second moment of area for yy (in^4)
- sx = section modulus for xx (in^3)
- sy = section modulus for yy (in^3)
- rx = radius of gyration for xx (in)
- ry = radius of gyration for yy (in)
- w = weight of shape per linear foot (lbs/ft) - right now assumes all shapes are steel

### Shape Class Objects

- Round_tube(outer diameter, wall thickness)
- Square_tube(x dimension, thickness)
- Rec_tube(x width, y height, wall thickness)
- Bar(x dimension)
- Plate(x dimension, y dimension)
- Rod(outside diameter)



### ShapeUtilites Module Methods

These methods are for use by the various classes during object initialization.
They are not very useful to the end user.

- Float::to_d
- .corner_radius
 - Calculates corner radius for calculations during Shape Class initializations
- .gauge_converter
  - Converts between Steel gauges and Decimal gauges for use during Shape Class inits. 
- .calc_weight
  - Calculates weight values - for use during Shape Class inits.
- .build_hash
  - builds a hash of the Shape Object's properties.  Result is stored in the Object.
	


### Output Module Methods

These methods are used to get output from the objects.

- .props
  - returns a list of Object properties as floats (rounded to 4 places)
- .bigprops
  - returns a list of Object properties as BigDecimals
- .hash
  - returns the hash of Object properties as floats (rounded to 4 places)
- .bighash
  - returns the hash of Object properties as BigDecimals
- .columns_header
  - prints a pretty header for the columns method
- .columns
  - returns the Object properties in a column format, as floats (rounded to 4 places)

### Diagnostics Module Methods

These methods mostly only run when DIAGNOSTICS = on

- .diag_section("message")
  - Outputs a diagnostic section(header) line to the screen. ```---  message  ---```
- .diag_line(arg)
  - Outputs a diagnostic line to the screen
- .diag_class
  - Outputs which class is initializing. ```====  Now initiating a Rec_tube class  ====```
- .test_output
  - Prints Output Module Methods all at once for the receiver object.  Good for batch testing the Output Module methods
- .var_classes
  - prints the classes for a predefined list of instance variables in the receiver object. DIAGNOSTIC flag independent.
- .var_values
  - prints the values for a predefined list of instance variable in the receiver object. DIAGNOSTIC flag independent.
- .diag_all
  - not implemented yet.  Thought is that it will be a comprehensive diagnostic inspection for any object.  DIAGNOSTIC flag independent.

#!/usr/bin/env ruby
#
#RubyShapes v 0.2.9
#
#Copyright 2009 Matthew D. Jordan
#www.scenic-shop.com
#shared under the GNU GPLv3
#
#==License
#
#    This file is part of RubyShapes.
#    
#    RubyShapes is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#    
#    RubyShapes is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with RubyShapes.  If not, see <http://www.gnu.org/licenses/>.
#
#==What this library does:
#
#* Defines ruby objects which represent real world cross-section shapes.  Returns geopmetric properties useful to structural designers.  Right now the weight values are calculated assuming the material is steel.
#* Each type of shape is a different object. i.e., square, rectangle, circle, hollow circle...
#* Each objects' input parameters are:
#  a. the dimensions that decribe the shape
#  b. the values that are used to calculate the geometric properties for that cross-sectional shape/object
#* This library is divided into several modules for maximum mixin lovin'
#  a. DiagUtils Module - Diagnostic messages. -- I could probably use a fully fledged testing and debugging library, but I'm not familiar with any yet.
#  b. OutputUtils Module - Defines the methods that output the Object variables
#  c. ShapeUtils Module - Defines property calculations that are common to multiple Shape Classes
#* The Shape Classes - the meat!
#  a. Round_tube class
#  b. Square_tube class 
#  c. Rec_tube
#  d. Bar class
#  e. Plate class
#  f. Rod class

require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath


#Constants
Pi = BigDecimal.PI(20)
$gauge_factors = { 30=>0.012, 29=>0.013, 28=>0.014, 27=>0.016, 26=>0.018, 25=>0.020, 24=>0.022, 23=>0.025, 22=>0.028, 21=>0.032, 20=>0.035, 18=>0.049, 16=>0.065, 14=>0.083, 13=>0.095, 12=>0.109, 11=>0.120, 10=>0.134, 9=>0.148, 8=>0.165, 7=>0.180, 6=>0.203, 5=>0.220, 4=>0.238, 3=>0.259, 2=>0.284, 1=>0.300, 0=>0.34, 00=>0.38, 000=>0.425, 0000=>0.454 }
$radius_factors = { 0.035=>"0.04675", 0.049=>"0.0625", 18=>"0.0625", 16=>"0.0859375" }

#Diagnostics Flag
DIAGNOSTICS = "off"

#Load various modules
require "DiagUtils.rb"
require "OutputUtils.rb"
require "ShapeUtils.rb"


#########################
###   Shape Classes   ###
#########################

#=Class Round_tube(od, thickness)
#  parameters
#    @x = outside diameter
#    @t = thickness of tubing
class Round_tube
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w
  include ShapeUtils; include DiagUtils; include OutputUtils

  def initialize(x, t)  
    diag_class

    @x = @y = x.to_s.to_d
    @t = t.to_i

    gauge_converter
     
    #calculate Round tube Area
    @a = (Pi*@t) * (@x-@t)

    #calculate Second Moment of Area (I)
    @ix = @iy = Pi * (@x**4 - ((@x - (2*@t))**4 ))/64

    #Calculate Round Tube Section Modulus
    @sx = @sy = (2*@ix)/@x

    #Calculate Round Tube Radius of Gyration 
    @rx = @ry = sqrt(@ix/@a, 9)

    calc_weight
    build_hash
    diag_all

  end #def init
end #class Round_tube


#=Class Square_tube(od, thickness, radius)
#  parameters
#    @x  = outside diameter
#    @t  = thickness of tubing
#    @ra = radius at corner
class Square_tube
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w, :ra
  include ShapeUtils; include DiagUtils; include OutputUtils
    
  def initialize(x, t)
    diag_class

    @x = @y = x.to_s.to_d
    @t = t.to_i

    corner_radius
    gauge_converter

    #calculate Square Area
    @a = (@t * ((4 * @x) - (8 * @ra) + ( Pi * (2*@ra - @t) ) ))

    #calculate Second Moment of Area (I)
    @ix = @iy = ((@t**3 * (@x - 2 * @ra))/6 + 2 * @t * (@x - 2 * @ra) * ((@x - @t)/2)**2 + (@t * (@x - 2 * @ra)**3)/6 + (Pi/4 - 8/(4.5 * Pi)) * (@ra**4 - (@ra - @t)**4) - ( 8 * @t * @ra**2 * (@ra - @t)**2)/(4.5 * Pi * (2 * @ra - @t)) + Pi * @t * (2 * @ra - @t) * (@x/2 - @ra + (4 * (ra**3 - (@ra - @t)**3))/(3 * Pi * (@ra**2 - (@ra - @t)**2)))**2).to_d

    #Section Modulus
    @sx = @sy = ((2 * @ix)/@x)

    #Radius of Gyration
    @rx = @ry = (@ix/@a).sqrt(2)

    calc_weight
    build_hash
    diag_all

  end #def init
end #Square_tube


#=Class Rec_tubing(d_x, d_y, ra, thick)
#
#  parameters
#  d = box tube width, height
#  ra = radius of corner
#  t = wall thickness
class Rec_tube
  attr_accessor :x, :y, :t, :ra, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w  
  include ShapeUtils; include DiagUtils; include OutputUtils
  
  def initialize(x, y, t)
    diag_class   

    @x = x.to_s.to_d
    @y = y.to_s.to_d
    @t = t.to_i

    corner_radius
    gauge_converter
    
    #----------calculate area----------
    @a = (@t*((BigDecimal.new("2")*(@x+@y))-( BigDecimal.new("8")*@ra)+(Pi*(( BigDecimal.new("2")*@ra)-@t))))

    #method - calculate Second Moment of Area


    @iy = ((@t**3 * (@y - 2 * @ra)) / 6 + 2 * @t * (@y - 2 * @ra) * ((@x - @t) / 2)**2 + (@t * (@x - 2 * @ra)**3 ) / 6 + (Pi / 4 - 8/(4.5 * Pi)) * (@ra**4 - (@ra - @t)**4) - (8 * @t * @ra**2 * (@ra - @t)**2) / (4.5 * Pi * (2 * @ra - @t)) + Pi * @t * (2 * @ra - @t) * (@x/2 - @ra + (4 * (@ra ** 3 - (@ra - @t) ** 3)) / (3 * Pi * (@ra ** 2 - (@ra - @t)**2)))**2).to_d
    @ix = ((@t**3 * (@x - 2 * @ra)) / 6 + 2 * @t * (@x - 2 * @ra) * ((@y - @t) / 2)**2 + (@t * (@y - 2 * @ra)**3 ) / 6 + (Pi / 4 - 8/(4.5 * Pi)) * (@ra**4 - (@ra - @t)**4) - (8 * @t * @ra**2 * (@ra - @t)**2) / (4.5 * Pi * (2 * @ra - @t)) + Pi * @t * (2 * @ra - @t) * (@y/2 - @ra + (4 * (@ra ** 3 - (@ra - @t) ** 3)) / (3 * Pi * (@ra ** 2 - (@ra - @t)**2)))**2).to_d

    #calculate Section Modulus method
    @sx = ((2*ix)/y).to_d
    @sy = (2*iy/x).to_d


    @rx = sqrt(@ix/@a, 9)
    @ry = sqrt(@iy/@a, 9)

    calc_weight
    build_hash
    diag_all

  end #def init
end #class Rec_tube

#=Class Bar(x)
#As in square bar.
#FIXME: Check Math, guestimated most of it
#
#  parameters:
#  x = bar dimension - x & y    
class Bar
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w
  include ShapeUtils; include DiagUtils; include OutputUtils
  
  def initialize(x)
    diag_class    

    @x = @y = x.to_s.to_d

    #calculate area
    @a = @x * @x
    
    #calculate Second Moment of Inertia
    @ix = @iy = (@x**4) / 12

    #calculate Section Modulus
    @sx = @sy = (@x**3) / 6
    
    #calculate Radius of Gyration
    @rx = sqrt(@ix / @a, 2)
    @ry = sqrt(@iy / @a, 2)
    
    calc_weight
    build_hash
    diag_all

  end #def
end #class Bar


#=Class Plate(x, y)
#
#FIXME: Check Math, guestimated most of it
#
#  parameters:
#  x = dimension
#  y = dimension
class Plate
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w
  include ShapeUtils; include DiagUtils; include OutputUtils
  
  def initialize(x, y)  
    diag_class

    @x = x.to_s.to_d
    @y = y.to_s.to_d

    #calculate area
    @a = @x * @y
    
    #calculate Second Moment of Inertia
    @ix = (@x * @y**3) / 12
    @iy = (@y * @x**3) / 12
    
    #calculate Section Modulus - BROKEN
    @sx = (@x**3) / 6
    @sy = (@y**3) / 6

    #calculate Radius of Gyration - BROKEN
    @rx = sqrt(@ix / @a, 2)
    @ry = sqrt(@iy / @a, 2)

    calc_weight
    build_hash
    diag_all

  end #def init
end #class Plate


#=Class Rod(x)
#  parameters:
#  x = diameter
class Rod
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w
  include ShapeUtils; include DiagUtils; include OutputUtils
  
  def initialize(x)
    diag_class
    
    @x = x.to_d
    @y = x.to_d
    #calculate area
    @a = Pi * (@x / 2)**2 
    
    #calculate Second Moment of Inertia
    @ix = @iy = (Pi/64)*(@x**4)

    #calculate Section Modulus
    @sx = @sy = Pi * @x ** 3 /32

    #calculate Radius of Gyration
    @rx = @ry = sqrt(@ix / @a, 2)
    
    calc_weight 
    build_hash
    diag_all

  end #def init
end #class Rod


########################
###   Testing Area   ###
########################
include ShapeUtils; include DiagUtils; include OutputUtils

#  Square_tube.new(1, 18).props
#  Square_tube.new(1, 18).props
#  Square_tube.new(1, 18).bigprops("t")
#  Square_tube.new(1, 18).bigprops
#  Square_tube.new(1, 18).hash
#  Square_tube.new(1, 18).bighash
#  Square_tube.new(1, 18).columns
#
#  Square_tube.new(1, 18).props
#  Round_tube.new(4, 18).props
#  Rec_tube.new(1.5, 1.5, 20).columns
#  Rec_tube.new(1.5, 1.5, 18).columns
#
#
#  Bar.new(5.0).props
#  Plate.new(4.0, 5).props
  Rod.new(2.0).props
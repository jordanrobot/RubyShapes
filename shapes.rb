#!/usr/bin/env ruby


#=Shapes Library v 0.2.9
#  Matthew D. Jordan
#  www.scenic-shop.com
#  shared under the GNU GPLv3
#
#
#=What this library does:
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


############################
###   DiagUtils Module   ###
############################

#This module handles Diagnostic messages.
module DiagUtils

#Outputs a diagnostic section(header) line to the screen. Only prints when Diagnostics = on
  def diag_section(arg)
    if DIAGNOSTICS == "on"
      puts ""
      puts "----  #{arg}  ----"
    end #if
  end #def diag_section


#Outputs a diagnostic line to the screen. - Fill this line with whatever you like. Only prints when Diagnostics = on
  def diag_line(arg)
    if DIAGNOSTICS == "on"
      puts arg
    end #if
  end #def diag_line


#Outputs a diagnostic label. - Tells you which class is being created. Only prints when Diagnostics = on
  def diag_class
    if DIAGNOSTICS == "on"
      puts ""
      puts "====  Now initiating a #{self.class} class  ===="
    end #if
  end #def diag_class


#Prints all OutputUtils Module methods at once for any given shape object. Only prints when Diagnostics = on
  def test_output
    if DIAGNOSTICS == "on"
      diag_section("testing shape object's output")
      puts 'Props (Floats):'
      self.props
  
      puts
  
      diag_line('Individual values (Floats):')
      self.props("x")
  
      puts
  
      puts 'Bigprops (BigDecimals):'
      self.bigprops
  
      puts
  
      puts 'Return individual values (BigDecimals):'
      self.bigprops("a")
  
      puts
  
      puts 'Return all values in the object (Hash):'
      p self.hash
  
      puts
  
      puts 'Return all values in the object (BigDecimal Hash):'
      p self.bighash
      
      
    end #if
  end #def test_shape

#Diagnostics - lists all instance variables' classes. Does not require Diagnostics = on
  def var_classes
      p "---Diagnostic: output variable classes---"
      p "x:    #{@x.class}"
      p "y:    #{@y.class}"
      p "t:    #{@t.class}"
      p "ra:   #{@ra.class}"
      p "a:    #{@a.class}"
      p "i:    #{@i.class}"
      p "i_x:  #{@i_x.class}"
      p "i_y:  #{@i_y.class}"
      p "s:    #{@s.class}"
      p "s_x:  #{@s_x.class}"
      p "s_y:  #{@s_y.class}"
      p "r:    #{@r.class}"
      p "r_x:  #{@r_x.class}"
      p "r_y:  #{@r_y.class}"
      p "w:    #{@w.class}"
      p "Pi:   #{Pi.class}"
  end #def var_classes

#Diagnostics - lists all instance variables' values. Does not require Diagnostics = on
  def var_values
      puts "---  Diagnostic: Variable Values  ---"
      puts "   x:    #{@x.to_f}  #{@x.class}"
      puts "   y:    #{@y.to_f}  #{@y.class}"
      puts "   t:    #{@t.to_f}  #{@t.class}"
      puts "   ed:   #{@equiv_diameter.to_f}  #{@equiv_diameter.class}"
      puts "   ra:   #{@ra.to_f}  #{@ra.class}"
      puts "   a:    #{@a.to_f}  #{@a.class}"
      puts "   ix:  #{@ix.to_f}  #{@ix.class}"
      puts "   iy:  #{@iy.to_f}  #{@iy.class}"
      puts "   sx:  #{@sx.to_f}  #{@sx.class}"
      puts "   sy:  #{@sy.to_f}  #{@sy.class}"
      puts "   rx:  #{@rx.to_f}  #{@rx.class}"
      puts "   ry:  #{@ry.to_f}  #{@ry.class}"
      puts "   w:    #{@w.to_f}  #{@w.class}"
      puts "   Pi:   #{Pi.to_f}  #{@Pi.class}"
  end #def var_values

  def diag_all
#    var_values
#    self.inspect
  end #diag_all
  
end #module DiagUtils


##############################
###   OutputUtils Module   ###
##############################

#this module handles i/o of the calculated shape values
module OutputUtils

  #prints attributes of shape, rounded to 4 places (floats).  If no specific variable is specified, props will return all attributes.  If a variable is specified [ object.props("variable") ], props returns only that specific attribute.
  def props(arg="list")

    diag_section(".props: printing shape properties")
    if arg == "list"
      @hash.each {|key, value| puts "#{key}:  #{value.to_f}\n"}
    else
      puts @hash["#{arg}"].to_f
    end #if
  end #def props


#prints attributes of shape (bigdecimals).   If no specific variable is specified, bigprops will return all attributes.  If a variable is specified [ object.bigprops("variable") ], bigprops returns only that specific attribute.
  def bigprops(arg='i')
    diag_section(".bigprops: printing shape properties")

    if arg == 'i'
      @bighash.each {|key, value| puts "#{key}:  #{value}\n"}
      else  
      puts @bighash["#{arg}"]
    end #if
  end #def bigprops
  

#returns a hash of the attributes, rounded to 4 places (floats).
  def hash
    diag_section(".hash: returning @hash")
    @hash
  end #def hash


#returns a hash of the attributes (bigdecimals).  
  def bighash
    diag_section(".bighash: printing shape properties hash")

    @bighash
  end #def bighash


#outputs a header for the OutputUtiles::columns method 
  def columns_header
    puts ""
    puts "x     y     t      a       w       ix      iy      sx       sy       rx      ry"
  end #def columns_header


#outputs properties in a column format, rounded to 4 places (floats)
  def columns
    diag_section(".columns: printing shape properties in column format")
    puts "#{@x.round(4).to_f}  #{@y.round(4).to_f}  #{@t.round(4).to_f}  #{@a.round(4).to_f}  #{@w.round(4).to_f}  #{@ix.round(4).to_f}  #{@iy.round(4).to_f}  #{@sx.round(4).to_f}  #{@sy.round(4).to_f}  #{@rx.round(4).to_f} #{@ry.round(4).to_f}"
  end #def columns

end #OutputUtils


#############################
###   ShapeUtils Module   ###
#############################

#this module handles i/o of the calculated shape values
module ShapeUtils
  

#adds a to_d method to the Float class
  class Float
    def to_d
      BigDecimal(self.to_s)
    end #def to_d
  end #class Float

#Will determine rectangular tubing corner radius based on perimeter & thickness - currently broken
  def corner_radius
    diag_section("Calculating Corner Radius")
    
    if $radius_factors.key?(@t)
      @ra = BigDecimal.new("#{$radius_factors[@t]}")
      diag_line("radius was calculated")
    else
      @ra = BigDecimal.new("0.03125")
      diag_line("radius could not be calculated: using default value")
    end #if

#    equiv_diam = (((@x * 2) + (@y * 2)) / Pi)
#    diag_line("equivalent diameter:   #{equiv_diam.round(4)}, #{equiv_diam.class}")
    diag_line("@radius:                #{@ra.to_f.to_s}, #{@ra.class}")


  end #def corner_radius

#This method examines the @t (thickness) variable to see if it is a decimal number or a gauge number.
#@t > 1 are converted to the decimal number equivalents via a case statement.
#@t < 1 are kept as is
  def gauge_converter
    diag_section("Gauge Conversion")    
    
    if $gauge_factors.key?(@t)
      @t = BigDecimal.new("#{$gauge_factors[@t]}")
      diag_line("gauge was converted from AWG to decimal")
    else
      @t = BigDecimal.new(@t)
      diag_line("decimal gauge provided")
    end #if

    diag_line("@thickness:             #{@t.to_f.to_s}, #{@t.class}")
    diag_line("")
  end #def gauge_converter


#This method calculates the weight of the shape - assumes shape is med. carbon steel
  def calc_weight
         @w = 3.3996.to_d * @a
  end #weight

  def build_hash
    @hash = {"x" => @x.round(4).to_f, "y" => @y.round(4).to_f, "a" => @a.round(4).to_f, "ix" => @ix.round(4).to_f, "iy" => @iy.round(4).to_f, "sx" => @sx.round(4).to_f, "sy" => @sy.round(4).to_f, "rx" => @rx.round(4).to_f, "ry" => @ry.round(4).to_f, "w" => @w.round(4).to_f }
    @bighash = {"x" => @x, "y" => @y, "a" => @a, "ix" => @ix, "iy" => @iy, "sx" => @sx, "sy" => @sy, "rx" => @rx, "ry" => @ry, "w" => @w }
  end #build_hash
    
end #ShapeUtils


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
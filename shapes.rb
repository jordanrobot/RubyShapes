#!/usr/bin/env ruby
=begin
###################################
###   Shapes Library v 0.2.8    ###
###      Matthew D. Jordan      ###
###     www.scenic-shop.com     ###
### shared under the GNU GPLv3  ###
###################################
=end

#require 'profile'
require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath

#Constants
Pi = BigDecimal.PI(20)
$gauge_factors = { 30=>0.012, 29=>0.013, 28=>0.014, 27=>0.016, 26=>0.018, 25=>0.020, 24=>0.022, 23=>0.025, 22=>0.028, 21=>0.032, 20=>0.035, 18=>0.049, 16=>0.065, 14=>0.083, 13=>0.095, 12=>0.109, 11=>0.120, 10=>0.134, 9=>0.148, 8=>0.165, 7=>0.180, 6=>0.203, 5=>0.220, 4=>0.238, 3=>0.259, 2=>0.284, 1=>0.300, 0=>0.34, 00=>0.38, 000=>0.425, 0000=>0.454 }
$radius_factors = { 0.035=>"0.04675", 0.049=>"0.0625", 18=>"0.0625", 16=>"0.0859375" }

DIAGNOSTICS = "off"


############################
###   DiagUtils Module   ###
############################

=begin
  ==DiagUtils
  this module handles Diagnostic messages
  note: all Shape classes mixin this module
=end
module DiagUtils

=begin
  ==DiagUtils:diag_section
  Outputs a formated label to the screen.  Used for testing and debugging
=end
  def diag_section(arg)
    if DIAGNOSTICS == "on"
      puts ""
      puts "----  #{arg}  ----"
    end #if
  end #def diag_section

=begin
  ==DiagUtils:diag_line
  Outputs a formated label to the screen.  Used for testing and debugging
=end
  def diag_line(arg)
    if DIAGNOSTICS == "on"
      puts arg
    end #if
  end #def diag_line

=begin
  ==DiagUtils:diag_class
  Outputs a diagnostic class label.  Used for testing and debugging
=end
  def diag_class
    if DIAGNOSTICS == "on"
      puts ""
      puts "====  Now initiating a #{self.class} class  ===="
    end #if
  end #def diag_class

=begin
  ==ShapeUtils::test_shape
  #test individual shape objects and return results
=end
  def test_shape
    if DIAGNOSTICS == "on"
      diag_section("testing shape object")
      puts 'Props (Floats):'
      self.props
  
      puts
  
      puts 'Individual values (Floats):'
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

=begin
  ==ShapeUtils::var_classes
  puts the classes of instance variables
=end
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

=begin
  ==ShapeUtils::var_values
  puts the instance variables' values
=end
  def var_values
      puts "---  Diagnostic: Variable Values  ---"
      puts "   x:    #{@x.to_f}  #{@x.class}"
      puts "   y:    #{@y.to_f}  #{@y.class}"
      puts "   t:    #{@t.to_f}  #{@t.class}"
      puts "   ed:   #{@equiv_diameter.to_f}  #{@equiv_diameter.class}"
      puts "   ra:   #{@ra.to_f}  #{@ra.class}"
      puts "   a:    #{@a.to_f}  #{@a.class}"
      puts "   ix:  #{@i_x.to_f}  #{@i_x.class}"
      puts "   iy:  #{@i_y.to_f}  #{@i_y.class}"
      puts "   sx:  #{@s_x.to_f}  #{@s_x.class}"
      puts "   sy:  #{@s_y.to_f}  #{@s_y.class}"
      puts "   rx:  #{@r_x.to_f}  #{@r_x.class}"
      puts "   ry:  #{@r_y.to_f}  #{@r_y.class}"
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

=begin

  ==OutputUtils
  this module handles i/o of the calculated shape values
  note: all Shape classes mixin this module

=end
module OutputUtils

=begin
  ==OutputUtils::props
    #prints rounded (4 places) attributes as floats.  Normally will print all attributes or those specified with obj.props("attribute")
=end
  def props(arg="list")

    diag_section(".props: printing shape properties")
    if arg == "list"
      @hash.each {|key, value| puts "#{key}:  #{value.to_f}\n"}
    else
      puts @hash["#{arg}"].to_f
    end #if
  end #def props

=begin
  ==OutputUtils::bigprops
  #prints the complete attributes as bigdecimals.   Normally will print all attributes or those specified with obj.bigprops("attribute")
=end
  def bigprops(arg='i')
    diag_section(".bigprops: printing shape properties")

    if arg == 'i'
      @bighash.each {|key, value| puts "#{key}:  #{value}\n"}
      else  
      puts @bighash["#{arg}"]
    end #if
  end #def bigprops
  
=begin
  ==OutputUtils::hash
  #returns a hash of the attributes (rounded to 4 places, as floats.)
=end
  def hash
    diag_section(".hash: returning @hash")
    @hash
  end #def hash

=begin
  ==OutputUtils::bighash
  #returns a hash of the attributes (as bigdecimals.)  
=end
  def bighash
    diag_section(".bighash: printing shape properties hash")

    @bighash
  end #def bighash

=begin
  ==OutputUtils::columns_header
=end
  def columns_header
    puts ""
    puts "d    t      a       w       i       s       r"
  end #def columns_header

=begin
  ==OutputUtils::columns
  # FIXME: fix the column method, collapse into an orderly single line
=end
  def columns
    diag_section(".columns: printing shape properties in column format")
    puts "#{@x.round(4).to_f}  #{@t.round(4).to_f}  #{@a.round(4).to_f}  #{@w.round(4).to_f}  #{@i.round(4).to_f}  #{@s.round(4).to_f}  #{@r.round(4).to_f}"
  end #def columns

end #OutputUtils


#############################
###   ShapeUtils Module   ###
#############################

=begin

  ==ShapeUtils
  this module handles i/o of the calculated shape values
  note: all Shape classes mixin this module

=end
module ShapeUtils
  
=begin
  ==Float::to_d
  adds to_d method to Float class
=end
  class Float
    def to_d
      BigDecimal(self.to_s)
    end #def to_d
  end #class Float

=begin
  ==ShapeUtils:corner_radius
  Will determine rectangular tubing corner radius based on perimeter & thickness
=end
  def corner_radius
    diag_section("Calculating Corner Radius")
    
    if $radius_factors.key?(@t)
      @ra = BigDecimal.new("#{$radius_factors[@t]}")
#      diag_line("radius was calculated")
    else
      @ra = BigDecimal.new("0.03125")
      diag_line("radius could not be calculated: using default value")
    end #if

#    equiv_diam = (((@x * 2) + (@y * 2)) / Pi)
#    diag_line("equivalent diameter:   #{equiv_diam.round(4)}, #{equiv_diam.class}")
    diag_line("@radius:                #{@ra.to_f.to_s}, #{@ra.class}")


  end #def corner_radius

=begin
  ==ShapeUtils::gauge_converter
  This method examines the @t (thickness) variable to see if it is a decimal number or a gauge number.
  @t > 1 are converted to the decimal number equivalents via a case statement.
  @t < 1 are kept as is
=end
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

=begin
  ==ShapeUtils::weight
  This method calculates the weight of the shape
=end
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

=begin

Class Round_tube(od, thickness)
  Methods:
  .initialize

a round_rube object is part of the shape class
  accepts 2 inputs via args
    @x = outside diameter
    @t = thickness of tubing

  calculates 5 instance variables from the input args
    @a - sq. area
    @i - second Second Moment of Inertia
    @s - section modulus
    @r - radius of gyration
    @w - weight per foot
=end
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

=begin

Class Square_tube(od, thickness, radius)
  Methods:
    .initialize

  accepts 3 inputs via args
    @x  = size
    @t  = thickness of tubing
    @ra = radius at corner

  calculates 5 instance variables from the input args
    @a - sq. area
    @i - static Second Moment of Inertia
    @s - section modulus
    @r - radius of gyration
    @w - weight per foot

=end
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

=begin
Class Rec_tubing(d_x, d_y, ra, thick)

WARNING - THE RECTANGULAR TUBING MATH IS BROKEN

  definition of variables
  d = box tube width, height
  ra = radius of corner
  t = wall thickness

Methods      

=end
class Rec_tube
  attr_accessor :x, :y, :t, :ra, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w  
  include ShapeUtils; include DiagUtils; include OutputUtils
    
  private
  
  def initialize(x, y, t)
    diag_class   

    @x = x.to_s.to_d
    @y = y.to_s.to_d
    @t = t.to_s

    corner_radius
    gauge_converter
    
    #----------calculate area----------
    @a = (@t*((BigDecimal.new("2")*(@x+@y))-( BigDecimal.new("8")*@ra)+(Pi*(( BigDecimal.new("2")*@ra)-@t))))

    #method - calculate Second Moment of Inertia
=begin
    def calc_i(c, b)
      sec_1 = ( (@t** BigDecimal.new("3")) * (b - ( BigDecimal.new("2")*@ra) ) )/ BigDecimal.new("6")
      sec_2 =  BigDecimal.new("2")*@t*(b-( BigDecimal.new("2")*@ra))
      sec_3 = ((c-@t)/ BigDecimal.new("2"))** BigDecimal.new("2")
      sec_4 = (@t*(  (c-( BigDecimal.new("2")*@ra))** BigDecimal.new("3")))/ BigDecimal.new("6")
      sec_5 = (Pi/ BigDecimal.new("4"))-( BigDecimal.new("8")/(( BigDecimal.new("9")/ BigDecimal.new("2"))*Pi))
    #  sec_5 = sec_5.to_d
      sec_6 = ((@ra** BigDecimal.new("4"))-((@ra-@t)** BigDecimal.new("4")))
      sec_7 = (( BigDecimal.new("8")*@t)*(@ra** BigDecimal.new("2"))*((@ra-@t)** BigDecimal.new("2"))) / ( ( BigDecimal.new("9")/ BigDecimal.new("2")) * Pi * (( BigDecimal.new("2")*@ra)-@t) )
    #  sec_7 = sec_7.to_d
      sec_8 = (Pi * @t * (( BigDecimal.new("2")*@ra)-@t))
      sec_9 = ((c/ BigDecimal.new("2"))-@ra)
      sec_12 =  BigDecimal.new("4") * ((@ra** BigDecimal.new("3")) - ((@ra-@t)** BigDecimal.new("3")))
      sec_13 =  BigDecimal.new("3") * Pi * ((@ra** BigDecimal.new("2")) - ((@ra-@t)** BigDecimal.new("2")))
      sec_11 = (sec_12 / sec_13)
      sec_10 = ((sec_9 + sec_11)** BigDecimal.new("2"))

      @i = sec_1 + (sec_2 * sec_3) + sec_4 + (sec_5 * sec_6) - sec_7 + (sec_8 * sec_10)
      return(@i)
    end
=end
    
    #call calculate Second Moment of Inertia method
    @ix = BigDecimal.new("4") #calc_i(@y, @x)
    @iy = BigDecimal.new("5") #calc_i(@x, @y)
    
    #calculate Section Modulus method
    @sx = ((2*ix)/y)
    @sy = (2*iy/x)
    

    @rx = sqrt(@ix/@a, 9)
    @ry = sqrt(@iy/@a, 9)
    
    calc_weight
    
var_values
    build_hash
    diag_all

  end #def init
end #class Rec_tube

=begin

Class Bar(x)

FIXME: Check Math, guestimated most of it

#  definition of variables
#  x = bar dimension - x & y    

=end
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

=begin

Class Plate(x, y)

FIXME: Check Math, guestimated most of it

  definition of variables
  x = dimension
  y = dimension

=end
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

=begin

Class Rod(x)
  definition of variables
  x = diameter

=end
class Rod
  attr_accessor :x, :y, :a, :ix, :iy, :sx, :sy, :rx, :ry, :w
  include ShapeUtils; include DiagUtils; include OutputUtils
  
  def initialize(x)
    diag_class
    
    @x = x.to_s.to_d
    @y = @x
    #calculate area
    @a = Pi * (@x / 2)**2 
    
    #calculate Second Moment of Inertia
    @ix = @iy = (Pi/64)*(x**4)
    
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
#  columns_header
#  columns_header
#  Square_tube.new(1, 18).columns

#  Square_tube.new(1, 18).props
#  puts
#  Round_tube.new(4, 18).props

#  Rec_tube.new(1.0, 3.0, 0.065).props
  Bar.new(5.0).props
#  Plate.new(4, 5).props
#  Rod.new(2).props
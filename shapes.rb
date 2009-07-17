#!/usr/bin/env ruby

=begin

##################################
###   Shapes Library v 0.2.5   ###
###     Matthew D. Jordan      ###
###    www.scenic-shop.com     ###
### shared under the GNU GPLv3 ###
##################################

    TODO: create ShapeUtils::pipe_converter method, same as gauge_converter, based on schedule system
    TODO: create 
    TODO: Printers::gauge_converter - add 0ga, 00ga, 000ga, 0000ga
    TODO: Rework Printers:gauge_converter so that it does not contain the if statement
    TODO: create ShapeUtils::corner_radius method to automatically determine radius of corners
          -method:
            -calculate shape's perimeter (local var - perimeter) from @x & @y (or @d?)
            -use a case table to find the radius that is correct for the thickness and perimeter
            -save the result to the @ra variable
          -remove ra variable from ShapeClass.new invocation 
    TODO: 
    TODO: Create testing method/module/mixin to verify math and return a pass/fail
          -Manually enter several accurate results (through range of sizes) w/ corresponding inputs?
          -Check that calculations == accurate results
          -Give a prelim pass/fail based on results
    TODO: Add rod object with calculations (solid round shape)
    TODO: Add bar object with calculations (square v of plate)
    TODO: Add plate oject with calculations (rect. v of bar)
    TODO: hand calculate some of the properties and see if the float values fudge accuracy
    TODO: examine standardizing all return values from every class?
          -this would allow several methods to move from Shape specific classes to the ShapeUtils module
          -Hash, BigHash
    TODO: Merge Rec_tubing and Square_tubing class?


    FIXME: Rectangular tubing math is off just a little bit?
            -precision in the millionths seems to be off - determine where it is failing
            -seems to be affecting I, S, & R values (check others)
    FIXME: Fix rectangular tubing math (IT IS BROKEN) & verify
    FIXME: Bar class returns odd I values to bar.props
    FIXME: Fix bar math & verify - only guestimates
    

    ADDED: add ability to use gauges as input arguments as well as decimal thicknesses uses the Printer.gauge_converter method
    ADDED: let attributes be entered without trailing zeros & a decimal point

Library Structure
-----------------
  each shape object (cross section to analyze) will be an instance of that shape's class
  Class Round_tube(od, thickness)
    .initialize

  Class objects
    round_tube
    square_tube
    rectangular tubing
    rod
    bar
    plate

  Class ShapeUtils - i/o of calculated shape data
    .props
    .bigprops
    .hash
    .bighash
    .test_object
    .test_var
    .columns -> BROKEM
    .gauge_converter

=end
#require 'profile'
require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath

#Constants
Pi = BigDecimal.PI(20)


#############################
###   ShapeUtils Module   ###
#############################

=begin

  ==ShapeUtils
  this module handles i/o of the calculated shape values
  note: all Shape classes mixin this ShapeUtils Class

=end
module ShapeUtils
    #prints rounded (4 places) attributes as floats.  Normally will print all attributes or those specified with obj.props("attribute")
  def props(arg="list")
    if arg == "list"
      @hash.each {|key, value| puts "#{key}:  #{value}\n"}
    else
      puts @hash["#{arg}"]
    end
  end

  #prints the complete attributes as bigdecimals.   Normally will print all attributes or those specified with obj.bigprops("attribute")
  def bigprops(arg='i')
    if arg == 'i'
      @bighash.each {|key, value| puts "#{key}:  #{value}\n"}
      else  
      puts @bighash["#{arg}"]
    end
  end  
  
  #returns a hash of the attributes (rounded to 4 places, as floats.)
  def hash
    @hash
  end

  #returns a hash of the attributes (as bigdecimals.)  
  def bighash
     @bighash
  end
  
  # FIXME: fix the column method, collapse into an orderly single line
  def columns
        @hash.each {|key, value| p "#{value}"}
  end
  
  #test individual shape objects and return results
  def test_shape
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
  end

  def test_vars
    p "x:    #{@x.class}"
    p "y:    #{@y.class}"
    p "t:    #{@t.class}"
    p "ra:   #{@ra.class}"
    p "a:    #{@a.class}"
    p "i:    #{@i.class}"
    p "i_x:  #{@i_x.class}"
    p "i_y:  #{@i_y.class}"
    p "s:    #{@s.class}"
    p "s_x:  #{@s.class}"
    p "s_y:  #{@s.class}"
    p "r:    #{@r.class}"
    p "r_x:  #{@r_x.class}"
    p "r_y:  #{@r_y.class}"
    p "w:    #{@w.class}"
    p "Pi:   #{Pi.class}"
  end

  class Float 
    def big
      BigDecimal(self.to_s)
    end 
  end
  
=begin
  ==ShapeUtils::gauge_converter
  This method examines the @t (thickness) variable to see if it is a decimal number or a gauge number.
  @t > 1 are converted to the decimal number equivalents via a case statement.
  @t < 1 are kept as is
=end
  def gauge_converter
    if @t > 1 then
      case @t
      when 20
        @t = 0.035
      when 18
        @t = 0.049
      when 16
        @t = 0.065
      when 14
        @t = 0.083
      when 13
        @t = 0.095
      when 12
        @t = 0.109
      when 11
        @t = 0.120
      when 10
        @t = 0.134
      when 9
        @t = 0.148
      when 8
        @t = 0.165
      when 7
        @t = 0.180
      when 6
        @t = 0.203
      when 5
        @t = 0.220
      when 4
        @t = 0.238
      when 3
        @t = 0.259
      when 2
        @t = 0.284
      when 1
        @t = 0.300
      end
    if @t > 20
      puts "Please enter an accurate thickness, either as a decimal number or as a gauge number"
      exit
    end
    @t = @t.to_s.to_d
    end
  end

end


#########################
###   Shape Classes   ###
#########################

=begin

Class Round_tube(od, thickness)
  Methods:
  .initialize

a round_rube object is part of the shape class
  accepts 2 inputs via args
    @d = outside diameter
    @t = thickness of tubing

  calculates 5 instance variables from the input args
    @a - sq. area
    @i - second Second Moment of Inertia
    @s - section modulus
    @r - radius of gyration
    @w - weight per foot

=end
class Round_tube
  attr_accessor :d, :t, :a, :i, :s, :r, :w
  
  include ShapeUtils

  def initialize(d, t)  
    @d = d.to_s.to_d
    @t = t.to_s.to_d

    #declare class Variables
    @a = BigDecimal.new("0")
    @i = BigDecimal.new("0")
    @s = BigDecimal.new("0")
    @r = BigDecimal.new("0")
    @w = BigDecimal.new("0")

    #calculate Round tube Area
     @a = (Pi*@t) * (@d-@t)

     #Calculate Round Tube Second Moment of Inertia   
     @i = Pi * (@d**4 - ((@d - (2*@t))**4 ))/64

     #Calculate Round Tube Section Modulus
     @s = (2*@i)/@d

     #Calculate Round Tube Radius of Gyration 
     @r = sqrt(@i/@a, 9)

     #Calculate Round Tube Weight
     @w = (BigDecimal.new("3.3996")*@a)

     #add caculated values to a hash
     @hash = {"d" => @d.round(4).to_f, "t" => @t.round(4).to_f, "a" => @a.round(4).to_f, "i" => @i.round(4).to_f, "s" => @s.round(4).to_f, "r" => @r.round(4).to_f, "w" => @w.round(4).to_f }
     @bighash = {"d" => @d, "t" => @t, "a" => @a, "i" => @i, "s" => @s, "r" => @r, "w" => @w }
     return "#{self} created" 
  end 

end

=begin

Class Square_tube(od, thickness, radius)
  Methods:
    .initialize

  accepts 3 inputs via args
    @d  = outside diameter
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
  attr_accessor :d, :ra, :t, :a, :i, :s, :r, :w
  
  include ShapeUtils

  def initialize(d, t, ra)  


    @d = d.to_s.to_d
    @t = t.to_s.to_d
    @ra = ra.to_s.to_d
    
    gauge_converter
    
    #declare class Variables
    @a = BigDecimal.new("0")
    @i = BigDecimal.new("0")
    @s = BigDecimal.new("0")
    @r = BigDecimal.new("0")
    @w = BigDecimal.new("0")

    #calculate Square Area
    @a = (@t * ((4 * @d) - (8 * @ra) + ( Pi * (2*@ra - @t) ) ))

    #calculate Moment of I
    temp = BigDecimal.new("0")
    temp = ((@t**3*(@d-(2*@ra)))/6)
    temp = temp + (( 2 * @t * ( @d - ( 2 * @ra ))) * (( @d - @t ) / 2 )**2)
    temp = temp + (@t * ((@d-(2*@ra))**3)) /6
    temp = temp + (( Pi / 4 ) - 8 / ( ( 9 / 2 ) * Pi ) ) * ((@ra**4)-((@ra-@t)**4))
    temp = temp - (( 8 * @t ) * ( @ra**2 ) * ( @ra - @t ) ** 2 ) / ( (9/2) * ( Pi * (( 2 * @ra ) - @t )))

    temp2 = BigDecimal.new("0")
    b = BigDecimal.new("0")
    c = BigDecimal.new("0")
    x = BigDecimal.new("0")
    w = BigDecimal.new("0")
    #These fuckers all string together to make the last chunk of the formula
    w = 4 * (@ra**3 - ((@ra-@t)**3))
    x = (3 * Pi) * ((@ra**2) - ((@ra-@t)**2))
    b = ((Pi*@t) * ((2*@ra)-@t) )
    c = ((@d/2) - @ra + (@w/x))**2
    temp2 = b * c
    
    @i = temp + temp2
    
    #Section Modulus
    @s = ((2 * @i)/@d)
    
    #Radius of Gyration
    @r = (@i/@a).sqrt(2)
    
    #Weight / ft.
    @w = (3.3996.to_d*@a)


#    @hash = {"d" => @d.round(4).to_f, "t" => @t.round(4).to_f, "a" => @a.round(4).to_f, "i" => @i.round(4).to_f, "s" => @s.round(4).to_f, "r" => @r.round(4).to_s, "w" => @w.round(4).to_s }

    #add caculated values to a hash
    @hash = {"d" => @d.round(4), "t" => @t.round(4), "a" => @a.round(4), "i" => @i.round(4), "s" => @s.round(4), "r" => @r.round(4), "w" => @w.round(4) }
    @bighash = {"d" => @d, "t" => @t, "a" => @a, "i" => @i, "s" => @s, "r" => @r, "w" => @w }

  end
end

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
  attr_accessor :x, :y, :t, :ra, :a, :i_x, :i_y, :s_x, :s_y, :r_x, :r_y, :w
  
  include ShapeUtils
  
#  private
  
  def initialize(x, y, t, ra)  
    
    @x = x.to_s.to_d
    @y = y.to_s.to_d
    @t = t.to_s.to_d
    @ra = ra.to_s.to_d
    
    gauge_converter
    
    @a = BigDecimal.new("0")
    @c = BigDecimal.new("1")
    @i_x = BigDecimal.new("0")
    @i_y = BigDecimal.new("0")
    @s_x = BigDecimal.new("0")
    @s_y = BigDecimal.new("0")
    @r_x = BigDecimal.new("0")
    @r_y = BigDecimal.new("0")
    @w = BigDecimal.new("0")
    
    test_vars
    
    #----------calculate area----------
    @a = (@t*((BigDecimal.new("2")*(@x+@y))-( BigDecimal.new("8")*@ra)+(Pi*(( BigDecimal.new("2")*@ra)-@t))))

    #method - calculate Second Moment of Inertia
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
    
    #call calculate Second Moment of Inertia method
    @i_x = calc_i(@y, @x)
    @i_y = calc_i(@x, @y)
    
    #method - calculate Section Modulus
    def calc_s(i, c)
       @s = ((2*i)/c)
       return(@s)
    end
    
    #call calculate Section Modulus method
    @s_x = calc_s(@i_x, @y)
    @s_y = calc_s(@i_y, @x)
    
    
    #method - Radius of Gyration
    def calc_r(i)
       @r = sqrt(i/@a, 9)
       return(@r)
    end
    
    #call calculate radius of Gyration method
    @r_x = calc_r(@i_x)
    @r_y = calc_r(@i_y)
    
    
    #Weight / ft.
    @w = (3.3996.to_d*@a)
    
    #add caculated values to a hash
    @hash = {"x" => @x.round(4).to_f, "y" => @y.round(4).to_f, "t" => @t.round(4).to_f, "ra" => @ra.round(4).to_f, "a" => @a.round(4).to_f, "i_x" => @i_x.round(4).to_f, "i_y" => @i_y.round(4).to_f, "s_x" => @s_x.round(4).to_f, "s_y" => @s_y.round(4).to_f, "r_x" => @r_x.round(4).to_f, "r_y" => @r_y.round(4).to_f, "w" => @w.round(4).to_f }
    @bighash = {"x" => @x, "y" => @y, "t" => @t, "ra" => @ra, "a" => @a, "i_x" => @i_x, "i_y" => @i_y, "s_x" => @s_x, "s_y" => @s_y, "r_x" => @r_x, "r_y" => @r_y, "w" => @w }

  end
end

=begin

Class Bar(x)

FIXME: Check Math, guestimated most of it

#  definition of variables
#  x = bar dimension - x & y    

=end
class Bar
  attr_accessor :x, :a, :i, :s, :r, :w
  
  include ShapeUtils
  
  def initialize(x)

    
     @x = x.to_s.to_d
     
     @a = BigDecimal.new("0")
     @i = BigDecimal.new("0")
     @s = BigDecimal.new("0")
     @r = BigDecimal.new("0")
     @w = BigDecimal.new("0")
    
     #calculate area
     @a = @x * @x
    
     #calculate Second Moment of Inertia
     @i = (@x**4) / 12
    
     #calculate Section Modulus
     @s = (@x**3) / 6
    
     #calculate Radius of Gyration
     @r = sqrt(@i / @a, 2)
    
     #calculate weight per lin. foot
     @w = (3.3996.to_d*@a)
    
     #add caculated values to a hash
     @hash = {"x" => @x.round(4).to_f, "a" => @a.round(4).to_f, "i" => @i.round(4).to_f, "s" => @s.round(4).to_f, "r" => @r.round(4).to_f, "w" => @w.round(4).to_f }
     @bighash = {"x" => @x, "a" => @a, "i" => @i, "s" => @s, "r" => @r, "w" => @w }

  end #def
end #class Bar

=begin

Class Plate(x, y)

FIXME: Check Math, guestimated most of it

#  definition of variables
#  x = bar dimension - x & y    

=end
class Plate
  attr_accessor :x, :y, :a, :i_x, :i_y, :s_x, :s_y, :r_x, :r_y, :w
  
  include ShapeUtils
  
  def initialize(x, y)  
    @x = x.to_s.to_d
    @y = y.to_s.to_d
    
    @a = BigDecimal.new("0")
    @i_x = BigDecimal.new("0")
    @i_y = BigDecimal.new("0")
    @s_x = BigDecimal.new("0")
    @s_y = BigDecimal.new("0")
    @r_x = BigDecimal.new("0")
    @r_y = BigDecimal.new("0")
    @w = BigDecimal.new("0")
    

    #calculate area
    @a = @x * @y
    
    #calculate Second Moment of Inertia
    @i_x = (@x * @y**3) / 12
    @i_y = (@y * @x**3) / 12
    
    #calculate Section Modulus
#    @s = (@x**3) / 6

    #calculate Radius of Gyration
#    @r = sqrt(@i / @a, 2)

    #calculate weight per lin. foot
    @w = (3.3996.to_d*@a)

    #add caculated values to a hash
    @hash = {"x" => @x.round(4).to_f, "a" => @a.round(4).to_f, "i_x" => @i_x.round(4).to_f, "i_y" => @i_y.round(4).to_f, "s_x" => @s_x.round(4).to_f, "s_y" => @s_y.round(4).to_f, "r_x" => @r_x.round(4).to_f, "r_y" => @r_y.round(4).to_f, "w" => @w.round(4).to_f }
    @bighash = {"x" => @x, "a" => @a, "i_x" => @i_x, "i_y" => @i_y, "s_x" => @s_x, "s_y" => @s_y, "r_x" => @r_x, "r_y" => @r_y, "w" => @w }
  end
end


#require "rod.rb"


########################
###   Testing Area   ###
########################

#  Round_tube.new(1.5, 0.75).props
#  Square_tube.new(3, 18, 0.0625).props
  Rec_tube.new(1.0, 3.0, 0.065, 0.005).props
#  Bar.new(5.0).props
#  Plate.new(4, 5).props
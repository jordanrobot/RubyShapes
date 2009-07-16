#!/usr/bin/env ruby

=begin

##################################
###   Shapes Library v 0.2.1   ###
###     Matthew D. Jordan      ###
###    www.scenic-shop.com     ###
### shared under the GNU GPLv3 ###
##################################

    FIXME: Fix rectangular tubing math (IT IS BROKEN) & verify
    FIXME: Verify square tubing math & fix if broken

    TODO: add ability to use gauges as input arguments as well as decimal thicknesses
    FIXME: let attributes be entered without leading and trailing zeros & a decimal point
    
    TODO: Create method to automatically determine radius of corners based on ojbect args - use in calculations
    TODO: Create method to check math and return a preliminary pass/fail
      -Manually enter several accurate results (through range of sizes) w/ corresponding inputs
      -Check that calculations == accurate results
      -Give a prelim pass/fail based on results

    TODO: Add rod object with calculations (solid round shape)
    TODO: Add bar object with calculations (square v of plate)
    TODO: Add plate oject with calculations (rect. v of bar)
    FIXME: Bar class returns odd I values to bar.props
    FIXME: Fix bar math & verify - only guestimates

Library Structure
-----------------
  each shape object (cross section to analyze) will be an instance of that shape's class
  Class Round_tube(od, thickness)
    .initialize

  Class objects
    square_tube
    rectangular tubing
    rod
    bar
    plate

  Class Printers - outputs data
    .props
    .bigprops
    .hash
    .bighash
    .test_object

=end


require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath

#Constants
Pi = BigDecimal.PI(10)

#==Printers
#the methods in this class are solely used to 
#consistently output the calculated shapes data
#
#All Shape classes inherit the Printer Class

class Printers

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
    puts 'Return all values in the object (Floats):'
    self.props

    puts

    puts 'Return individual values (Floats):'
    self.props("t")

    puts

    puts 'Return all values in the ojbect (BigDecimals):'
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
  
end  


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

class Round_tube < Printers
  attr_accessor :d, :t, :a, :i, :s, :r, :w
#  attr_reader :d, :t, :a, :i, :s, :r, :w
  
  def initialize(d, t)  
    @d = d.to_d
    @t = t.to_d

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
     @w = (3.3996.to_d*@a)

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

class Square_tube < Printers
  attr_accessor :d, :ra, :t, :a, :i, :s, :r, :w
#  attr_reader :d, :t, :a, :i, :s, :r, :w

  def initialize(d, t, ra)  
    @d = d.to_d
    @t = t.to_d
    @ra = d.to_d

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
    
    temp = temp + temp2
    @i = temp
    
    #Section Modulus
    @s = ((2 * @i)/@d)
    
    #Radius of Gyration
    @r = sqrt(@i/@a, 9)
    
    #Weight / ft.
    @w = (3.3996.to_d*@a)

    #add caculated values to a hash
    @hash = {"d" => @d.round(4).to_f, "t" => @t.round(4).to_f, "a" => @a.round(4).to_f, "i" => @i.round(4).to_f, "s" => @s.round(4).to_f, "r" => @r.round(4).to_f, "w" => @w.round(4).to_f }
    @bighash = {"d" => @d, "t" => @t, "a" => @a, "i" => @i, "s" => @s, "r" => @r, "w" => @w }

  end
end


=begin

Class Rec_tubing(d_x, d_y, ra, thick)

WARNING - THE RECTANGULAR TUBING MATH IS NOT YET ACCURATE



#  definition of variables
#  d = box tube width, height
#  ra = radius of corner
#  t = wall thickness

Methods      

=end

#declare class Variables
class Rec_tube < Printers
  attr_accessor :x, :y, :t, :ra, :a, :i_x, :i_y, :s_x, :s_y, :r_x, :r_y, :w
#  attr_reader :x, :y, :t, :a, :i_x, :i_y, :s_x, :s_y, :r_x, :r_y, :w
  
  def initialize(x, y, t, ra)  
    @x = x.to_d
    @y = y.to_d
    @t = t.to_d
    @ra = ra.to_d
    
    @a = BigDecimal.new("0")
    @c = BigDecimal.new("1")
    @i_x = BigDecimal.new("0")
    @i_y = BigDecimal.new("0")
    @s_x = BigDecimal.new("0")
    @s_y = BigDecimal.new("0")
    @r_x = BigDecimal.new("0")
    @r_y = BigDecimal.new("0")
    @w = BigDecimal.new("0")
    
    #----------calculate area----------
    @a = (@t*((2*(@x+@y))-(8*@ra)+(Pi*((2*@ra)-@t))))

    #method - calculate Second Moment of Inertia
    def calc_i(c, b)
      sec_1 = ( (@t**3) * (b - (2*@ra) ) )/6
      sec_2 = 2*@t*(b-(2*@ra))
      sec_3 = ((c-@t)/2)**2
      sec_4 = (@t*(  (c-(2*@ra))**3))/6
      sec_5 = (Pi/4)-(8/((9/2)*Pi))
    #  sec_5 = sec_5.to_d
      sec_6 = ((@ra**4)-((@ra-@t)**4))
      sec_7 = ((8*@t)*(@ra**2)*((@ra-@t)**2)) / ( (9/2) * Pi * ((2*@ra)-@t) )
    #  sec_7 = sec_7.to_d
      sec_8 = (Pi * @t * ((2*@ra)-@t))
      sec_9 = ((c/2)-@ra)
      sec_12 = 4 * ((@ra**3) - ((@ra-@t)**3))
      sec_13 = 3 * Pi * ((@ra**2) - ((@ra-@t)**2))
      sec_11 = (sec_12 / sec_13)
      sec_10 = ((sec_9 + sec_11)**2)

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


#Create square Bar class
class Bar < Printers
  attr_accessor :x, :a, :i, :s, :r, :w
  
  def initialize(x)  
    @x = x.to_d
    
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

    #add caculated values to a hash
    @hash = {"x" => @x.round(4).to_f, "a" => @a.round(4).to_f, "i" => @i.round(4).to_f, "s" => @s.round(4).to_f, "r" => @r.round(4).to_f, "w" => @w.round(4).to_f }
    @bighash = {"x" => @x, "a" => @a, "i" => @i, "s" => @s, "r" => @r, "w" => @w }
  end
end

#require "plate.rb"
#require "rod.rb"

#query all shape objects

#  batten = Round_tube.new(1.5, 0.75)
#  batten.columns

#  box = Square_tube.new(3.0, 0.125, 0.005)
#  box.test_shape

#  beam = Rec_tube.new(1.0, 3.0, 0.065, 0.005)
#  beam.test_shape

  beam = Bar.new(5.0)
  beam.test_shape
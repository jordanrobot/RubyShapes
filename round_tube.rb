=begin

As-welded Mechanical Tubing - Round Tubing

initial variables
  d = outside diameter of tubing
  t = wall thickness of tubing

a round_rube object is part of the shape class
  accepts 2 inputs
    diameter
    thickness
  calculates 7 intstance variables
    @d - diameter
    @t - thickness
    @a - sq. area
    @i - static moment of inertia
    @s - section modulus
    @r - radius of gyration
    @w - weight per foot

Methods:

  initialize
    creates and calculates the object values
  props
    method to return alist of rounded, calculated float values
    accepts variables to return specific properties
  bigprops - 
    returns a list of precise bigdecimal values
    accepts variables to return specific properties
  hash
    returns a hash of the rounded float values, properties are keys
  bighash
    returns a hash of the precise values, properties are keys
    
=end

class Round_tube
  attr_accessor :d, :t, :a, :i, :s, :r, :w
    
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

     #Calculate Round Tube Moment of Inertia   
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
  end 


  def props(arg="list")
    #print rounded truncated values
    if arg == "list"
      @hash.each {|key, value| puts "#{key}:  #{value}\n"}
      else
      puts @hash["#{arg}"]
    end
  end

  def bigprops(arg="list")
    #print rounded truncated values
    if arg == "list"
      @bighash.each {|key, value| puts "#{key}:  #{value}\n"}
      else  
      @bighash["#{arg}"]
    end
  end  
  
  def hash
    @hash
  end

  def bighash
    @bighash
  end

end
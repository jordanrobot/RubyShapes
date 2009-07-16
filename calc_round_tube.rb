# ------As-welded Mechanical Tubing - Round Tubing--------

#  definition of variables
#  d = box tube width, height
#  r = radius of corner
#  t = wall thickness

require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath

#declare Constants
Pi = BigDecimal.PI(10)

#declare class Variables
a = BigDecimal.new("0")
i = BigDecimal.new("0")
s = BigDecimal.new("0")
r = BigDecimal.new("0")
w = BigDecimal.new("0")

#-------------initial values - placeholder until they become instances of variables used by methods in this class
d = 1.5.to_d
t = 0.049.to_d

#calculate Round tube Area
   a = (Pi*t) * (d-t)

#Calculate Round Tube Moment of Inertia   
   i = Pi * (d**4 - ((d - (2*t))**4 ))/64

#Calculate Round Tube Section Modulus
   s = (2*i)/d

#Calculate Round Tube Radius of Gyration 
   r = sqrt(i/a, 9)

#Calculate Round Tube Weight
   w = (3.3996.to_d*a)


#print rounded truncated values
puts "d = " + d.round(4).to_s('5F')
puts "t = " + t.round(4).to_s('5F')
puts "a = " + a.round(4).to_s('5F')
puts "i = " + i.round(4).to_s('5F')
puts "s = " + s.round(4).to_s('5F')
puts "r = " + r.round(4).to_s('5F')
puts "w = " + w.round(4).to_s('5F')
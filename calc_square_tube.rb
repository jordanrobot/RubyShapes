# ------As-welded Mechanical Tubing - Square Tubing--------

#  definition of variables
#  d = box tube width, height
#  ra = radius of corner
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
ra = 0.0625.to_d

#the calcs
  a = (t * ((4 * d) - (8 * ra) + ( Pi * (2*ra - t) ) ))


#calculate Moment of I
   temp = BigDecimal.new("0")
   temp = ((t**3*(d-(2*ra)))/6)
   temp = temp + (( 2 * t * ( d - ( 2 * ra ))) * (( d - t ) / 2 )**2)
   temp = temp + (t * ((d-(2*ra))**3)) /6
   temp = temp + (( Pi / 4 ) - 8 / ( ( 9 / 2 ) * Pi ) ) * ((ra**4)-((ra-t)**4))
   temp = temp - (( 8 * t ) * ( ra**2 ) * ( ra - t ) ** 2 ) / ( (9/2) * ( Pi * (( 2 * ra ) - t )))

   temp2 = BigDecimal.new("0")
   b = BigDecimal.new("0")
   c = BigDecimal.new("0")
   x = BigDecimal.new("0")
   w = BigDecimal.new("0")
#These fuckers all string together to make the last chunk of the formula
   w = 4 * (ra**3 - ((ra-t)**3))
   x = (3 * Pi) * ((ra**2) - ((ra-t)**2))
   b = ((Pi*t) * ((2*ra)-t) )
   c = ((d/2) - ra + (w/x))**2
   temp2 = b * c

   temp = temp + temp2
   i = temp

#Section Modulus
   s = ((2 * i)/d)

#Radius of Gyration
   r = sqrt(i/a, 9)

#Weight / ft.
   w = (3.3996.to_d*a)

   #print rounded truncated values
   puts "d = " + d.round(4).to_s('5F')
   puts "t = " + t.round(4).to_s('5F')
   puts "a = " + a.round(4).to_s('5F')
   puts "i = " + i.round(4).to_s('5F')
   puts "s = " + s.round(4).to_s('5F')
   puts "r = " + r.round(4).to_s('5F')
   puts "w = " + w.round(4).to_s('5F')
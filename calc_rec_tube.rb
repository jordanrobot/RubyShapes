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
i_x = BigDecimal.new("0")
i_y = BigDecimal.new("0")
s_x = BigDecimal.new("0")
s_y = BigDecimal.new("0")
r_x = BigDecimal.new("0")
r_y = BigDecimal.new("0")
w = BigDecimal.new("0")

#-------------initial values - placeholder until they become instances of variables used by methods in this class
x = 1.0.to_d
y = 2.5.to_d
t = 0.165.to_d
ra = 0.375.to_d

#----------calculate area----------
a = (t*((2*(x+y))-(8*ra)+(Pi*((2*ra)-t))))


#method - calculate Moment of Inertia
def calc_i(c, b, t, ra)
  sec_1 = ( (t**3) * (b - (2*ra) ) )/6
  sec_2 = 2*t*(b-(2*ra))
  sec_3 = ((c-t)/2)**2
  sec_4 = (t*(  (c-(2*ra))**3))/6
  sec_5 = (Pi/4)-(8/((9/2)*Pi))
#  sec_5 = sec_5.to_d
  sec_6 = ((ra**4)-((ra-t)**4))
  sec_7 = ((8*t)*(ra**2)*((ra-t)**2)) / ( (9/2) * Pi * ((2*ra)-t) )
#  sec_7 = sec_7.to_d
  sec_8 = (Pi * t * ((2*ra)-t))
  sec_9 = ((c/2)-ra)
  sec_12 = 4 * ((ra**3) - ((ra-t)**3))
  sec_13 = 3 * Pi * ((ra**2) - ((ra-t)**2))
  sec_11 = (sec_12 / sec_13)
  sec_10 = ((sec_9 + sec_11)**2)

  i = sec_1 + (sec_2 * sec_3) + sec_4 + (sec_5 * sec_6) - sec_7 + (sec_8 * sec_10)
  return(i)
end

#call calculate Moment of Inertia method
i_x = calc_i(y, x, t, ra)
i_y = calc_i(x, y, t, ra)

#========TEMP VALUES========
#i_x = 1.0083
#i_x = i_x.to_d
#i_y = 0.1732
#i_y = i_y.to_d
#===========================

#method - calculate Section Modulus
def calc_s(i, c)
   s = ((2*i)/c)
   return(s)
end

#call calculate Section Modulus method
s_x = calc_s(i_x, y)
s_y = calc_s(i_y, x)


#method - Radius of Gyration
def calc_r(i, a)
   r = sqrt(i/a, 9)
   return(r)
end

#call calculate radius of Gyration method
r_x = calc_r(i_x, a)
r_y = calc_r(i_y, a)


#Weight / ft.
w = (3.3996.to_d*a)

#print rounded truncated values
   puts "b = " + x.round(4).to_s('5F')
   puts "c = " + y.round(4).to_s('5F')
   puts "t = " + t.round(4).to_s('5F')
   puts "a = " + a.round(4).to_s('5F')
   puts "w = " + w.round(4).to_s('5F')
   puts
   puts "I_x = " + i_x.round(4).to_s('5F')
   puts "S_x = " + s_x.round(4).to_s('5F')
   puts "r_x = " + r_x.round(4).to_s('5F')
   puts
   puts "I_y = " + i_y.round(4).to_s('5F')
   puts "S_y = " + s_y.round(4).to_s('5F')
   puts "r_y = " + r_y.round(4).to_s('5F')
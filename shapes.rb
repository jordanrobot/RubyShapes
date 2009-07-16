=begin

Shapes Library Version 0.1.1 Improvements

Turn Shapes into a Module
  each cross section shape will be an instance of that shape's class
    round tubing
    square tubing
    rectangular tubing
    rod
    bar
    plate
  Pi will be a module constant?

solutions are method instance variables?

=end

require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
include BigMath

#declare Constants
Pi = BigDecimal.PI(10)

#require varying shape classes
require "round_tube.rb"
#require "square_tube.rb"
#require "rec_tube.rb"
#require "bar.rb"
#require "plate.rb"


#test class Roudn_tube
a = Round_tube.new(1.5, 0.75)

#puts a.hash["w"]
#a.props
puts 'props'
a.props
puts ""

puts 'props a'
a.props("a")
puts ""

puts 'bigprops'
a.bigprops
puts ""

puts 'bigprops area'
a.bigprops("a")
puts ""

puts 'hash'
puts a.hash

puts ""

puts 'bighash'
a.bighash

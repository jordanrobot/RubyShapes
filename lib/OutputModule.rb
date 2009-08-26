#!/usr/bin/env ruby

#RubyShapes
#
#Copyright 2009 Matthew D. Jordan
#www.scenic-shop.com
#shared under the GNU GPLv3

##############################
###   OutputUtils Module   ###
##############################

#this module handles i/o of the calculated shape values
module Output

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

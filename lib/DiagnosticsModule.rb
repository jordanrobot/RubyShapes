#!/usr/bin/env ruby

#RubyShapes
#
#Copyright 2009 Matthew D. Jordan
#www.scenic-shop.com
#shared under the GNU GPLv3

##############################
###   Diagnostics Module   ###
##############################

#This module handles Diagnostic messages.
module Diagnostics

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


#Prints all Output Module methods at once for any given shape object. Only prints when Diagnostics = on
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
  
end #Diagnostics Module
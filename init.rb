###  Food finder  ### 

# Launch this from command line
# to get started

APP_ROOT = File.dirname(__FILE__)

# different approach for requiring file

# require "#{APP_ROOT}/lib/guide.rb"
# require File.join(APP_ROOT, "lib", "guide.rb")
# require File.join(APP_ROOT, "lib", "guide")


# advanced approach

$:.unshift(File.join(APP_ROOT, "lib"))
require "guide" 

guide = Guide.new("restaurant.txt")
guide.launch!
require 'rubygems'
require 'ap'

#require 'hirb'
#Hirb.enable :output=>{'Object'=>{:class=>:auto_table, :ancestor=>true}}

#require 'wirble'
#Wirble.init
#Wirble.colorize

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# quit alias
alias q exit

# Log to STDOUT if in Rails
# can get annoying!
#if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
#  require 'logger'
#  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
#end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'nscript'
require 'rspec'
require "pry"

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each do |f|
  require f
end

RSpec.configure do |config|
  config.before(:each) { NScript.reset! }
end
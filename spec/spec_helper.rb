lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'rubygems'
gem 'rspec'
require 'spec'

gem 'activerecord'
require 'active_record'
require 'model_mocker'


Spec::Runner.configure do |config|
  config.mock_with :mocha
end

class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    saved_protected_instance_methods = self.protected_instance_methods
    self.class_eval do
      public *saved_private_instance_methods
      public *saved_protected_instance_methods
    end
    
    yield
    
    self.class_eval do
      private *saved_private_instance_methods
      protected *saved_protected_instance_methods
    end
  end
end

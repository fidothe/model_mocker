require 'active_record/base'
require 'mocha'

class ActiveRecord::Base
  # Create a new instance of the class, pass in creation params and then 
  # yield the ModelMocker instance so that methods can be called on it
  def self.mock(params = {})
    mock_model = ModelMocker.new(self, params)
    yield(mock_model) if block_given?
    mock_model.instance
  end
end

# An easy way of generating partially mocked <tt>ActiveRecord</tt> model objects. 
# This is a useful way of simulating some aspects of a model (like the 
# persistence layer) but leaving the domain logic parts intact, so that 
# you can test those in isolation, without worrying about database reads 
# and writes.
class ModelMocker
  # Provides instance method replacements for the <tt>ActiveRecord::Base</tt> instances created by <tt>#mock</tt> 
  module Helpers
    def connection
      raise StandardError, "mock model instances are not allowed to access the database"
    end
    
    def new_record?
      id.nil?
    end
  end
  
  # ModelMocker.new is called with the AR::Base subclass a mock object is for,
  # with any creation params in stub_params. Methods on the ModelMocker instance 
  # determine how the mock AR::Base subclass object will behave
  def initialize(klass, stub_params = {})
    @klass = klass
    @stub_params = stub_params
  end
  
  def instance # :nodoc:
    return @instance unless @instance.nil?
    id = @stub_params[:id]
    @instance = @klass.new
    attributes.each do |k, v|
      @instance.write_attribute(k, v)
    end
    @instance.stubs(:id).returns(id)
    stub_instance_methods!
    @instance.extend(ModelMocker::Helpers)
    @instance
  end
  
  # The model instance will report that it's a new record
  def as_new_record
    instance.stubs(:new_record?).returns(true)
  end
  
  # Validity-related methods will always report that the instance is valid, 
  # and <tt>#save</tt> and <tt>#save!</tt> will return true (without actually saving anything)
  def valid
    instance.stubs(:valid?).returns(true)
    instance.stubs(:save).returns(true)
    instance.stubs(:save!).returns(true)
  end
  
  # Validity-related methods will always report that the instance is invalid, 
  # <tt>#save</tt> will return false, and <tt>#save!</tt> will raise <tt>ActiveRecord::RecordNotSaved</tt>
  def invalid
    instance.stubs(:valid?).returns(false)
    instance.stubs(:save).returns(false)
    instance.stubs(:save!).raises(ActiveRecord::RecordNotSaved)
  end
  
  # The model instance cannot be updated: <tt>#update_attributes</tt> will always return false
  def cannot_be_updated
    instance.stubs(:update_attributes).returns(false)
  end
  
  # The model instance will return true if <tt>#destroy</tt> is called
  def can_be_destroyed
    instance.stubs(:destroy).returns(true)
  end
  
  # The model instance will return false if <tt>#destroy</tt> is called
  def cannot_be_destroyed
    instance.stubs(:destroy).returns(false)
  end
  
  protected
  
  def valid_columns # :nodoc:
    @valid_columns ||= @klass.columns_hash.collect { |k,v| k }
  end
  
  def attributes # :nodoc:
    Hash[*(@stub_params.select { |attr_name, value| valid_columns.include?(attr_name.to_s) }.flatten)].reject {|k, v| k.to_s == 'id'}
  end
  
  def method_stubs # :nodoc:
    Hash[*(@stub_params.reject { |attr_name, value| valid_columns.include?(attr_name.to_s) }.collect { |k, v| [k.to_sym, v] }).flatten]
  end
  
  def stub_instance_methods! # :nodoc:
    method_stubs.each do |meth, value|
      instance.stubs(meth).returns(value)
    end
  end
end

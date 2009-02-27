require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

class FakeARClass
  class << self
    def columns_hash
      {'id' => :id, 'thing' => :thing, 'wotsit' => :wotsit}
    end
  end
end

describe ModelMocker do
  describe "working out which args are attributes and which are method stubs" do
    before(:each) do
      @mm = ModelMocker.new(FakeARClass, {:id => 1, :thing => 'value', :wotsit => 'value', :gubbins => 'value'})
    end
    
    it "should figure out that :gubbins is not an attribute" do
      ModelMocker.publicize_methods do
        @mm.attributes.should == {:thing => 'value', :wotsit => 'value'}
      end
    end
    
    it "should figure that :gubbins should be a method stub" do
      ModelMocker.publicize_methods do
        @mm.method_stubs.should == {:gubbins => 'value'}
      end
    end
  end
  
  describe "working out which args are attributes and which are method stubs when the keys are strings not symbols" do
    before(:each) do
      @mm = ModelMocker.new(FakeARClass, {'id' => 1, 'thing' => 'value', 'wotsit' => 'value', 'gubbins' => 'value'})
    end
    
    it "should figure out that 'gubbins' is not an attribute" do
      ModelMocker.publicize_methods do
        @mm.attributes.should == {'thing' => 'value', 'wotsit' => 'value'}
      end
    end
    
    it "should figure that 'gubbins' should be a method stub, and called :gubbins" do
      ModelMocker.publicize_methods do
        @mm.method_stubs.should == { :gubbins => 'value' }
      end
    end
  end
end
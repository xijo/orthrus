require 'spec_helper'

describe Orthrus do

  it "should set remote default options" do
    options = Planet.instance_variable_get(:@remote_options)
    options.should_not be_nil
    options.stack.should_not be_empty
    options.build
    options[:base_uri].should == "http://astronomy.test"
    options[:http].should == { :authentication => 'Basic authentication' }
    options[:params].should == { :format => "json" }
  end

  it "should inherit remote default options" do
    options = Rock.instance_variable_get(:@remote_options)
    options.should_not be_nil
    options.stack.should_not be_empty
    options.build
    options[:base_uri].should == "http://astronomy.test/rocks"
    options[:http].should == { :authentication => 'Basic authentication' }
    options[:params].should == { :format => "json" }
  end

  it "should define remote methods" do
    Planet.should respond_to(:find_by_identifier)
    Planet.should respond_to(:all)
    Planet.instance_variable_get(:@remote_methods).keys.size.should == 2
  end

  it "should assign remote options to remote methods correctly" do
    methods = Planet.instance_variable_get(:@remote_methods)

    find_by_identifier = methods[:find_by_identifier]
    find_by_identifier.options.build
    find_by_identifier.options[:path].should == 'planets/:identifier'
    find_by_identifier.options[:params].should == { :include_details => true, :format => 'json' }

    all = methods[:all]
    all.options.build
    all.options[:path].should == 'planets'
  end

end

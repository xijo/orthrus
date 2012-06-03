require 'spec_helper'

describe Orthrus do

  it "should set remote default options" do
    options = Planet.remote_options.build
    options[:base_uri].should == "http://astronomy.test/"
    options[:http].should == { :authentication => 'Basic authentication' }
    options[:params].should == { :format => "json" }
  end

  it "should inherit remote default options" do
    remote_options = Comet.remote_options
    remote_options.should_not be_nil
    remote_options.stack.should_not be_empty
    options = remote_options.build
    options[:base_uri].should == "http://astronomy.test/comets"
    options[:http].should == { :authentication => 'Basic authentication' }
  end

  it "should define remote methods" do
    Planet.should respond_to(:find_by_identifier)
    Planet.should respond_to(:all)
    Planet.remote_methods.keys.size.should == 2
  end

  it "should have a working respond_to" do
    Planet.should_not respond_to(:foobar)
  end

  it "should should call the corresponding remote method" do
    Planet.find_by_identifier(:identifier => :mars).should_not be_nil
  end

  describe "#call_remote_method" do
    it "should " do
      response = Planet.call_remote_method(:find_by_identifier, { :identifier => :mars })
      response.should == @mars_response
    end
  end

  it "should assign remote options to remote methods correctly" do
    methods = Planet.remote_methods

    options = methods[:find_by_identifier].remote_options.build
    options[:path].should == 'planets/:identifier'
    options[:params].should == { :include_details => true, :format => 'json' }

    options = methods[:all].remote_options.build
    options[:path].should == 'planets'
  end

end

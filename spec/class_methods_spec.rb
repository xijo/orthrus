require 'spec_helper'

describe Orthrus do

  it "should set remote default options" do
    options = Planet.instance_variable_get(:@remote_options)
    options.should_not be_nil
    options.stack.should_not be_empty
    options.build
    puts options.stack.inspect
    # options[:base_uri].should == "http://astronomical.test"
    # options[:params][:format].should == "json"
    # options[:headers][:authentication].should == "Basic authentication"
    # assert_equal "http://astronomical.test", defaults[:base_uri]
    # assert_equal "Basic authentication", defaults[:headers][:authentication]
    # assert_equal "json", defaults[:params][:format]
  end

  it "description" do
    options = Rock.instance_variable_get :@remote_options
    puts options.stack.inspect
    puts options.inspect
  end

end

# require 'test_helper'

# class TestClassMethods < Test::Unit::TestCase

#   def test_setting_remote_defaults
#     assert_not_nil defaults = Astronomy.instance_variable_get(:@remote_options)
#     assert_equal "http://astronomical.test", defaults[:base_uri]
#     assert_equal "Basic authentication", defaults[:headers][:authentication]
#     assert_equal "json", defaults[:params][:format]
#   end

#   def test_overwritting_remote_defaults_in_subclass
#     assert_not_nil defaults = Biology.instance_variable_get(:@remote_options)
#     assert_equal "http://biological.test", defaults[:base_uri]
#     assert_equal "Basic authentication", defaults[:headers][:authentication]
#     assert_equal "json", defaults[:params][:format]
#     assert_equal false, defaults[:params][:boring]
#   end

#   def test_define_remote_method
#     assert Astronomy.respond_to? :find
#   end
# end
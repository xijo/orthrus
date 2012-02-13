require 'spec_helper'

describe Orthrus::RemoteOptions do
  it "should perform deep merge" do
    remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json}).build
    remote_options = remote_options.smart_merge(:params => {:planet => :juno})
    remote_options[:params][:format].should == :json
    remote_options[:params][:planet].should == :juno
    remote_options = remote_options.smart_merge(:params => {:planet => {:foo => :bar}})
    remote_options[:params][:planet][:foo].should == :bar
  end

  it "should build options from the stack" do
    remote_options = Orthrus::RemoteOptions.new
    remote_options.stack << lambda { |c| c.foo = "bar" }
    remote_options.stack << { :labra => :doodle }
    remote_options.stack << { :foo => :foo }
    remote_options.stack << lambda { |c| c.labra = :dabra }
    remote_options.stack << "ignore_me!"
    remote_options.build.should == { :foo => :foo, :labra => :dabra }
  end

  it "should add the initial parameters to its stack" do
    option = Orthrus::RemoteOptions.new(:foo => :bar)
  end
    def test_remote_options_init
    remote_options = Orthrus::RemoteOptions.new(:base_uri => "http://astronomical.joe", :params => {:format => :json})
    assert_kind_of Hash, remote_options
    assert_equal "http://astronomical.joe", remote_options[:base_uri]
    assert_equal :json, remote_options[:params][:format]
  end
end


# require 'test_helper'

# class TestRemoteOptions < Test::Unit::TestCase
#   def test_remote_options_init
#     remote_options = Orthrus::RemoteOptions.new(:base_uri => "http://astronomical.joe", :params => {:format => :json})
#     assert_kind_of Hash, remote_options
#     assert_equal "http://astronomical.joe", remote_options[:base_uri]
#     assert_equal :json, remote_options[:params][:format]
#   end

#   def test_remote_options_merge
#     remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json})
#     remote_options = remote_options.smart_merge(:params => {:planet => :juno})
#     assert_equal :json, remote_options[:params][:format]
#     assert_equal :juno, remote_options[:params][:planet]
#   end

#   def test_remote_options_merge_on_self
#     remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json})
#     remote_options.smart_merge!(:params => {:planet => :juno})
#     assert_equal :json, remote_options[:params][:format]
#     assert_equal :juno, remote_options[:params][:planet]
#   end

#   def test_remote_options_merge_with_nil
#     remote_options = Orthrus::RemoteOptions.new(:params => {:format => :xml})
#     remote_options.smart_merge!(nil)
#     assert_equal :xml, remote_options[:params][:format]
#   end
# end

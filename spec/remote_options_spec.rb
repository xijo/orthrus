require 'spec_helper'

describe Orthrus::RemoteOptions do

  it "should hold a stack of options" do
    remote_options = Orthrus::RemoteOptions.new
    remote_options.push(:params => {:planet => :juno})
    remote_options.push(lambda { 'mars' })
    remote_options.push(nil)
    remote_options.stack.size.should == 3
  end

  it "should build options from the stack" do
    remote_options = Orthrus::RemoteOptions.new
    remote_options.push lambda { |c| c.foo = "bar" }
    remote_options.push :labra => :doodle
    remote_options.push :foo => :foo
    remote_options.push lambda { |c| c.labra = :dabra }
    remote_options.push "ignore_me!"
    remote_options.build.should == { :foo => :foo, :labra => :dabra }
  end

  it "should add the initial parameters to its stack" do
    remote_options = Orthrus::RemoteOptions.new(:foo => :bar)
    remote_options.stack.should == [{:foo => :bar}]
  end

  it "smart_merge should merge values from 2nd level" do
    remote_options = Orthrus::RemoteOptions.new
    remote_options.instance_variable_set(:@result, { :params => { :foo => 'bar' } })
    result = remote_options.smart_merge({ :params => { :foo => 'foo' } })
    result[:params][:foo].should == 'foo'
  end

  it "smart_merge! should write results into @result" do
    remote_options = Orthrus::RemoteOptions.new
    remote_options.instance_variable_set(:@result, { :foo => 'bar' })
    remote_options.smart_merge!(:foo => 'foo')
    remote_options.instance_variable_get(:@result).should == {:foo => 'foo'}
  end



  it "should perform deep merge" do
    # remote_options


    # remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json})
    # remote_options.build
    # result = remote_options.smart_merge(:params => {:planet => :juno})
    # result[:params][:format].should == :json
    # result[:params][:planet].should == :juno
    # result = remote_options.smart_merge(:params => {:planet => {:foo => :bar}})
    # result[:params][:planet][:foo].should == :bar
  end

  #   def test_remote_options_init
  #   remote_options = Orthrus::RemoteOptions.new(:base_uri => "http://astronomical.joe", :params => {:format => :json})
  #   assert_kind_of Hash, remote_options
  #   assert_equal "http://astronomical.joe", remote_options[:base_uri]
  #   assert_equal :json, remote_options[:params][:format]
  # end
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

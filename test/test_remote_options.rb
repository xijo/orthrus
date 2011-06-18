require 'test_helper'

class TestRemoteOptions < Test::Unit::TestCase
  def test_remote_options_init
    remote_options = Orthrus::RemoteOptions.new(:base_uri => "http://astronomical.joe", :params => {:format => :json})
    assert_kind_of Hash, remote_options
    assert_equal "http://astronomical.joe", remote_options[:base_uri]
    assert_equal :json, remote_options[:params][:format]
  end

  def test_remote_options_merge
    remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json})
    remote_options = remote_options.smart_merge(:params => {:planet => :juno})
    assert_equal :json, remote_options[:params][:format]
    assert_equal :juno, remote_options[:params][:planet]
  end

  def test_remote_options_merge_on_self
    remote_options = Orthrus::RemoteOptions.new(:params => {:format => :json})
    remote_options.smart_merge!(:params => {:planet => :juno})
    assert_equal :json, remote_options[:params][:format]
    assert_equal :juno, remote_options[:params][:planet]
  end

  def test_remote_options_merge_with_nil
    remote_options = Orthrus::RemoteOptions.new(:params => {:format => :xml})
    remote_options.smart_merge!(nil)
    assert_equal :xml, remote_options[:params][:format]
  end
end
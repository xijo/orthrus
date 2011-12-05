require 'test_helper'

class TestDefineRemoteMethod < Test::Unit::TestCase

  def test_path_interpolation
    remote_method = Orthrus::RemoteMethod.new
    args = { :id => 4, :child => 2, :another => 3 }
    interpolated  = remote_method.interpolate('/some/:id/with/:child', args)
    assert_equal "/some/4/with/2", interpolated
    assert_equal({ :another => 3 }, args)
  end

  def test_simple_remote_method_get
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.test",
      :path     => "/planets",
      :method   => :get
    )
    assert_equal @index_response.body, remote_method.run.body
  end

  def test_simple_remote_method_with_get_as_default
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.test",
      :path     => "/planets"
    )
    assert_equal @index_response.body, remote_method.run.body
  end

  def test_remote_method_with_interpolation
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.test",
      :path     => "/planets/:identifier",
      :method   => :get
    )
    assert_equal @mars_response.body, remote_method.run(:identifier => :mars).body
    assert_equal @moon_response.body, remote_method.run(:identifier => :moon).body
  end

  def test_remote_method_with_empty_path
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.test/planets/mars",
      :method   => :get
    )
    assert_equal @mars_response.body, remote_method.run(:identifier => :mars).body
  end

  def test_remote_method_with_success_handler
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomical.test",
      :path       => "/planets/:identifier",
      :on_success => lambda { |response| JSON.parse(response.body) },
      :method     => :get
    )
    response = remote_method.run(:identifier => :mars)
    assert_equal '3.9335 g/cm3', response['mars']['density']
    assert_equal '210K', response['mars']['temperature']
  end

  def test_remote_method_with_failure_handler
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomical.test",
      :path       => "/planets/:identifier",
      :on_failure => lambda { |response| JSON.parse(response.body) },
      :method     => :get
    )
    response = remote_method.run(:identifier => :eris)
    assert_equal "is no planet but a TNO", response['eris']
  end

  def test_remote_method_put
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomical.test",
      :path       => "/planets",
      :method     => :put
    )
    response = remote_method.run(:body => '{"planet":"naboo"}')
    assert_equal "Creating planets is not your business!", response.body
  end

  def test_remote_method_returns_request
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri       => "http://astronomical.test",
      :path           => "/planets",
      :return_request => true
    )
    assert_instance_of Typhoeus::Request, remote_method.run
  end
end

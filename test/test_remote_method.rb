require 'test_helper'

class TestDefineRemoteMethod < Test::Unit::TestCase
  def setup
    hydra           = Typhoeus::Hydra.hydra
    @index_response = Typhoeus::Response.new(:code => 200, :body => '{ "planets" : ["mars", "earth", "venus"] }', :time => 0.3)
    @show_response  = Typhoeus::Response.new(:code => 200, :body => '{ "mars" : { "density" : "3.9335 g/cm3" , "temperature" : "210K" } }', :time => 0.3)
    @error_response = Typhoeus::Response.new(:code => 404, :body => '{ "eris" : "is no planet but a TNO" }', :time => 0.3)
    @put_response   = Typhoeus::Response.new(:code => 403, :body => 'Creating planets is not your business!', :time => 0.3)
    hydra.stub(:get, "http://astronomical.joe/planets").and_return(@index_response)
    hydra.stub(:get, "http://astronomical.joe/planets/mars").and_return(@show_response)
    hydra.stub(:get, "http://astronomical.joe/planets/eris").and_return(@error_response)
    hydra.stub(:put, "http://astronomical.joe/planets").and_return(@put_response)
  end

  def test_path_interpolation
    remote_method = Orthrus::RemoteMethod.new :path => "/some/:id/with/:child"
    args = { :id => 4, :child => 2, :another => 3 }
    interpolated  = remote_method.interpolated_path(args)
    assert_equal "/some/4/with/2", interpolated
    assert_equal({ :another => 3 }, args)
  end

  def test_simple_remote_method_get
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.joe",
      :path     => "/planets",
      :method   => :get
    )
    assert_equal @index_response.body, remote_method.run.body
  end

  def test_simple_remote_method_with_get_as_default
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.joe",
      :path     => "/planets"
    )
    assert_equal @index_response.body, remote_method.run.body
  end

  def test_remote_method_with_interpolation
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.joe",
      :path     => "/planets/:identifier",
      :method   => :get
    )
    assert_equal @show_response.body, remote_method.run(:identifier => :mars).body
  end

  def test_remote_method_with_success_handler
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomical.joe",
      :path     => "/planets/:identifier",
      :on_success => lambda { |response| JSON.parse(response.body) },
      :method   => :get
    )
    response = remote_method.run(:identifier => :mars)
    assert_equal '3.9335 g/cm3', response['mars']['density']
    assert_equal '210K', response['mars']['temperature']
  end

  def test_remote_method_with_failure_handler
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomical.joe",
      :path       => "/planets/:identifier",
      :on_failure => lambda { |response| JSON.parse(response.body) },
      :method     => :get
    )
    response = remote_method.run(:identifier => :eris)
    assert_equal "is no planet but a TNO", response['eris']
  end

  def test_remote_method_put
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomical.joe",
      :path       => "/planets",
      :method     => :put
    )
    response = remote_method.run(:body => '{ :planet => :naboo }')
    assert_equal "Creating planets is not your business!", response.body
  end
end
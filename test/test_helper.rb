require 'test/unit'
require 'rubygems'
require 'typhoeus'
require 'orthrus'
require 'json'

class Test::Unit::TestCase
  class Astronomy
    include Orthrus
    remote_defaults :headers  => { :authentication => "Basic authentication" },
                    :base_uri => "http://astronomical.test",
                    :params   => { :format => "json" }

    define_remote_method :find,
                         :path   => "/planets/:identifier",
                         :params => { :include_details => true }
  end

  class Biology < Astronomy
    remote_defaults :base_uri => "http://biological.test",
                    :params   => { :boring => false }
  end

  def setup
    hydra           = Typhoeus::Hydra.hydra
    @index_response = Typhoeus::Response.new(:code => 200, :body => '{ "planets" : ["mars", "earth", "venus"] }', :time => 0.3)
    @mars_response  = Typhoeus::Response.new(:code => 200, :body => '{ "mars" : { "density" : "3.9335 g/cm3" , "temperature" : "210K" } }', :time => 0.3)
    @error_response = Typhoeus::Response.new(:code => 404, :body => '{ "eris" : "is no planet but a TNO" }', :time => 0.3)
    @put_response   = Typhoeus::Response.new(:code => 403, :body => 'Creating planets is not your business!', :time => 0.3)
    hydra.stub(:get, "http://astronomical.test/planets").and_return(@index_response)
    hydra.stub(:get, "http://astronomical.test/planets/mars").and_return(@mars_response)
    hydra.stub(:get, "http://astronomical.test/planets/eris").and_return(@error_response)
    hydra.stub(:put, "http://astronomical.test/planets").and_return(@put_response)
  end
end
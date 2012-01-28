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

  class ApiClient
    include Orthrus

    remote_defaults :return_request => true

    define_remote_method :hello, :path => '/hello/world'

    def self.lazy_remote_defaults
      { :base_uri => ExternalConfiguration.host }
    end
  end

  class Second < ApiClient

  end

  class Lazy
    include Orthrus

    foobar do
      { :foo => 'bar', :config => ExternalConfiguration.host }
    end
  end

  class Bla
    include Orthrus

    def self.quark(&block)
      block.call self
    end

    def self.method_missing(m, *args, &block)
      puts m
      puts args
    end

    quark do |q|
      q.a = 'a'
      q.b = 'b'
    end
  end

  class ExternalConfiguration
    def self.host
      "http://rumble.com"
    end
  end


  def setup
    hydra           = Typhoeus::Hydra.hydra
    @index_response = Typhoeus::Response.new(:code => 200, :body => '{ "planets" : ["mars", "earth", "venus"] }', :time => 0.3)
    @mars_response  = Typhoeus::Response.new(:code => 200, :body => '{ "mars" : { "density" : "3.9335 g/cm3" , "temperature" : "210K" } }', :time => 0.3)
    @moon_response  = Typhoeus::Response.new(:code => 200, :body => '{ "moon" : { "density" : "3.346 g/cm3", "temperature" : "57K" } }', :time => 0.3)
    @error_response = Typhoeus::Response.new(:code => 404, :body => '{ "eris" : "is no planet but a TNO" }', :time => 0.3)
    @put_response   = Typhoeus::Response.new(:code => 403, :body => 'Creating planets is not your business!', :time => 0.3)
    hydra.stub(:get, "http://astronomical.test/planets").and_return(@index_response)
    hydra.stub(:get, "http://astronomical.test/planets/mars").and_return(@mars_response)
    hydra.stub(:get, "http://astronomical.test/planets/moon").and_return(@moon_response)
    hydra.stub(:get, "http://astronomical.test/planets/eris").and_return(@error_response)
    hydra.stub(:put, "http://astronomical.test/planets").and_return(@put_response)
  end
end

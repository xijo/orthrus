require 'spec_helper'

describe Orthrus::RemoteMethod do

  it "should set up remote options on initialize" do
    method = Orthrus::RemoteMethod.new(:path => '/foo', :base_uri => 'http://foo.com')
    method.remote_options.should be_kind_of Orthrus::RemoteOptions
  end

  it "should interpolate the path" do
    method = Orthrus::RemoteMethod.new
    args = { :id => 4, :child => 2, :another => 3 }
    interpolated = method.interpolate('/some/:id/with/:child', args)
    interpolated.should == "/some/4/with/2"
    args.should == { :another => 3 }
  end

  it "should perform simple get requests" do
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomy.test",
      :path     => "/planets",
      :method   => :get
    )
    remote_method.run.body.should == @index_response.body
  end

  it "should use http method get as default" do
    remote_method = Orthrus::RemoteMethod.new(:base_uri => "http://astronomy.test", :path => '/planets')
    remote_method.run.body.should == @index_response.body
  end

  it "should perform requests on correct interpolated urls" do
    remote_method = Orthrus::RemoteMethod.new(:base_uri => "http://astronomy.test", :path => "/planets/:identifier")
    remote_method.run(:identifier => :mars).body.should == @mars_response.body
    remote_method.run(:identifier => :moon).body.should == @moon_response.body
  end

  it "should work without specified path" do
    remote_method = Orthrus::RemoteMethod.new(:base_uri => "http://astronomy.test/planets/mars")
    remote_method.run.body.should == @mars_response.body
    remote_method.run(:identifier => :mars).body.should == @mars_response.body
  end

  it "should call success handler on requests success" do
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomy.test/planets/mars",
      :on_success => lambda { |response| JSON.parse(response.body) }
    )
    response = remote_method.run
    response['mars']['density'].should == '3.9335 g/cm3'
    response['mars']['temperature'].should == '210K'
  end

  it "should call failure handler on failing requests" do
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri   => "http://astronomy.test/planets/eris",
      :on_failure => lambda { |response| JSON.parse(response.body) }
    )
    response = remote_method.run
    response['eris'].should == "is no planet but a TNO"
  end

  it "should be able to take the right http method" do
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri => "http://astronomy.test",
      :path     => "/planets",
      :method   => :put
    )
    response = remote_method.run(:body => '{"planet":"naboo"}')
    response.body.should == "Creating planets is not your business!"
  end

  it "should return the request instead of the handled response if wanted" do
    remote_method = Orthrus::RemoteMethod.new(
      :base_uri       => "http://astronomy.test",
      :path           => "/planets",
      :return_request => true
    )
    remote_method.run.should be_kind_of Typhoeus::Request
  end

end
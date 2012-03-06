require 'spec_helper'

class OldApi
  include Orthrus
  remote_defaults :base_uri => 'http://should.work.com', :version => 3
  define_remote_method :search, :path => "/:version/search.json"
end

describe OldApi do
  it "should have correct remote default options" do
    options = OldApi.remote_options.build
    options[:base_uri].should == 'http://should.work.com'
    options[:version].should == 3
  end

  it "shoud have a remote method 'search'" do
    OldApi.remote_methods[:search].should be_kind_of(Orthrus::RemoteMethod)
  end
end
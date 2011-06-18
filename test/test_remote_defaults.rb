require 'test_helper'

class TestRemoteDefaults < Test::Unit::TestCase
  class A
    include Orthrus
    remote_defaults :headers => { :authentication => "Basic someting" },
                    :base_uri => "http://fancydomain.com",
                    :params => { :format => "json" }
  end

  class B < A
    remote_defaults :base_uri => "http://superfancy.com"
  end

  def test_setting_remote_defaults
    assert_not_nil defaults = A.instance_variable_get(:@remote_options)
    assert_equal "http://fancydomain.com", defaults[:base_uri]
    assert_equal "Basic someting", defaults[:headers][:authentication]
    assert_equal({:format => "json"}, defaults[:params])
  end

  def test_overwritting_remote_defaults_in_subclass
    assert_not_nil defaults = B.instance_variable_get(:@remote_options)
    assert_equal "http://superfancy.com", defaults[:base_uri]
    assert_equal "Basic someting", defaults[:headers][:authentication]
    assert_equal({:format => "json"}, defaults[:params])
  end
end
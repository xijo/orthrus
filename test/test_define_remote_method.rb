require 'test_helper'

class TestDefineRemoteMethod < Test::Unit::TestCase
  class A
    include Orthrus
    define_remote_method :method_on_a,
                         :path => 'entities',
                         :base_uri => "http://fancydomain.com"
  end

  class B
    include Orthrus
    remote_defaults :base_uri => "http://superfancy.com"
    define_remote_method :method_on_b, :path => "entities/index"
  end

  def test_define_remote_method_without_defaults
    assert A.respond_to? :method_on_a
  end

  def test_define_remote_method_with_remote_defaults
    assert B.respond_to? :method_on_b
  end
end
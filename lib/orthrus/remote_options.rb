require 'ostruct'

module Orthrus
  # The RemoteOptions class extends a hash by implementing a
  # deep merge functionality and holding a options stack, which
  # is used to build the options in the given order
  class RemoteOptions < Hash

    attr_accessor :stack, :built

    def build
      built and return self
      while !stack.empty? do
        case element = stack.shift
          when Proc then smart_merge!(proc_to_hash(element))
          when Hash then smart_merge!(element)
        end
      end
      self.built = true
      self
    end

    #
    def proc_to_hash(element)
      struct = OpenStruct.new
      element.call struct
      struct.instance_variable_get :@table
    end

    # @param [Hash] options to be set as remote options
    def initialize(options = {})
      @stack = []
      @built = false
      @stack << options unless options.empty?
    end

    # Merge the given hash and its subhashes.
    # @param [Hash] other_hash to merge against
    # @return [nil, RemoteOptions] the merged options
    def smart_merge(hash)
      return self if hash.nil?
      merge(hash) do |key, o, n|
        o.is_a?(Hash) && n.is_a?(Hash) ? o.merge(n) : n
      end
    end

    # Perform smart merge and replace the current content
    # @params (@see #deep_merge)
    def smart_merge!(other_hash)
      replace(smart_merge(other_hash))
    end
  end
end

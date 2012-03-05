require 'ostruct'

module Orthrus
  # The RemoteOptions class extends a hash by implementing a
  # deep merge functionality and holding a options stack, which
  # is used to build the options in the given order
  class RemoteOptions

    attr_accessor :stack

    def result
      @result ||= {}
    end

    # @param [Hash] options to be set as remote options
    def initialize(options = {})
      @stack = []
      push(options) unless options.empty?
    end

    def push(option)
      result = {}
      stack.push option
    end

    def clone
      copy = super
      copy.stack = stack.map(&:clone)
      copy
    end

    def build
      !result.empty? and return result
      stack.each do |element|
        smart_merge! case element
          when Proc then proc_to_hash(element)
          when Hash then element
        end
      end
      result
    end

    # Convert options proc into hash by using a struct
    def proc_to_hash(element)
      struct = OpenStruct.new
      element.call struct
      struct.instance_variable_get :@table
    end

    # Merge the given hash and its subhashes.
    # @param [Hash] other_hash to merge against
    # @return [nil, RemoteOptions] the merged options
    def smart_merge(hash)
      return result if hash.nil?
      result.merge(hash) do |key, o, n|
        o.is_a?(Hash) && n.is_a?(Hash) ? o.merge(n) : n
      end
    end

    # Perform smart merge and replace the current content
    # @params (@see #deep_merge)
    def smart_merge!(hash)
      @result = smart_merge(hash)
    end

    def to_s
      "#{super}: #{stack.size} stack entries"
    end
  end
end

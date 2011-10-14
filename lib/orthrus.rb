require 'orthrus/remote_method'
require 'orthrus/remote_options'
require 'orthrus/logger'

module Orthrus
  # Include Orthrus functionality in the given class
  # @param base class to include
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Getter for remote options
    # @return [RemoteOptions] the remote options for this class
    def remote_options
      @remote_options ||= RemoteOptions.new
    end

    # Define default settings for the remote connection.
    # @attribute remote_defaults
    # @param [Hash] options to be set as default
    # @return [Hash] the current remote default settings
    def remote_defaults(options)
      remote_options.smart_merge!(options)
    end

    # If we get subclassed, make sure that child inherits the remote defaults
    # of the parent class.
    def inherited(child)
      child.__send__(:remote_defaults, remote_options)
    end

    # Declare a remote method and create a class method as wrapper
    # @param [Symbol] name of the remote method
    # @param [Hash] options for the remote method
    def define_remote_method(name, options = {})
      @remote_methods ||= {}
      @remote_methods[name] = RemoteMethod.new(remote_options.smart_merge(options))

      class_eval <<-SRC
        def self.#{name.to_s}(args = {})
          call_remote_method(:#{name.to_s}, args)
        end
      SRC
    end

    # Find the specified remote method and pass the arguments
    # @param [Symbol] method_name to identify the remote method
    # @param [Hash] args to pass through
    def call_remote_method(method_name, args)
      remote_method = @remote_methods[method_name]
      remote_method.run(args)
    end
  end
end
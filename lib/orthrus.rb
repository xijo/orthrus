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

    # If we get subclassed, make sure that child inherits the remote defaults
    # of the parent class.
    def inherited(child)
      puts remote_options.inspect
      puts remote_options.stack.inspect
      puts remote_options.dup.stack.inspect
      child.instance_variable_set :@remote_options, @remote_options.dup
    end

    # Declare a remote method and create a class method as wrapper
    # @param [Symbol] name of the remote method
    # @param [Hash] options for the remote method
    def define_remote_method(name, options = {}, &block)
      method_options = remote_options.dup
      method_options.stack << options unless options.empty?
      method_options.stack << block if block_given?

      @remote_methods ||= {}
      @remote_methods[name] = RemoteMethod.new(method_options)

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

    # Define default settings for the remote connection.
    # @attribute remote_defaults
    # @param [Hash] options to be set as default
    # @return [Hash] the current remote default settings
    def remote_method_defaults(args = {}, &block)
      remote_options.stack << args unless args.empty?
      remote_options.stack << block if block_given?
      remote_options
    end
    # Alias this for backwards compatibility
    # alias remote_method_defaults remote_options
  end
end
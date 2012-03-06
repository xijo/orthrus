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

    def remote_methods
      @remote_methods ||= {}
    end

    # If we get subclassed, make sure that child inherits the remote defaults
    # of the parent class.
    def inherited(child)
      child.instance_variable_set :@remote_options, remote_options.clone
    end

    # Declare a remote method and create a class method as wrapper
    # @param [Symbol] name of the remote method
    # @param [Hash] options for the remote method
    def define_remote_method(name, options = {}, &block)
      method_options = remote_options.clone
      method_options.stack << options unless options.empty?
      method_options.stack << block if block_given?

      remote_methods[name] = RemoteMethod.new(method_options)
    end

    def method_missing(method_name, *args)
      if remote_method = remote_methods[method_name]
        remote_method.run(args.first || {})
      else
        super
      end
    end

    def respond_to?(method_name)
      super || !remote_methods[method_name.to_sym].nil?
    end

    # Find the specified remote method and pass the arguments
    # @param [Symbol] method_name to identify the remote method
    # @param [Hash] args to pass through
    def call_remote_method(method_name, args = {})
      remote_methods[method_name].run(args)
    end

    # Define default settings for the remote connection.
    # @attribute remote_defaults
    # @param [Hash] options to be set as default
    # @return [Hash] the current remote default settings
    def remote_method_defaults(args = {}, &block)
      remote_options.push args unless args.empty?
      remote_options.push block if block_given?
      remote_options
    end
    # Alias this for backwards compatibility
    alias_method :remote_defaults, :remote_method_defaults
  end
end
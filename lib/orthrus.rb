$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'orthrus/remote_method'

module Orthrus
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Define default settings for the remote connection.
    # Typically: base_uri, headers with authentication etc
    def remote_defaults(options)
      @remote_defaults ||= {}
      @remote_defaults.merge!(options) if options
      @remote_defaults
    end

    # If we get subclassed, make sure that child inherits the remote defaults
    # of the parent class.
    def inherited(child)
      child.__send__(:remote_defaults, @remote_defaults)
    end

    def define_remote_method(name, args = {})
      remote_options = (@remote_defaults || {}).merge(args)
      @remote_methods ||= {}
      @remote_methods[name] = RemoteMethod.new(remote_options)

      class_eval <<-SRC
        def self.#{name.to_s}(args = {})
          call_remote_method(:#{name.to_s}, args)
        end
      SRC
    end


    # def remote_proxy_object(url, method, options)
    #   easy = Typhoeus.get_easy_object
    #
    #   easy.url                   = url
    #   easy.method                = method
    #   easy.headers               = options[:headers] if options.has_key?(:headers)
    #   easy.headers["User-Agent"] = (options[:user_agent] || Typhoeus::USER_AGENT)
    #   easy.params                = options[:params] if options[:params]
    #   easy.request_body          = options[:body] if options[:body]
    #   easy.timeout               = options[:timeout] if options[:timeout]
    #   easy.set_headers
    #
    #   proxy = Typhoeus::RemoteProxyObject.new(clear_memoized_proxy_objects, easy, options)
    #   set_memoized_proxy_object(method, url, options, proxy)
    # end

    # def call_remote_method(method_name, args)
    #   m = @remote_methods[method_name]
    #
    #   base_uri = args.delete(:base_uri) || m.base_uri || ""
    #
    #   if args.has_key? :path
    #     path = args.delete(:path)
    #   else
    #     path = m.interpolate_path_with_arguments(args)
    #   end
    #   path ||= ""
    #
    #   http_method = m.http_method
    #   url         = base_uri + path
    #   options     = m.merge_options(args)
    #
    #   # proxy_object = memoized_proxy_object(http_method, url, options)
    #   # return proxy_object unless proxy_object.nil?
    #   #
    #   # if m.cache_responses?
    #   #   object = @cache.get(get_memcache_response_key(method_name, args))
    #   #   if object
    #   #     set_memoized_proxy_object(http_method, url, options, object)
    #   #     return object
    #   #   end
    #   # end
    #
    #   proxy = memoized_proxy_object(http_method, url, options)
    #   unless proxy
    #     if m.cache_responses?
    #       options[:cache] = @cache
    #       options[:cache_key] = get_memcache_response_key(method_name, args)
    #       options[:cache_timeout] = m.cache_ttl
    #     end
    #     proxy = send(http_method, url, options)
    #   end
    #   proxy
    # end
    #
  end
end
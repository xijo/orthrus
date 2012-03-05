module Orthrus
  class RemoteMethod
    attr_accessor :remote_options, :on_success, :on_failure

    # Extract request options to class variables. All other options
    # will be passed through to Typhoeus.
    # @param [Hash] options for the request
    def initialize(args = {})
      self.remote_options = args.kind_of?(RemoteOptions) ? args : RemoteOptions.new(args)
    end

    def prepare_options(args)
      remote_options.push(args)
      options = remote_options.clone.build
      options[:method] ||= :get
      self.on_success = options[:on_success] || lambda { |response| response }
      self.on_failure = options[:on_failure] || lambda { |response| response }
      @debug = options.delete(:debug)
      options
    end

    def prepare_url(options)
      base_uri = options.delete(:base_uri)
      path     = options.delete(:path) || ""
      interpolate(base_uri + path, options)
    end

    # Interpolate parts of the given url which are marked by colon
    # @param [String] url to be interpolated
    # @param [Hash] args to perform interpolation
    # @return [String] the interpolated url
    # @example Interpolate a url
    #   interpolate("http://example.com/planet/:identifier", {:identifier => "mars"}) #=> "http://example.com/planet/mars"
    def interpolate(url, args = {})
      result = url.dup
      args.each do |key, value|
        if result.include?(":#{key}")
          result.sub!(":#{key}", value.to_s)
          args.delete(key)
        end
      end
      Orthrus::Logger.debug("interpolation result is #{result}") if @debug
      result
    end

    # Perform the request, handle response and return the result
    # @param [Hash] args for interpolation and request options
    # @return [Response, Object] the Typhoeus::Response or the result of the on_complete block
    def run(args = {})
      request_options = prepare_options(args)
      url             = prepare_url(request_options)
      request         = Typhoeus::Request.new(url, request_options)
      Orthrus::Logger.debug("request to #{url}\n  with options #{request_options.inspect}") if @debug
      handle_response(request)
      if request_options[:return_request]
        request
      else
        Typhoeus::Hydra.hydra.queue request
        Typhoeus::Hydra.hydra.run
        request.handled_response
      end
    end

    # Call success and failure handler on request complete
    # @param [Typhoeus::Request] request that needs success or failure handling
    def handle_response(request)
      request.on_complete do |response|
        if response.success?
          on_success.call(response)
        else
          on_failure.call(response)
        end
      end
    end
  end
end

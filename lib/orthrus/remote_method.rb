module Orthrus
  class RemoteMethod
    attr_accessor :options, :base_uri, :path, :on_success, :on_failure

    # Extract request options to class variables. All other options
    # will be passed through to Typhoeus.
    # @param [Hash] options for the request
    def initialize(options = {})
      options[:method] ||= :get
      @options     = options
      @base_uri    = options.delete(:base_uri)
      @path        = options.delete(:path)
      @on_success  = options[:on_success] || lambda { |response| response }
      @on_failure  = options[:on_failure] || lambda { |response| response }
    end

    # Perform the request, handle response and return the result
    # @param [Hash] args for interpolation and request options
    # @return [Response, Object] the Typhoeus::Response or the result of the on_complete block
    def run(args = {})
      url     = base_uri + interpolated_path(args)
      request = Typhoeus::Request.new(url, @options.merge(args))
      handle_response(request)
      Typhoeus::Hydra.hydra.queue request
      Typhoeus::Hydra.hydra.run
      request.handled_response
    end

    # Interpolate parts of the path marked through color
    # @param [Hash] args to perform interpolation
    # @return [String] the interpolated path
    # @example Interpolate a path
    #   path = "/planet/:identifier"
    #   interpolated_path({:identifier => "mars"}) #=> "/planet/mars"
    def interpolated_path(args = {})
      interpolated_path = @path
      args.each do |key, value|
        if interpolated_path.include?(":#{key}")
          interpolated_path.sub!(":#{key}", value.to_s)
          args.delete(key)
        end
      end
      interpolated_path
    end

    # Call success and failure handler on request complete
    # @param [Typhoeus::Request] request that needs success or failure handling
    def handle_response(request)
      request.on_complete do |response|
        if response.success?
          @on_success.call(response)
        else
          @on_failure.call(response)
        end
      end
    end
  end
end

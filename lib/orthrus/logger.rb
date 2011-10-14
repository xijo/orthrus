module Orthrus
  module Logger
    # Initialize logger wether for rails or standalone
    @logger = if defined?(Rails)
      Rails.logger
    else
      require 'logger'
      ::Logger.new(STDOUT)
    end

    # Display warn message in log
    # @param [String] message
    def self.warn(message)
      @logger.warn("orthrus: #{message}")
    end

    # @param [String] message
    def self.debug(message)
      @logger.debug("orthrus: #{message}")
    end
  end
end

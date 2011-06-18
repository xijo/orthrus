module Orthrus
  class RemoteOptions < Hash
    # @param [Hash] options to be set as remote options
    def initialize(options = {})
      replace(options)
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

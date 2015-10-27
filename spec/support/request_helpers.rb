module Requests
  # Helpers for working with JSON responses
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body)
      if @json_response.respond_to?(:deep_symbolize_keys)
        @json_response.deep_symbolize_keys!
      elsif @json_response.is_a?(Array)
        @json_response = @json_response.map(&:deep_symbolize_keys)
      end
      @json_response
    end
  end
end

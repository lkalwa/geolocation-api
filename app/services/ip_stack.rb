# frozen_string_literal: true

module IpStack
  include HTTParty
  FIELDS = %w[ip country_name city latitude longitude].freeze

  class << self
    def get_location(ip_or_url)
      begin
        response = get("https://api.ipstack.com/#{ip_or_url}?access_key=#{api_key}&fields=#{FIELDS.join(",")}")
        if response.success?
          response.parsed_response.with_indifferent_access
        else
          raise Errors::IpStackError.new(response["error"]["info"])
        end

      rescue HTTParty::Error, SocketError => e
        raise Errors::NetworkError.new(e)
      end
    end

    def api_key
      Rails.application.config.ip_stack_api_key.tap do |key|
        raise Errors::IpStackError.new("IP_STACK_API_KEY variable is not set") if key.blank?
      end
    end
  end
end

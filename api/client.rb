# frozen_string_literal: true

require 'faraday'

module Api
  class Client
    BASE_URL = 'https://open.er-api.com/v6'

    def initialize
      @client = faraday_client
    end

    attr_reader :client

    def get!(path)
      request do
        client.get do |req|
          req.url(path)
        end
      end
    end

    def request
      begin
        response = yield
      rescue Faraday::Error
        Exception.new(message: 'Client error')
      end

      raise StandardError, "Server error with status: #{response.status}" unless response.success?

      response.body
    end

    def faraday_client
      Faraday.new(url: BASE_URL) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
        faraday.adapter(Faraday.default_adapter)
      end
    end

    def headers
      { content_type: 'application/json' }
    end
  end
end

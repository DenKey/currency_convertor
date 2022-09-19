# frozen_string_literal: true

require './api/client'

module Api
  class Service
    def initialize
      @client = Api::Client.new
    end

    attr_accessor :client, :logger

    def currency_rate(currency)
      client.get!("latest/#{currency}")
    end
  end
end

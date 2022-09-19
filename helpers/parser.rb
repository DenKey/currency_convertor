# frozen_string_literal: true

require './api/service'

module Helpers
  class Parser
    attr_reader :list, :from_currency, :amount, :to_currency, :service
    attr_accessor :errors

    def initialize(from_currency, amount, to_currency)
      @service = Api::Service.new
      @list = service.currency_rate('usd')
      @from_currency = from_currency.upcase.to_sym
      @amount = amount
      @to_currency = to_currency.upcase.to_sym
      @errors = []

      validation!
    end

    def currencies_list
      list[:rates]&.keys
    end

    def valid_currency?(currency)
      errors << "'#{currency}' is not a valid currency" unless currencies_list.include?(currency)
    end

    def amount_is_a_number?(amount)
      number = amount.to_f

      errors << "'#{amount}' is not a valid number" if !number.is_a?(Numeric) || number.zero?
    end

    def validation!
      valid_currency?(from_currency)
      valid_currency?(to_currency)
      amount_is_a_number?(amount)

      return if errors.empty?

      message = errors.join('. ')
      raise "Errors: #{message}"
    end

    def result
      data = service.currency_rate(from_currency)
      rate = data[:rates][to_currency]
      converted_amount = amount.to_f * rate

      [[from_currency, amount.to_f, to_currency, converted_amount]]
    end
  end
end

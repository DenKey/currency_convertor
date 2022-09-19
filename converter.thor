# frozen_string_literal: true

require 'date'
require 'terminal-table'
require_relative 'api/service'
require_relative 'helpers/parser'

class Converter < Thor
  desc 'parse from_currency, amount, to_currency', 'convert different currencies'
  method_option :silent, type: :boolean, aliases: '-s'

  TABLE_HEADINGS = ['From Currency', 'Amount', 'To Currency', 'Result'].freeze

  def parse(from_currency, amount, to_currency)
    parser = Helpers::Parser.new(from_currency, amount, to_currency)

    if options[:silent]
      puts parser.converted_amount
    else
      puts 'Converting started...'

      puts Terminal::Table.new title: 'Currency converter',
                               headings: TABLE_HEADINGS,
                               rows: parser.rows_formatted_result

      puts 'Converting was finished successfully'
    end
  rescue StandardError => e
    puts 'Something went wrong...'
    puts e.message
  end

  def self.exit_on_failure?
    puts 'Execution is not possible, please enter all required arguments.'
    true
  end
end

# thor converter:parse USD, 12, EUR

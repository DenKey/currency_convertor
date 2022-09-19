require 'rspec'
require './helpers/parser'
require './api/service'

describe Helpers::Parser do
  before do
    allow_any_instance_of( Api::Service)
      .to receive(:currency_rate)
            .and_return({rates: {:USD => 1.0, :HKD => 7.854821}})
  end

  it "returns the valid converted_amount" do
    expect(Helpers::Parser.new('USD', 1000, 'HKD').converted_amount).to eq(7854.821)
  end

  it 'raises errors when amount param is not a number' do
    expect { Helpers::Parser.new('USD', 'BAD', 'HKD').converted_amount }.to raise_error("Errors: 'BAD' is not a valid number")
  end

  it 'raises errors when currency param is unknown' do
    expect { Helpers::Parser.new('USD', 1000, 'BEB').converted_amount }.to raise_error("Errors: 'BEB' is not a valid currency")
  end
end
require 'rspec'
require_relative '../../app/services/calculator.rb'

RSpec.describe CalculatorService do
  describe '#average' do
    let(:calculator) { CalculatorService.new }

    it 'returns the average of an array of numbers' do
      expect(calculator.average([1, 2, 3])).to eq(2.0)
    end

    it 'returns nil for an empty array' do
      expect(calculator.average([])).to be_nil
    end

    it 'handles input that is not an array of numbers' do
      expect { calculator.average([1, 'two', 3]) }.to raise_error(ArgumentError)
    end

    it 'handles arrays with float numbers' do
      expect(calculator.average([1.5, 2.5, 3.0])).to eq(2.3333333333333335)
    end

    it 'handles input witch is not array' do
      expect { calculator.average(123) }.to raise_error(ArgumentError)
    end

    it 'returns the correct type for average' do
      expect(calculator.average([100, 200, 300])).to be_a(Float)
    end
  end
end

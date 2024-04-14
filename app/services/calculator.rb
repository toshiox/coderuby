class CalculatorService
  def average(numbers)
    raise ArgumentError, 'Input must be an array of numbers' unless numbers.is_a?(Array) && numbers.all? { |n| n.is_a?(Numeric) }

    return nil if numbers.empty?

    numbers.sum.to_f / numbers.length
  end
end

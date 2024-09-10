require_relative './calculator'
require_relative './article_format'

class UnitUtils
  attr_reader :articleFormat, :calculator

  def initialize(article_format, calculator)
    @articleFormat = article_format
    @calculator = calculator
  end
end
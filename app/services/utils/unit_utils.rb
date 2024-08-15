require_relative './calculator'
require_relative './translator'
require_relative './article_format'

class UnitUtils
  def initialize(article_format, calculator, translator)
    @calculator = calculator
    @translator = translator
    @articleFormat = article_format
  end
end
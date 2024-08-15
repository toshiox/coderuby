require './services/utils/calculator'
require './services/utils/translator'
require './services/utils/article_format'

require './services/utils/unit_utils'

calculator = Calculator.new
translator = Translator.new
article_format = ArticleFormat.new

UNIT_UTILS = UnitUtils.new(calculator, translator, article_format)
require './services/utils/calculator'
require './services/utils/article_format'

require './services/utils/unit_utils'

calculator = Calculator.new
article_format = ArticleFormat.new

UNIT_UTILS = UnitUtils.new(article_format, calculator)
require './repositories/article_repository'
require './repositories/articleViews_repository'

require './models/db/Article'
require './models/db/ArticleViews'

require './repositories/unit_repository'

article_repository = ArticleRepository.new(Article)
article_views_repository = ArticleRepository.new(ArticleViews)

UNIT_REPOSITORY = UnitRepository.new(article_repository, article_views_repository)
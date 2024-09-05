require './repositories/article_repository'
require './repositories/articleViews_repository'

require './models/db/Article'
require './models/db/ArticleViews'
require './models/db/ArticleContent'

require './repositories/unit_repository'

article_repository = ArticleRepository.new(Article)
article_views_repository = ArticleViewsRepository.new(ArticleViews)
article_content_repository = ArticleContentRepository.new(ArticleContent)

UNIT_REPOSITORY = UnitRepository.new(
  article_repository, 
  article_views_repository, 
  article_content_repository
)
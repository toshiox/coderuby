require_relative './article_repository'
require_relative './articleViews_repository'
# require_relative './articleContent_repository'

class UnitRepository 
  def initialize(article_repository, article_views_repository)
    @article = article_repository
    @articleViews = article_views_repository
    # @articleContent = article_content_repository
  end
end
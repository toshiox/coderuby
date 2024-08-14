require_relative './article_repository'
require_relative './articleViews_repository'
# require_relative './articleContent_repository'

require_relative '../models/db/Article'
require_relative '../models/db/ArticleViews'

class UnitRepository 
  attr_accessor :article, :articleViews
  def initialize
    @article = ArticleRepository.new(Article)
    @articleViews = ArticleRepository.new(ArticleViews)
    # @articleContent = ArticleContentRepository.new('articleContent')
  end
end

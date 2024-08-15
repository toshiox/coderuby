require_relative './article_repository'
require_relative './articleViews_repository'
# require_relative './articleContent_repository'

require_relative '../models/db/Article'
require_relative '../models/db/ArticleViews'

class UnitRepository 
<<<<<<< HEAD
  attr_accessor :article, :articleViews
  def initialize
    @article = ArticleRepository.new(Article)
    @articleViews = ArticleViewsRepository.new(ArticleViews)
=======
  attr_accessor :articles, :articleViews, :articleContent
  def initialize
    @articles = ArticleRepository.new(Article)
    @articleViews = ArticleRepository.new(ArticleViews)
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
    # @articleContent = ArticleContentRepository.new('articleContent')
  end
end

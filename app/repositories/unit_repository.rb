require_relative './article_repository'
require_relative './articleViews_repository'
require_relative './articleContent_repository'

class UnitRepository
  attr_reader :article, :articleViews, :articleContent

  def initialize
    @article = ArticleRepository.new('article')
    @articleViews = ArticleRepository.new('articleViews')
    @articleContent = ArticleContentRepository.new('articleContent')
  end
end

require_relative './Base'

class ArticleContent < Base
  self.table_name = 'article_content'

  validates :articleId, presence: true, numericality: { only_integer: true }
  validates :Content, presence: true
  validates :CreatedAt, presence: true
end
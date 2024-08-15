require_relative './Base'

class ArticleContent < Base
  self.primary_key = 'id'

  validates :articleId, presence: true, numericality: { only_integer: true }
  validates :Content, presence: true
  validates :CreatedAt, presence: true
end
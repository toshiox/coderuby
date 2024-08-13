require_relative './Base'

class ArticleViews < Base
  self.primary_key = 'id'

  validates :articleId, presence: true
  validates :ipAddress, presence: true
  validates :view_date, presence: true
end
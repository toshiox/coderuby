require_relative './Base'

class ArticleViews < Base
  self.table_name = 'article_views'

  validates :articleId, presence: true
  validates :ipAddress, presence: true
  validates :view_date, presence: true
end
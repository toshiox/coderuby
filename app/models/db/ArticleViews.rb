require_relative './Base'

class ArticleViews < Base
  self.table_name = 'article_views'

  validates :article_id, presence: true
  validates :ip_address, presence: true
  validates :view_date, presence: true
end
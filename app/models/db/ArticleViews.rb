require_relative './Base'

class ArticleViews < Base
<<<<<<< HEAD
  self.table_name = 'article_views'

  validates :article_id, presence: true
  validates :ip_address, presence: true
=======
  self.primary_key = 'id'

  validates :articleId, presence: true
  validates :ipAddress, presence: true
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
  validates :view_date, presence: true
end
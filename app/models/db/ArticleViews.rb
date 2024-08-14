require_relative './Base'

class ArticleViews < Base
  self.primary_key = 'Id'

  validates :ArticleId, presence: true
  validates :IpAddress, presence: true
  validates :ViewDate, presence: true
end
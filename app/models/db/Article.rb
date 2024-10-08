require_relative './Base'

class Article < Base
  self.table_name = 'article'

  has_one :article_content, foreign_key: 'article_id'

  validates :title, presence: true
  validates :subtitle, presence: true
  validates :resume, presence: true
  validates :tags, presence: true
  validates :language, presence: true
  validates :time_read, presence: true, numericality: { only_integer: true }
  validates :views, presence: true, numericality: { only_integer: true }
end
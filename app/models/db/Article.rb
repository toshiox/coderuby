require_relative './Base'

class Article < Base
<<<<<<< HEAD
  self.table_name = 'article'
=======
  self.primary_key = 'id'
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae

  validates :title, presence: true
  validates :subtitle, presence: true
  validates :resume, presence: true
  validates :tags, presence: true
  validates :language, presence: true
  validates :time_read, presence: true, numericality: { only_integer: true }
  validates :views, presence: true, numericality: { only_integer: true }
end
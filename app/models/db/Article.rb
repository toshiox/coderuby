require_relative './Base'

class Article < Base
  self.primary_key = 'Id'

  validates :Title, presence: true
  validates :Subtitle, presence: true
  validates :Resume, presence: true
  validates :Tags, presence: true
  validates :Language, presence: true
  validates :TimeRead, presence: true, numericality: { only_integer: true }
  validates :Views, presence: true, numericality: { only_integer: true }
end
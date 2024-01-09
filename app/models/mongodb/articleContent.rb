class ArticleContent
  include Mongoid::Document
  include Mongoid::Timestamps
  field :articleId, type: String
  field :content, type: String
  field :language, type: String
  field :createdAt, type: DateTime
end

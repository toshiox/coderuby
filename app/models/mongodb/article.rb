class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :subtitle, type: String
  field :resume, type: String
  field :timeRead, type: Integer
  field :tags, type: String
  field :language, type: String
  field :createdAt, type: DateTime
end

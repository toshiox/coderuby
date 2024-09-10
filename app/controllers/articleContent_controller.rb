require './services/articleContent_service'
class ArticleContentController < Sinatra::Base
  def initialize(app = nil, article_Content_service)
    super(app)
    @article_Content_service = article_Content_service
  end

  get '/api/articleContent/:articleId' do |articleId|
    content_type :json
    return @article_Content_service.get_by_id(articleId).to_json
  end

  # post '/api/articleContent/content' do
  #   content_type :json
  #   request.body.rewind
  #   items = articleContent_service.get_by_id(JSON.parse(request.body.read)).to_json
  # end

  # post '/api/articleContent' do
  #   content_type :json
  #   request.body.rewind
  #   items = articleContent_service.add(JSON.parse(request.body.read)).to_json
  # end

  # put '/api/articleContent' do
  #   content_type :json
  #   request.body.rewind
  #   items = articleContent_service.update(JSON.parse(request.body.read)).to_json
  # end
end

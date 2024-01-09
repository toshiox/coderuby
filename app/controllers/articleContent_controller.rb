require './services/articleContent_service'
class ArticleContentController < Sinatra::Base
  articleContent_service = ArticleContentService.new

  post '/api/articleContent/fullArticle' do
    content_type :json
    request.body.rewind
    items = articleContent_service.get_content(JSON.parse(request.body.read))
  end

  post '/api/articleContent/content' do
    content_type :json
    request.body.rewind
    items = articleContent_service.get_by_id(JSON.parse(request.body.read)).to_json
  end

  post '/api/articleContent' do
    content_type :json
    request.body.rewind
    items = articleContent_service.add(JSON.parse(request.body.read)).to_json
  end

  put '/api/articleContent' do
    content_type :json
    request.body.rewind
    items = articleContent_service.update(JSON.parse(request.body.read)).to_json
  end
end

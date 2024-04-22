require './services/articleViews_service'

class ArticleViewsController < Sinatra::Base
  articleViews_service = ArticleViewsService.new

  get '/api/views/count/:articleId' do |articleId|
    content_type :json
    ip_address = request.env['HTTP_X_FORWARDED_FOR'] ? request.env['HTTP_X_FORWARDED_FOR'].split(',').first : request.ip
    articleViews_service.updateViews(ip_address, articleId)
  end
end

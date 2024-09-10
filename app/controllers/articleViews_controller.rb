class ArticleViewsController < Sinatra::Base
  def initialize(app = nil, article_views)
    super(app)
    @article_views = article_views
  end

  get '/api/views/count/:articleId' do |articleId|
    content_type :json
    ip_address = request.env['HTTP_X_FORWARDED_FOR'] ? request.env['HTTP_X_FORWARDED_FOR'].split(',').first : request.ip
    @article_views.update_views(ip_address, articleId).to_json
  end
end

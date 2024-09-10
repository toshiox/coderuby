class ArticleController < Sinatra::Base

    def initialize(app = nil, article_service)
        super(app)
        @article_service = article_service
    end

    get '/api/article/all/:language' do |language|
        content_type :json
        return @article_service.list_all_articles(language).to_json
    end

    get '/api/article/:id' do |id|
        content_type :json
        return @article_service.get_by_id(id)
    end
end

require './services/article_service'

class ArticleController < Sinatra::Base

    def initialize(app = nil, article_service)
        super(app)
        @article_service = article_service
      end

    get '/api/article/:language' do |language|
        content_type :json
        items = @article_service.list_all_articles(language).to_json
    end

    # get '/api/article/:id' do |id|
    #     content_type :json
    #     items = article_service.get_by_id(id).to_json
    # end

    # post '/api/article' do
    #     content_type :json
    #     request.body.rewind
    #     items = article_service.add(JSON.parse(request.body.read)).to_json
    # end

    # put '/api/article' do
    #     content_type :json
    #     request.body.rewind
    #     items = article_service.update(JSON.parse(request.body.read)).to_json
    # end

    # delete '/api/article/:id' do |id|
    #     content_type :json
    #     items = article_service.delete(id).to_json
    # end
end

require './services/redis_service'
require './services/article_service'
class ArticleController < Sinatra::Base
    redis_service =  RedisService.new
    article_service = ArticleService.new

    get '/api/article/:language' do
        language = params['language']
        content_type :json
        items = article_service.ListAll(language).to_json
    end

    get '/api/article/:id' do |id|
        content_type :json
        items = article_service.GetById(id).to_json
    end

    post '/api/article' do
        content_type :json
        request.body.rewind
        items = article_service.Add(JSON.parse(request.body.read)).to_json
    end

    put '/api/article' do content_type :json
        content_type :json
        request.body.rewind
        items = article_service.Update(JSON.parse(request.body.read)).to_json
    end

    delete '/api/article/:id' do |id|
        content_type :json
        items = article_service.Delete(id).to_json
    end


end

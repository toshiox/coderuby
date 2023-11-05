require './services/article_service'

class ArticleController < Sinatra::Base
    article_service = ArticleService.new

    get '/api/article' do
        content_type :json
        items = article_service.ListAll.to_json
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

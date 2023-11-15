require_relative '../services/redis_service'

class RedisController < Sinatra::Base
    redis_service = RedisService.new

    get '/api/redis/:id' do |id|
        content_type :json
        redis_service.get_article(id)
    end

    get '/api/cleanMemory' do
        content_type :json
        redis_service.cleanMemory()
    end

    get '/api/redis/articles/:language' do
        language = params['language']
        content_type :json
        items = redis_service.list_all_articles(language)
    end
end

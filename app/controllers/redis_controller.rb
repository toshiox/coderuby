require_relative '../services/redis_service'

class RedisController < Sinatra::Base
    redis_service = RedisService.new

    get '/api/redis/:id' do |id|
        content_type :json
        redis_service.get_article(id)
    end
end
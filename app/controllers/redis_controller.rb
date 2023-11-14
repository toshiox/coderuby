require_relative '../services/redis_service'

class RedisController < Sinatra::Base
    redis_service = RedisService.new

    get '/api/redis' do
        content_type :json
        redis_service.Set()
        redis_service.Get()
    end
end
require 'redis'
require 'uri'

class RedisService
    def initialize
        uri = URI.parse('rediss://:p8f09dbd5d7720b0bb0706453b3091018d76a3b94632faa448481856bb07253af@ec2-54-146-72-230.compute-1.amazonaws.com:22950')
        @redis = Redis.new(
            url: uri.to_s,
            ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
        )
    end

    def Set
        @redis.set('nome', 'Gustavo')
    end

    def Get
        puts "Nome: #{@redis.get('nome')}"
    end
end
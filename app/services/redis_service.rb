require 'redis'
require 'uri'

class RedisService
    def initialize
        uri = URI.parse('rediss://:p599a832f612169fb4ba2a66b92d58adfd4f895486f34c42651870b6cb63e8243@ec2-54-146-72-230.compute-1.amazonaws.com:7000')
        @redis = Redis.new(
            url: uri.to_s,
            ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
        )
    end

    def set_articles(articles, language)
        JSON.parse(articles).each do |article|
            article_id = "article:#{article['_id']['$oid']}_#{language}"
            if exist_article(article_id) == 0
                @redis.set(article_id, article.to_json)
            end
        end
    end

    def get_article(article_id)
        @redis.get("article:#{article_id}")
    end

    def exist_article(id)
        @redis.exists(id)
    end
end
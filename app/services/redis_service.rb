require 'redis'
require 'uri'

class RedisService
    def initialize
        uri = URI.parse("redis://redis:6379")
        @redis = Redis.new(
            url: uri.to_s,
            ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
        )
    end

    def set_articles(articles, language)
        JSON.parse(articles).each do |article|
            article_id = "article:#{article['id']}_#{language}"
            if exist_article(article_id) == 0
                @redis.set(article_id, article.to_json)
                @redis.sadd?("language:#{article['language']}", article_id)
            end
        end
    end

    def get_article(article_id)
        @redis.get("article:#{article_id}").to_json
    end

    def exist_article(id)
        @redis.exists(id)
    end

    def list_all_articles(language)
        articles = []
        filtered_keys = keys_in_language = @redis.smembers("language:#{language}")
        filtered_keys.each do |key|
            value = @redis.get(key)
            if value
                articles << JSON.parse(value)
            end
        end
        articles.to_json
    end

    def cleanMemory()
        @redis.flushdb
        @redis.flushall
    end
end

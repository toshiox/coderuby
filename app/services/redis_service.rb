require 'redis'
require 'uri'

class RedisService
    def initialize(redis = nil)
        @redis = redis || Redis.new(
          url: URI.parse('redis://redis:6379').to_s,
          ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
        )
    end

    def set_list_articles(articles, language)
        JSON.parse(articles).each do |article|
            article_id = "article:#{article['id']}_#{language}"
            if @redis.exists(article_id) == 0
                @redis.set(article_id, article.to_json)
                @redis.sadd?("language:#{language}", article_id)
            end
        end
        true
    end

    def set_article(article, language)
        article = JSON.parse(article) if article.is_a?(String)
        article_id = "article:#{article['id']}_#{language}"
        if exist_article(article_id) == 0
            @redis.set(article_id, article.to_json)
            @redis.sadd?("language:#{language}", article_id)
        end
    end

    def set_articles_content(article, language)
        article_id = "article_content:#{article[:article_id].to_s}_#{language}"
        if exist_article(article_id) == 0
            @redis.set(article_id, article.to_json)
            @redis.sadd?("language:#{language}", article_id)
        end
    end

    def get_article(article_id)
        @redis.get("article:#{article_id}")
    end

    def get_article_content(article_id)
        @redis.get("article_content:#{article_id}")
    end

    def exist_article(id)
        @redis.exists(id)
    end

    def list_all_articles(language)
        articles = []
        pattern = "article:*_#{language}"
        cursor = "0"
      
        loop do
          cursor, keys = @redis.scan(cursor, match: pattern)
          keys.each do |key|
            value = @redis.get(key)
            articles << JSON.parse(value) if value
          end
          break if cursor == "0"
        end
      
        articles
    end

    def cleanMemory()
        @redis.flushdb
        @redis.flushall
    end
end

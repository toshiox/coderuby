require 'json'
require_relative './redis_service'
require_relative '../models/api/api_response'
require_relative '../repositories/unit_repository'

class ArticleService
    def initialize(redis_service, unit_repository, translator)
        @redis = redis_service
        @translator = translator
        @unit_repository = unit_repository
    end

    def list_all_articles(language)
        all_articles = @redis.list_all_articles(language)
        return all_articles unless all_articles.nil? || all_articles.empty?
      
        articles = @unit_repository.article.to_array
        return nil if articles.nil?
        
        translated_articles = articles.map do |article|
          article.language != language ? @translator.translate_article(article, language) : article
        end
      
        @redis.set_list_articles(translated_articles.to_json, language)
        translated_articles.flatten
    end

    def get_by_id(id_with_language)
        id, language = id_with_language.split('_')
        cached_article = @redis.get_article(id_with_language)
        
        return cached_article unless cached_article.nil?
      
        article_data = @unit_repository.article.get({ id: id })
        return nil if article_data.nil?
      
        if article_data.language != language
          article_data = @translator.translate_article(article_data, language)
        end
      
        @redis.set_article(article_data.to_json, language)
        article_data
    end
end

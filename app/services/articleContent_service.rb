require 'json'
require_relative './redis_service'
require_relative '../models/api/api_response'
require_relative '../repositories/unit_repository'

class ArticleContentService
  def initialize(redis_service, unit_repository, messages, translator)
    @messages = messages
    @redis = redis_service
    @translator = translator
    @unit_repository = unit_repository
  end

  def get_by_id(id_with_language)
    cached_article = @redis.get_article_content(id_with_language)
    
    if !cached_article.nil?
      return JSON.parse(cached_article, symbolize_names: true)
    else
      id, language = id_with_language.split('_')
      article_data = @unit_repository.articleContent.get({ article_id: id }, [ :content, ])
      return nil if article_data.nil?
      
      article_language = @unit_repository.article.get({ id: id }, [ :language, ])
      if(article_language != language)
        article_data = @translator.translate(article_data, article_language, language)
      end

      article = { article_id: id, content: article_data }
      @redis.set_articles_content(article, language)
      return article
    end 
  end
end

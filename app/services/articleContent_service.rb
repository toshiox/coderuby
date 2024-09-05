require 'json'
require_relative './redis_service'
require_relative '../models/api/api_response'
require_relative '../repositories/unit_repository'

class ArticleContentService
  def initialize(redis_service, unit_repository, messages)
    @messages = messages
    @redis = redis_service
    @unit_repository = unit_repository
  end

  def get_by_id(id_with_language)
    id, language = id_with_language.split('_')
    cached_article = @redis.get_article_content(id_with_language)
    
    if !cached_article.nil?
      return JSON.parse(cached_article, symbolize_names: true)
    else
      article_data = @unit_repository.articleContent.get({ article_id: id }, [ :article_id, :content, :created_at ])
      return nil if article_data.nil?
  
      article = { article_id: article_data[0], content: article_data[1], created_at: article_data[2], language: language }
      @redis.set_articles_content(article.to_json, language)
      
      return article
    end 
  end

  # def add(data)
  #   begin
  #       @article_repository.insert(data)
  #       ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
  #   rescue => en
  #       ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
  #   end
  # end

  # def update(data)
  #   begin
  #       if data['id'].nil? || (data['id'].respond_to?(:empty?) && data['id'].empty?)
  #           return ApiResponse.new(false, @messages['en']['repository']['error']['idNull'], nil)
  #       end

  #       updated_document = @article_repository.find_and_update({ '_id' => BSON::ObjectId(data['id']) }, data)

  #       if updated_document
  #           return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
  #       else
  #           return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
  #       end
  #   rescue => en
  #       return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
  #   end
  # end

  # def get_content(data)
  #   begin
  #     result = @article_repository.find_one({ "articleId" => data["id"] }).to_json
  #     return result["content"]
  #   rescue => en
  #     ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
  #   end
  # end
end

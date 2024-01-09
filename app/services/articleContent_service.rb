require 'json'
require_relative './redis_service'
require_relative './tradutor_service'
require_relative '../models/api/api_response'
require_relative '../repositories/article_repository'

class ArticleContentService
  def initialize
    @redis = RedisService.new
    @tradutor = TradutorService.new
    @article_repository = ArticleRepository.new('articleContent')
    @messages = YAML.load_file('../config/friendlyMessages.yml')
  end

  def get_by_id(data)
    begin
      ApiResponse.new(true, @messages['en']['repository']['success']['find'], @article_repository.find_one(articleId: data['articleId']))
    rescue => en
      ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
    end
  end

  def add(data)
    begin
        @article_repository.insert(data)
        ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
    rescue => en
        ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
    end
  end

  def update(data)
    begin
        if data['id'].nil? || (data['id'].respond_to?(:empty?) && data['id'].empty?)
            return ApiResponse.new(false, @messages['en']['repository']['error']['idNull'], nil)
        end

        updated_document = @article_repository.find_and_update({ '_id' => BSON::ObjectId(data['id']) }, data)

        if updated_document
            return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
        else
            return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
        end
    rescue => en
        return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
    end
  end

  def get_content(data)
    begin
      result = @article_repository.find_one({ "articleId" => data["id"] }).to_json
      puts result
      return result["content"]
    rescue => en
      ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
    end
  end
end

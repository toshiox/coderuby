require 'json'
require_relative './redis_service'
require_relative './translator_service'
require_relative '../models/api/api_response'
require_relative '../repositories/article_repository'
require_relative './article_format'
class ArticleService
    def initialize
        @redis = RedisService.new
        @translator = TranslatorService.new
        @article_repository = ArticleRepository.new('article')
        @articleContent_repository = ArticleRepository.new('articleContent')
        @messages = YAML.load_file('./config/friendlyMessages.yml')
        @articleFormat = ArticleFormat.new
    end

    def list_all(language)
        begin
          articles = @article_repository.find().to_a
          articles.map! do |item|
            text = @articleContent_repository.find_one({ "articleId" => item["id"] })

            item["contentId"] = text["id"]
            item["content"] = text["content"]

            if item['language'] != language
              if @articleFormat.need_format(text["content"])
                text_without_code, code_blocks = @articleFormat.remove_and_store_code_blocks(text["content"])
                translated_content = @translator.translate(text_without_code, item['language'], language)
                item["content"] = @articleFormat.restore_code_blocks(translated_content, code_blocks)
              else
                item["content"] = @translator.translate(text["content"], item['language'], language)
              end

              ['tags', 'title', 'resume', 'subtitle'].each do |field|
                item[field] = @translator.translate(item[field], item['language'], language)
              end
            end

            item['writtenLanguage'] = language == 'en' ? 'English' : 'Inglês'
            item['language'] = language

            item
          end
          @redis.set_articles(articles.to_json, language)
          ApiResponse.new(true, @messages['en']['repository']['success']['find'], articles)
        rescue => e
          ApiResponse.new(false, @messages['en']['repository']['error']['find'], nil)
        end
    end

    def get_by_id(id)
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @article_repository.find_one(_id: BSON::ObjectId(id)))
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
            puts data
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

    def delete(id)
        begin
            if @article_repository.any(_id: BSON::ObjectId(id))
                @article_repository.delete(_id: BSON::ObjectId(id))
                ApiResponse.new(true, @messages['en']['repository']['success']['delete'] %  { id: id }, nil)
            else
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            end
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
        end
    end
end

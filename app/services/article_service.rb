require 'json'
require_relative './redis_service'
require_relative './tradutor_service'
require_relative '../models/api/api_response'
require_relative '../repositories/article_repository'
class ArticleService
    def initialize
        @redis = RedisService.new
        @tradutor = TradutorService.new
        @article_repository = ArticleRepository.new('article')
        @articleContent_repository = ArticleRepository.new('articleContent')
        @messages = YAML.load_file('../config/friendlyMessages.yml')
    end

    def list_all(language)
        begin
            articles = (@article_repository.find().to_a).sort_by{|article| article["createdAt"] }.reverse
            articles.map! do |item|
                text = @articleContent_repository.find_one({ "articleId" => item["id"] })
                item["content"] = text["content"]
                if item['language'] != language
                    ['tags', 'title', 'resume', 'subtitle'].each do |field|
                        item[field] = @tradutor.translate(item[field], item['language'], language)
                    end
                    item["content"] =  @tradutor.translate(text["content"], item['language'], language)
                end

                if item['language'] == 'en'
                    item['writtenLanguage'] = 'English'

                elsif item['language'] == 'pt'
                    item['writtenLanguage'] = 'Português'
                end

                item['language'] = language
                item
            end
            @redis.set_articles(articles.to_json, language);
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], articles)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
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

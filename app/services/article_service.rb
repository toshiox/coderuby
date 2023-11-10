require 'json'
require 'redis'
require_relative './translate_service'
require_relative '../models/api/api_response'
require_relative '../repositories/article_repository'
class ArticleService
    def initialize
        @translate = TranslateService.new
        @article_repository = ArticleRepository.new('article')
        @messages = YAML.load_file('../config/friendlyMessages.yml')
    end

    def ListAll(language)
        begin
            articles = @article_repository.find().to_a
            articles.map! do |item|
                if item['language'] != language
                    item['title'] = @translate.translate(item['title'], item['language'], language);
                    item['subtitle'] = @translate.translate(item['subtitle'], item['language'], language);
                    item['resume'] = @translate.translate(item['resume'], item['language'], language);
                    item['timeRead'] = item['timeRead'];
                    item['tags'] = @translate.translate(item['tags'], item['language'], language);
                    item['language'] = item['language'];
                end
                item
            end
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], articles)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def GetById(id)
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @article_repository.find_one(_id: BSON::ObjectId(id)))
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def Add(data)
        begin
            @article_repository.insert(data)
            ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
        rescue => en 
            ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
        end
    end

    def Update(data)
        begin
            if data['id'].nil? || (data['id'].respond_to?(:empty?) && data['id'].empty?)
                return ApiResponse.new(false, @messages['en']['repository']['error']['idNull'], nil)
            end

            if @article_repository.any(_id: BSON::ObjectId(data['id']))
                @article_repository.update({ '_id' => BSON::ObjectId(data['id']) }, { '$set' => data })
                return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
            else
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            end
        rescue => en
            return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
        end
    end

    def Delete(id)
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
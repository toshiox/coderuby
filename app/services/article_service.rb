require_relative '../models/api/api_response'
require_relative '../repositories/article_repository'
class ArticleService
    def initialize
        @article_repository = ArticleRepository.new
        @messages = YAML.load_file('../config/friendlyMessages.yml')
    end

    def ListAll
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @article_repository.ListAll)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def GetById(id)
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @article_repository.GetById(id))
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def Add(data)
        begin
            @article_repository.Add(data)
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

            article = GetById(data['id'])
            if article.nil?
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            else
                @article_repository.Update(data)
                return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
            end
        rescue => en
            return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
        end
    end

    def Delete(id)
        begin
            article = GetById(id);
            if(article.nil?)
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            else
                @article_repository.Delete(id)
                ApiResponse.new(true, @messages['en']['repository']['success']['delete'] %  { id: id }, nil)
            end
        rescue => en 
            ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
        end
    end
end
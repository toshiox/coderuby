require 'json'
require_relative './redis_service'
require_relative '../models/api/api_response'
require_relative '../repositories/unit_repository'

class ArticleService
    def initialize(redis_service, unit_repository, messages)
        @messages = messages
        @redis = redis_service
        @unit_repository = unit_repository
    end

    def list_all_articles(language)
        all_articles = @redis.list_all_articles(language)
        if(!all_articles.nil?)
            return all_articles  
        else
            articles = @unit_repository.article.to_array({ language: language })
            @redis.set_list_articles(articles.to_json, language)
            return articles
        end
    end

    def get_by_id(id_with_language)
        id, language = id_with_language.split('_')
        cached_article = @redis.get_article(id_with_language)

        if !cached_article.nil?
            return JSON.parse(cached_article, symbolize_names: true)
        else
            article_data = @unit_repository.article.get({ id: id }, [ :title, :subtitle, :resume])
            return nil if article_data.nil?
        
            article = { title: article_data[0], subtitle: article_data[1], resume: article_data[2] }
            @redis.set_article(article.to_json, language)
            
            return article
        end 
    end

    # def list_all(language)
    #     begin
    #       articles = @article_repository.find().to_a
    #       articles.map! do |item|
    #         text = @articleContent_repository.find_one({ "articleId" => item["id"] })

    #         item["contentId"] = text["id"]
    #         item["content"] = text["content"]

    #         if item['language'] != language
    #           if @articleFormat.need_format(text["content"])
    #             text_without_code, code_blocks = @articleFormat.remove_and_store_code_blocks(text["content"])
    #             translated_content = @translator.translate(text_without_code, item['language'], language)
    #             item["content"] = @articleFormat.restore_code_blocks(translated_content, code_blocks)
    #           else
    #             item["content"] = @translator.translate(text["content"], item['language'], language)
    #           end

    #           ['tags', 'title', 'resume', 'subtitle'].each do |field|
    #             item[field] = @translator.translate(item[field], item['language'], language)
    #           end
    #         end

    #         item['writtenLanguage'] = language == 'en' ? 'English' : 'Inglês'
    #         item['language'] = language

    #         item
    #       end
    #       @redis.set_articles(articles.to_json, language)
    #       ApiResponse.new(true, @messages['en']['repository']['success']['find'], articles)
    #     rescue => e
    #       ApiResponse.new(false, @messages['en']['repository']['error']['find'], nil)
    #     end
    # end

   

    # def add(data)
    #     begin
    #         @article_repository.insert(data)
    #         ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
    #     rescue => en
    #         ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
    #     end
    # end

    # def update(data)
    #     begin
    #         puts data
    #         if data['id'].nil? || (data['id'].respond_to?(:empty?) && data['id'].empty?)
    #             return ApiResponse.new(false, @messages['en']['repository']['error']['idNull'], nil)
    #         end

    #         updated_document = @article_repository.find_and_update({ '_id' => BSON::ObjectId(data['id']) }, data)

    #         if updated_document
    #             return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
    #         else
    #             return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
    #         end
    #     rescue => en
    #         return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
    #     end
    # end

    # def delete(id)
    #     begin
    #         if @article_repository.any(_id: BSON::ObjectId(id))
    #             @article_repository.delete(_id: BSON::ObjectId(id))
    #             ApiResponse.new(true, @messages['en']['repository']['success']['delete'] %  { id: id }, nil)
    #         else
    #             return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
    #         end
    #     rescue => en
    #         ApiResponse.new(false, @messages['en']['repository']['error']['insert'], nil)
    #     end
    # end
end

require_relative '../repositories/item_repository'
require_relative '../models/api/api_response'
class ItemService
    def initialize()
        @item_repository = ItemRepository.new
        @messages = YAML.load_file('../config/friendlyMessages.yml')
    end
    
    def ListAll
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @item_repository.ListAll)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def GetById(id)
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['findOne'], @item_repository.GetById(id))
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['findOne'],  nil)
        end
    end

    def AddItems(data)
        begin
            @item_repository.Add(data)
            ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['insert'],  nil)
        end
    end

    def Update(data)
        begin
            item = GetById(data['id'])
            if item.nil?
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            else
                @item_repository.Update(data)
                return ApiResponse.new(true, @messages['en']['repository']['success']['update'], nil)
            end
        rescue => en
            return ApiResponse.new(false, @messages['en']['repository']['error']['update'], nil)
        end
    end

    def Delete(id)
        begin
            item = GetById(id)
            if item.nil?
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            else
                @item_repository.Delete(id)
                return ApiResponse.new(true, @messages['en']['repository']['success']['delete'] % { id: id }, nil)
            end
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['delete'],  nil)
        end
    end
end
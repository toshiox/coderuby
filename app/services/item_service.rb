require_relative '../repositories/item_repository'
require_relative '../models/api/api_response'
class ItemService
    def initialize()
        @item_repository = ItemRepository.new('items')
        @messages = YAML.load_file('../config/friendlyMessages.yml')
    end
    
    def ListAll
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['find'], @item_repository.find().to_a)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['find'],  nil)
        end
    end

    def GetById(id)
        begin
            ApiResponse.new(true, @messages['en']['repository']['success']['findOne'], @item_repository.find_one(_id: BSON::ObjectId(id)))
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['findOne'],  nil)
        end
    end

    def AddItems(data)
        begin
            @item_repository.insert(data)
            ApiResponse.new(true, @messages['en']['repository']['success']['insert'], nil)
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['insert'],  nil)
        end
    end

    def Update(data)
        begin
            if @item_repository.any(_id: BSON::ObjectId(data['id']))
                @item_repository.update({ '_id' => BSON::ObjectId(data['id']) }, { '$set' => data })
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
            query = _id: BSON::ObjectId(id)
            if @item_repository.any(query)
                @item_repository.delete(query)
                return ApiResponse.new(true, @messages['en']['repository']['success']['delete'] % { id: id }, nil)
            else
                return ApiResponse.new(false, @messages['en']['repository']['error']['notExist'], nil)
            end
        rescue => en
            ApiResponse.new(false, @messages['en']['repository']['error']['delete'],  nil)
        end
    end
end
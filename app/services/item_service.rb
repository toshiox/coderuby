require_relative '../repositories/item_repository'

class ItemService
    def initialize()
        @item_repository = ItemRepository.new
    end
    
    def ListAll
        return @item_repository.ListAll
    end

    def GetByid
        return @item_repository.ListAll
    end
end
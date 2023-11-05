class ItemsService
    def initialize()
        @item_repository = ItemRepository.new
    end
    
    def ListAll
        return @item_repository.ListAll
    end
end
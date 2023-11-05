class ItemRepository < BaseMongoRepository
    def initialize()
        super
    end

    def ListAll
        find('items').to_a
    end
    
    def GetByName(name)
        find_one('items', name: BSON::ObjectId(name))
    end
end
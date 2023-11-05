require_relative 'base_mongo_repository'

class ItemRepository < BaseMongoRepository
    def initialize()
        super
    end

    def ListAll
        find('items').to_a
    end
    
    def GetById(name)
        find_one('items', name: BSON::ObjectId(name))
    end
end
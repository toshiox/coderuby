require_relative 'base_mongo_repository'

class ItemRepository < BaseMongoRepository
    def initialize()
        super
    end

    def ListAll
        find('items').to_a
    end
    
    def GetById(id)
        find_one('items', _id: BSON::ObjectId(id))
    end

    def Add(data)
        insert('items', data)
    end

    def Update(data)
        update('items', { '_id' => BSON::ObjectId(data['id']) }, { '$set' => data })
    end

    def Delete(id)
        delete('items', _id: BSON::ObjectId(id))
    end

    def Any(query)
        any('items', query)
    end
end
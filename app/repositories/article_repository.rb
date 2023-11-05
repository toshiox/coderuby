require_relative 'base_mongo_repository'

class ArticleRepository < BaseMongoRepository
    def initialize()
        super
    end

    def ListAll
        find('article').to_a
    end
    
    def GetById(id)
        find_one('article', _id: BSON::ObjectId(id))
    end

    def Add(data)
        insert('article', data)
    end

    def Update(data)
        update('article', { '_id' => BSON::ObjectId(data['id']) }, { '$set' => data })
    end

    def Delete(id)
        delete('article', _id: BSON::ObjectId(id))
    end
    
    def Any(query)
        any('article', query)
    end

end
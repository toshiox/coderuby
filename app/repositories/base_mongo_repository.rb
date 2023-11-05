require 'mongo'

class BaseMongoRepository
  def initialize()
    @client = Mongo::Client.new("mongodb://localhost:27017")
    @database = @client.use("code")
  end

  def find(collection_name, query = {}, options = {})
    @database[collection_name].find(query, options)
  end

  def find_one(collection_name, query)
    @database[collection_name].find(query).first
  end

  def insert(collection_name, data)
    @database[collection_name].insert_one(data)
  end

  def update(collection_name, query, data)
    @database[collection_name].update_one(query, data)
  end

  def delete(collection_name, query)
    @database[collection_name].delete_one(query)
  end

  def any(collection_name, query)
    @database[collection_name].find(query).count > 0
  end
end
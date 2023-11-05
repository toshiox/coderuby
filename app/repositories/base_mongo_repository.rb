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

  def insert_one(collection_name, document)
    @database[collection_name].insert_one(document)
  end

  def update_one(collection_name, query, update)
    @database[collection_name].update_one(query, update)
  end

  def delete_one(collection_name, query)
    @database[collection_name].delete_one(query)
  end
end
require 'mongo'

class BaseMongoRepository
  def initialize(collection_name)
    # @client = Mongo::Client.new("mongodb://localhost:27017")
    @client = Mongo::Client.new("mongodb+srv://toshio-code-mdb:KAI0Lhwwz7uyIw13@toshio-code-cluster.eiyf4y4.mongodb.net/?retryWrites=true&w=majority")
    @database = @client.use("code")
    @collection_name = collection_name
  end

  def find(query = {}, options = {})
    @database[@collection_name].find(query, options)
  end

  def find_one(query)
    @database[@collection_name].find(query).first
  end

  def insert(data)
    @database[@collection_name].insert_one(data)
  end

  def update(query, data)
    @database[@collection_name].update_one(query, data)
  end

  def delete(query)
    @database[@collection_name].delete_one(query)
  end

  def any(query)
    @database[@collection_name].find(query).count > 0
  end

  def find_and_update(query, data)
    @database[@collection_name].find_one_and_update(query, { '$set' => data }, { return_document: :after })
  end
end
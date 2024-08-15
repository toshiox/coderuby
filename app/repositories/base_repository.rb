class BaseRepository
  def initialize(model)
    @model = model
  end

  def find(id)
    @model.find(id)
  end

  def all(query)
    @model.where(query)
  end

  def create(attributes)
<<<<<<< HEAD
    return @model.create(attributes).persisted?
=======
    @model.create(attributes)
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
  end

  def update(id, attributes)
    record = find(id)
<<<<<<< HEAD
    
    if record.nil?
      puts "Record not found with id: #{id}"
      return false
    end
  
    if record.update(attributes)
      puts "Record updated successfully"
      return true
    else
      puts "Failed to update record: #{record.errors.full_messages.join(', ')}"
      return false
    end
=======
    record.update(attributes)
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
  end

  def delete(id)
    record = find(id)
    record.destroy
  end

  def any(query)
    @model.where(query).count > 0
  end

  def get(query, order)
    @model.where(query).order(order).first
  end
<<<<<<< HEAD

  def getOnly(query, selector)
    @model.where(query).pluck(selector)
  end
=======
>>>>>>> caefb8ae84edb03e63330a28c9f25329e44674ae
end
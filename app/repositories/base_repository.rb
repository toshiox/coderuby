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
    return @model.create(attributes).persisted?
  end

  def update(id, attributes)
    record = find(id)
    
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

  def getOnly(query, selector)
    @model.where(query).pluck(selector)
  end
end
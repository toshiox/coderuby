class BaseRepository
  def initialize(model)
    @model = model
  end
  
  def to_array(query)
    @model.where(query).to_a
  end

  def get(query, selector = nil, order = nil)
    result = @model.where(query)
    result = result.order(order) if order
    result = result.pluck(selector) if selector
    result.first
  end

  def next_id
    last_id = @model.maximum(:id)
    last_id ? last_id + 1 : 1
  end
  
  def create(attributes)
    return @model.create(attributes).persisted?
  end
  
  def update(id, attributes)
    record = @model.find(id)
    record.update(attributes)
  end

  def where(query)
    @model.where(query)
  end
  
  # def find(id)
  #   @model.find(id)
  # end


  
  # def delete(id)
  #   record = find(id)
  #   record.destroy
  # end

  # def any(query)
  #   @model.where(query).count > 0
  # end

 

  # def getOnly(query, selector)
  #   @model.where(query).pluck(selector)
  # end
end
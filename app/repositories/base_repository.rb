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
    @model.create(attributes)
  end

  def update(id, attributes)
    record = find(id)
    record.update(attributes)
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
end
require './services/item_service'

class ItemsController < Sinatra::Base
  item_service = ItemService.new

  get '/api/items' do
    content_type :json
    items = item_service.ListAll.to_json
  end

  get '/api/items/:id' do |id|
    content_type :json
    items = item_service.GetById(id).to_json
  end

  post '/api/items' do 
    content_type :json
    request.body.rewind
    items = item_service.AddItems(JSON.parse(request.body.read)).to_json
  end

  put '/api/items' do content_type :json
    content_type :json
    request.body.rewind
    items = item_service.Update(JSON.parse(request.body.read)).to_json
  end

  delete '/api/items/:id' do |id|
    content_type :json
    items = item_service.Delete(id).to_json
  end
end

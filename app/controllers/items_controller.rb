require 'sinatra/base'
require '../services/item_service'

class ItemsController < Sinatra::Base
  item_service = ItemService.new

  get '/api/hello' do
    content_type :json
    items = item_service.ListAll
    items.to_json
  end

  get '/api/items' do
    content_type :json
    items = item_service.ListAll
    items.to_json
  end

  run! if app_file == $0
end

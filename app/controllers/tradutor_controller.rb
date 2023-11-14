require './services/tradutor_service'
class TradutorController < Sinatra::Base
    tradutor_service = TradutorService.new

    get '/api/tradutor' do
        content_type :json
        items = tradutor_service.translate("flowers are purple",'en','pt').to_json
    end
end
require './services/tradutor_service'
class TranslateController < Sinatra::Base
    translate_service = TradutorService.new

    get '/api/translate' do
        content_type :json
        items = translate_service.translate("flowers are purple",'en','pt').to_json
    end
end
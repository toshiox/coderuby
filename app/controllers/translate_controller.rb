require './services/translate_service'
class TranslateController < Sinatra::Base
    translate_service = TranslateService.new

    get '/api/translate' do
        content_type :json
        items = translate_service.translate("flowers are purple",'en','pt').to_json
    end
end
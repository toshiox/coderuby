require 'json'
require 'httparty'

class TranslateService
    def translate(text, from, to)
        location = "eastus"
        key = "dd0e220a186f4955aeb16a7a28e97c5c"
        endpoint = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=#{from}&to=#{to}"
        request_body = [{ Text: text }].to_json
        headers = {
          "Ocp-Apim-Subscription-Key" => key,
          "Ocp-Apim-Subscription-Region" => location,
          "Content-Type" => "application/json"
        }
        response = HTTParty.post(endpoint, body: request_body, headers: headers)

        result = JSON.parse(response.body)

        return result[0]["translations"][0]["text"]
    end
end
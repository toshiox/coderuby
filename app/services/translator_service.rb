require 'json'
require 'httparty'

class TranslatorService
  def initialize(unit_utils)
    @unit_utils = unit_utils
  end

  def translate(text, from, to)
    location = "eastus"
    key = "a6838566a71f42e6ac8dbe8146a9ee37"
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

  def translate_article(article, language)
    article.tags = translate(article.tags, article.language, language)
    article.title = translate(article.title, article.language, language)
    article.resume = translate(article.resume, article.language, language)
    article.subtitle = translate(article.subtitle, article.language, language)
    article.language = @unit_utils.articleFormat.dictionary(article.language, language)
    article
  end
end
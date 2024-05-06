require './repositories/unit_repository'
require_relative '../models/api/api_response'
class ArticleViewsService
  def initialize
    @unit = UnitRepository.new
    @messages = YAML.load_file('./config/friendlyMessages.yml')
  end

  def updateViews(ip_address, articleId)
    query = {
      'articleId' => articleId,
      'ipAddress' => ip_address,
      'view_date' => { '$gte' => (Time.now - 24 * 3600) }
    }
    unless @unit.articleViews.any(query) && ip_address == "127.0.0.1"
      data = {
        'articleId' => articleId,
        'view_date' => Time.now,
        'ipAddress' => ip_address
      }
      if @unit.articleViews.find_and_upsert(query, data)
        views = @unit.articleViews.find({ 'articleId' => articleId }).count
        @unit.article.update({ 'id' => articleId }, { '$set' => { "views" => views } }).to_s
      end
    end
    return ApiResponse.new(true, @messages['en']['repository']['success']['updateViews'], nil).to_json
  end
end

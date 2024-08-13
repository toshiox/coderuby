require './repositories/unit_repository'
require_relative '../models/api/api_response'
class ArticleViewsService
  def initialize
    @unit = UnitRepository.new
    @messages = YAML.load_file('./config/friendlyMessages.yml')
  end

  def updateViews(ip_address, articleId)
    view = @unit.articleViews.get({ articleId: articleId, ipAddress: ip_address }, view_date: :desc)

    unless view.view_date < (Time.now - 24*60*60) #&& ip_address == "127.0.0.1"
      data = {
        'articleId' => articleId,
        'view_date' => Time.now,
        'ipAddress' => ip_address
      }
      puts @unit.articleViews.create(data)
      # if @unit.articleViews.create(data)
      #   views = @unit.articleViews.find({ 'articleId' => articleId }).count
      #   @unit.article.update({ id: articleId }, { '$set' => { "views" => views } }).to_s
      # end
    end
    return ApiResponse.new(true, @messages['en']['repository']['success']['updateViews'], nil).to_json
  end
end
